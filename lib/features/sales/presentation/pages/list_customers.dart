import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/pages/view_customer.dart';
import 'package:ventura/features/sales/presentation/pages/create_customers.dart';

class ListCustomers extends StatelessWidget {
  const ListCustomers({super.key});

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

  @override
  Widget build(BuildContext context) {
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
          if (state.customers.isEmpty) {
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
                  ),
                ),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: state.customers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final customer = state.customers[index];
                return Card(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
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
                      backgroundColor: _getCustomerAvatarColor(customer),
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
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        customer.phone ?? customer.email ?? 'No contact info',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowRight01,
                      size: 20,
                    ),
                  ),
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
