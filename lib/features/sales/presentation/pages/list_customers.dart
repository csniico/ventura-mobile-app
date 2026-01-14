import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/view_customer.dart';
import 'package:ventura/features/sales/presentation/pages/create_customers.dart';
import 'package:ventura/features/sales/presentation/pages/edit_customer.dart';
import 'package:ventura/init_dependencies.dart';

class ListCustomers extends StatefulWidget {
  const ListCustomers({super.key});

  @override
  State<ListCustomers> createState() => _ListCustomersState();
}

class _ListCustomersState extends State<ListCustomers> {
  late String _businessId;

  @override
  void initState() {
    super.initState();
    _loadBusinessId();
  }

  Future<void> _loadBusinessId() async {
    final user = await UserService().getUser();
    if (user != null) {
      setState(() {
        _businessId = user.businessId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          serviceLocator<CustomerBloc>()
            ..add(CustomerGetEvent(businessId: _businessId)),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Customers'),
          actions: [
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedUserAdd01,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreateCustomers(),
                  ),
                );
                if (context.mounted) {
                  context.read<CustomerBloc>().add(
                    CustomerGetEvent(businessId: _businessId),
                  );
                }
              },
            ),
          ],
        ),
        body: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomerLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CustomerErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedAlert02,
                      color: Theme.of(context).colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CustomerBloc>().add(
                          CustomerGetEvent(businessId: _businessId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is CustomerListLoadedState) {
              if (state.customers.isEmpty) {
                return Center(
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
                        'No customers yet',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CreateCustomers(),
                            ),
                          );
                          if (context.mounted) {
                            context.read<CustomerBloc>().add(
                              CustomerGetEvent(businessId: _businessId),
                            );
                          }
                        },
                        child: const Text('Create your first customer'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<CustomerBloc>().add(
                    CustomerGetEvent(businessId: _businessId),
                  );
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.customers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final customer = state.customers[index];
                    return Card(
                      elevation: 2,
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewCustomer(customerId: customer.id),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedUser,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          customer.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            if (customer.email != null)
                              Row(
                                children: [
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedMail01,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      customer.email!,
                                      style: const TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            if (customer.phone != null) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  HugeIcon(
                                    icon: HugeIcons.strokeRoundedCall,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    customer.phone!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: HugeIcon(
                            icon: HugeIcons.strokeRoundedMoreVertical,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onSelected: (value) async {
                            if (value == 'edit') {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditCustomer(customerId: customer.id),
                                ),
                              );
                              if (context.mounted) {
                                context.read<CustomerBloc>().add(
                                  CustomerGetEvent(businessId: _businessId),
                                );
                              }
                            } else if (value == 'delete') {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Customer'),
                                  content: Text(
                                    'Are you sure you want to delete ${customer.name}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true && context.mounted) {
                                context.read<CustomerBloc>().add(
                                  CustomerDeleteEvent(
                                    customerId: customer.id,
                                    businessId: _businessId,
                                  ),
                                );
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
