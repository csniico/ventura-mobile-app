import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/domain/entities/customer_entity.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/widgets/sales_text_input_field.dart';
import 'package:ventura/init_dependencies.dart';

class EditCustomer extends StatefulWidget {
  const EditCustomer({super.key, required this.customer});
  final Customer customer;

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  late String _businessId;

  @override
  void initState() {
    super.initState();
    _loadBusinessId();
    _nameController.text = widget.customer.name;
    _emailController.text = widget.customer.email ?? '';
    _phoneController.text = widget.customer.phone ?? '';
    _notesController.text = widget.customer.notes ?? '';
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
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<CustomerBloc>().add(
        CustomerUpdateEvent(
          businessId: _businessId,
          customerId: widget.customer.id,
          name: _nameController.text.trim(),
          email: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
          phone: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<CustomerBloc>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(8.0),
            child: const SizedBox(height: 8.0),
          ),
          title: Text(
            'Update Customer',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          leading: IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerUpdateSuccessState) {
              ToastService.showSuccess('Customer updated successfully');
              Navigator.of(context).pop();
            } else if (state is CustomerErrorState) {
              ToastService.showError(state.message);
            }
          },
          builder: (context, state) {
            final isLoading = state is CustomerLoadingState;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Existing form starts here
                    SalesTextInputField(
                      controller: _nameController,
                      title: 'Customer Name *',
                      hintText: _nameController.text.isEmpty
                          ? 'eg. Kofi Agyeman'
                          : _nameController.text,
                      shouldValidate: true,
                      onSaved: (value) {},
                    ),
                    const SizedBox(height: 16),
                    SalesTextInputField(
                      controller: _emailController,
                      title: 'Email (optional)',
                      hintText: _emailController.text.isEmpty
                          ? 'eg. kofi.agyeman@example.com'
                          : _emailController.text,
                      inputType: TextInputType.emailAddress,
                      onSaved: (value) {},
                    ),
                    const SizedBox(height: 16),
                    SalesTextInputField(
                      controller: _phoneController,
                      title: 'Phone (optional)',
                      hintText: _phoneController.text.isEmpty
                          ? '0241234567'
                          : _phoneController.text,
                      inputType: TextInputType.phone,
                      onSaved: (value) {},
                    ),
                    const SizedBox(height: 16),
                    SalesTextInputField(
                      controller: _notesController,
                      title: 'Notes (optional)',
                      min: 5,
                      hintText: _notesController.text.isEmpty
                          ? 'e.g. Likes extra spicy food, allergic to peanuts, met at the networking event...'
                          : _notesController.text,
                      onSaved: (value) {},
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: isLoading ? null : () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Update Customer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
