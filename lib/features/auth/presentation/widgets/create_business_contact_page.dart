import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/features/auth/presentation/cubit/business_creation_cubit.dart';
import 'package:ventura/features/auth/presentation/widgets/step_progress_indicator.dart';

class CreateBusinessContactPage extends StatefulWidget {
  final PageController pageController;
  final User user;

  const CreateBusinessContactPage({
    super.key,
    required this.pageController,
    required this.user,
  });

  @override
  State<CreateBusinessContactPage> createState() =>
      _CreateBusinessContactPageState();
}

class _CreateBusinessContactPageState extends State<CreateBusinessContactPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
          child: BlocBuilder<BusinessCreationCubit, BusinessCreationState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepProgressIndicator(
                    controller: widget.pageController,
                    totalSteps: 3,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Where to find you and how to contact you',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: Text(
                      'Help customers connect with your physical or digital storefront.',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _textInputField(
                    initialValue:
                        state.draft.address ??
                        widget.user.business?.address ??
                        '',
                    title: 'Address *',
                    hint: 'eg. Madina, near post office',
                    onChanged: (value) {
                      context
                          .read<BusinessCreationCubit>()
                          .businessAddressChanged(value!);
                    },
                    onSaved: (value) {
                      context
                          .read<BusinessCreationCubit>()
                          .businessAddressChanged(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business address';
                      }
                      return null;
                    },
                  ),
                  _textInputField(
                    initialValue:
                        state.draft.country ??
                        widget.user.business?.country ??
                        '',
                    title: 'Country',
                    hint: 'eg. Ghana',
                    onChanged: (value) {
                      context
                          .read<BusinessCreationCubit>()
                          .businessCountryChanged(value!);
                    },
                    onSaved: (value) {
                      context
                          .read<BusinessCreationCubit>()
                          .businessCountryChanged(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your country';
                      }
                      return null;
                    },
                  ),
                  _textInputField(
                    initialValue:
                        state.draft.state ?? widget.user.business?.state ?? '',
                    title: 'State/Region',
                    hint: 'eg. Greater Accra',
                    onChanged: (value) {
                      context
                          .read<BusinessCreationCubit>()
                          .businessStateChanged(value!);
                    },
                    onSaved: (value) {
                      context
                          .read<BusinessCreationCubit>()
                          .businessStateChanged(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your state or region';
                      }
                      return null;
                    },
                  ),
                  _textInputField(
                    initialValue:
                        state.draft.city ?? widget.user.business?.city ?? '',
                    title: 'City',
                    hint: 'eg. Accra',
                    onChanged: (value) {
                      context.read<BusinessCreationCubit>().businessCityChanged(
                        value!,
                      );
                    },
                    onSaved: (value) {
                      context.read<BusinessCreationCubit>().businessCityChanged(
                        value!,
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your city';
                      }
                      return null;
                    },
                  ),
                  _textInputField(
                    initialValue:
                        state.draft.email ?? widget.user.business?.email ?? '',
                    title: 'Business Email (optional',
                    hint: 'eg. user@ventura.com',
                    onChanged: (value) {
                      context
                          .read<BusinessCreationCubit>()
                          .businessEmailChanged(value!);
                    },
                    onSaved: (value) {
                      context
                          .read<BusinessCreationCubit>()
                          .businessEmailChanged(value!);
                    },
                    validator: (value) {
                      return null;
                    },
                  ),
                  _textInputField(
                    initialValue:
                        state.draft.phone ?? widget.user.business?.phone ?? '',
                    title: 'Business Phone Number',
                    hint: 'eg. +233 24 000 0000',
                    onChanged: (value) {
                      context
                          .read<BusinessCreationCubit>()
                          .businessPhoneChanged(value!);
                    },
                    onSaved: (value) {
                      context
                          .read<BusinessCreationCubit>()
                          .businessPhoneChanged(value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business phone number';
                      }
                      return null;
                    },
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        widget.pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: const Text('Next'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _textInputField({
    required String initialValue,
    required String title,
    required String hint,
    required Function(String?) onChanged,
    required Function(String?) onSaved,
    required FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(hintText: hint),
          onSaved: onSaved,
          onChanged: onChanged,
          validator: validator,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
