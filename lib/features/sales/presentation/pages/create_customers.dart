import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/core/services/user_service.dart';
import 'package:ventura/features/sales/presentation/bloc/customer_bloc.dart';
import 'package:ventura/features/sales/presentation/widgets/sales_text_input_field.dart';
import 'package:ventura/init_dependencies.dart';

class CreateCustomers extends StatefulWidget {
  const CreateCustomers({super.key});

  @override
  State<CreateCustomers> createState() => _CreateCustomersState();
}

class _CreateCustomersState extends State<CreateCustomers> {
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
        CustomerCreateEvent(
          businessId: _businessId,
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
            'Create Customer',
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
            if (state is CustomerCreateSuccessState) {
              ToastService.showSuccess('Customer created successfully');
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
                    // New Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedIdea01,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Why add a customer?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Customer profiles let you track purchase history, speed up appointment booking, and keep personal notes to build client loyalty.",
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Existing form starts here
                    SalesTextInputField(
                      controller: _nameController,
                      title: 'Customer Name *',
                      hintText: 'eg. Kofi Agyeman',
                      shouldValidate: true,
                      onSaved: (value) {},
                    ),
                    const SizedBox(height: 16),
                    SalesTextInputField(
                      controller: _emailController,
                      title: 'Email (optional)',
                      hintText: 'eg. kofi.agyeman@example.com',
                      inputType: TextInputType.emailAddress,
                      onSaved: (value) {},
                    ),
                    const SizedBox(height: 16),
                    SalesTextInputField(
                      controller: _phoneController,
                      title: 'Phone (optional)',
                      hintText: '0241234567',
                      inputType: TextInputType.phone,
                      onSaved: (value) {},
                    ),
                    const SizedBox(height: 16),
                    SalesTextInputField(
                      controller: _notesController,
                      title: 'Notes (optional)',
                      min: 5,
                      hintText:
                          'e.g. Likes extra spicy food, allergic to peanuts, met at the networking event...',
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
                              'Create Customer',
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
