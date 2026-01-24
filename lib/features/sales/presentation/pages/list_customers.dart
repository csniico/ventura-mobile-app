import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/view_customer.dart';
import 'package:ventura/features/sales/presentation/pages/create_customers.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

class ListCustomers extends StatefulWidget {
  const ListCustomers({super.key});

  @override
  State<ListCustomers> createState() => _ListCustomersState();
}

class _ListCustomersState extends State<ListCustomers> {
  final FlutterNativeContactPicker _contactPicker =
      FlutterNativeContactPicker();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _importContacts() async {
    try {
      // Try to select multiple contacts (iOS only)
      List<dynamic>? contacts;
      try {
        contacts = await _contactPicker.selectContacts();
      } catch (e) {
        // If selectContacts() fails (Android), fall back to single contact
        final contact = await _contactPicker.selectContact();
        if (contact != null) {
          contacts = [contact];
        }
      }

      if (contacts == null || contacts.isEmpty) {
        return;
      }

      // Build the customer list from contacts
      final customersToImport = contacts.map((contact) {
        final Map<String, dynamic> customer = {
          'name': contact.fullName ?? 'Unknown',
        };

        // Add phone if available
        if (contact.phoneNumbers != null && contact.phoneNumbers!.isNotEmpty) {
          customer['phone'] = contact.phoneNumbers!.first;
        }

        // Note: flutter_native_contact_picker doesn't provide email
        // If you need email support, consider using contacts_service package

        return customer;
      }).toList();

      if (!mounted) return;

      final businessId = UserService().businessId;
      if (businessId != null) {
        context.read<CustomerBloc>().add(
          CustomerImportEvent(
            businessId: businessId,
            customers: customersToImport,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error importing contacts: $e')));
    }
  }

  Color _getCustomerAvatarColor(dynamic customer) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.indigo,
      Colors.blue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
    ];

    final index = customer.id.hashCode % colors.length;
    return colors[index.abs()];
  }

  List<dynamic> _filterCustomers(List<dynamic> customers) {
    if (_searchQuery.isEmpty) {
      return customers;
    }

    return customers.where((customer) {
      final name = customer.name?.toLowerCase() ?? '';
      final phone = customer.phone?.toLowerCase() ?? '';
      final email = customer.email?.toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();

      return name.contains(query) ||
          phone.contains(query) ||
          email.contains(query);
    }).toList();
  }

  Map<String, List<dynamic>> _groupCustomersByFirstLetter(
    List<dynamic> customers,
  ) {
    final Map<String, List<dynamic>> grouped = {};

    for (var customer in customers) {
      final name = customer.name ?? 'Unknown';
      final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '#';

      if (!grouped.containsKey(firstLetter)) {
        grouped[firstLetter] = [];
      }
      grouped[firstLetter]!.add(customer);
    }

    // Sort each group alphabetically
    grouped.forEach((key, value) {
      value.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    });

    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar and import button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search customers...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _importContacts,
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedUserAdd02,
                  size: 20,
                  color: Colors.white,
                ),
                tooltip: 'Import from contacts',
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
        // Customer list
        Expanded(
          child: BlocListener<CustomerBloc, CustomerState>(
            listener: (context, state) {
              if (state is CustomerImportSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Successfully imported ${state.importedCustomers.length} customer(s)',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                // Reload the customer list
                final businessId = UserService().businessId;
                if (businessId != null) {
                  context.read<CustomerBloc>().add(
                    CustomerGetEvent(businessId: businessId),
                  );
                }
              } else if (state is CustomerErrorState &&
                  state.message.contains('import')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Failed to import contacts: ${state.message}',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: _buildCustomerList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerList() {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state is CustomerLoadingState) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 200),
              Center(child: CircularProgressIndicator()),
            ],
          );
        }

        if (state is CustomerErrorState) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 100),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedAlert02,
                      color: Theme.of(context).colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Error: ${state.message}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pull to refresh',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        if (state is CustomerListLoadedState) {
          final filteredCustomers = _filterCustomers(state.customers);

          if (filteredCustomers.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 100),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedUserMultiple,
                        color: Colors.grey,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _searchQuery.isEmpty
                            ? 'No customers yet'
                            : 'No customers found',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                      ),
                      if (_searchQuery.isEmpty) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CreateCustomers(),
                              ),
                            );
                            if (context.mounted) {
                              final businessId = UserService().businessId;
                              if (businessId != null) {
                                context.read<CustomerBloc>().add(
                                  CustomerGetEvent(businessId: businessId),
                                );
                              }
                            }
                          },
                          child: const Text('Create your first customer'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          }

          final groupedCustomers = _groupCustomersByFirstLetter(
            filteredCustomers,
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: groupedCustomers.length,
              itemBuilder: (context, index) {
                final letter = groupedCustomers.keys.elementAt(index);
                final customers = groupedCustomers[letter]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    // Customers in this section
                    ...customers.map((customer) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Card(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerLowest,
                          elevation: 0,
                          child: ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewCustomer(customer: customer),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: _getCustomerAvatarColor(
                                customer,
                              ),
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedUser,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              customer.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                customer.phone ??
                                    customer.email ??
                                    'No contact info',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            trailing: HugeIcon(
                              icon: HugeIcons.strokeRoundedArrowRight01,
                              size: 20,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          );
        }

        // Initial state - show loading
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 200),
            Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
