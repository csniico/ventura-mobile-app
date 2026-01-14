import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/edit_customer.dart';
import 'package:ventura/init_dependencies.dart';

class ViewCustomer extends StatefulWidget {
  const ViewCustomer({super.key, required this.customerId});
  final String customerId;

  @override
  State<ViewCustomer> createState() => _ViewCustomerState();
}

class _ViewCustomerState extends State<ViewCustomer> {
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
      // Load customer data after getting business ID
      if (mounted) {
        context.read<CustomerBloc>().add(
          CustomerGetByIdEvent(
            customerId: widget.customerId,
            businessId: _businessId,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<CustomerBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('Customer Details'),
          leading: IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedEdit02,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        EditCustomer(customerId: widget.customerId),
                  ),
                );
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
                          CustomerGetByIdEvent(
                            customerId: widget.customerId,
                            businessId: _businessId,
                          ),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is CustomerLoadedState) {
              final customer = state.customer;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              radius: 32,
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedUser,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Customer ID: ${customer.id}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Contact Information Card
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact Information',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            if (customer.email != null) ...[
                              _buildInfoRow(
                                context,
                                HugeIcons.strokeRoundedMail01,
                                'Email',
                                customer.email!,
                              ),
                              const Divider(height: 24),
                            ],
                            if (customer.phone != null) ...[
                              _buildInfoRow(
                                context,
                                HugeIcons.strokeRoundedCall,
                                'Phone',
                                customer.phone!,
                              ),
                              const Divider(height: 24),
                            ],
                            _buildInfoRow(
                              context,
                              HugeIcons.strokeRoundedCalendar01,
                              'Created',
                              _formatDate(customer.createdAt),
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              HugeIcons.strokeRoundedPencilEdit02,
                              'Last Updated',
                              _formatDate(customer.updatedAt),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Notes Card (if notes exist)
                    if (customer.notes != null &&
                        customer.notes!.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notes',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                customer.notes!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    dynamic icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HugeIcon(
          icon: icon,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
