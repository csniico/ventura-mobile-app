import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/data/models/business_type.dart';
import 'package:ventura/features/auth/presentation/cubit/business_creation_cubit.dart';
import 'package:ventura/features/auth/presentation/widgets/step_progress_indicator.dart';

class CreateBusinessName extends StatefulWidget {
  final PageController pageController;

  const CreateBusinessName({super.key, required this.pageController});

  @override
  State<CreateBusinessName> createState() => _CreateBusinessNameState();
}

class _CreateBusinessNameState extends State<CreateBusinessName> {
  final _formKey = GlobalKey<FormState>();
  late var selectedType = BusinessType.retail;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepProgressIndicator(
                controller: widget.pageController,
                totalSteps: 3,
              ),
              const SizedBox(height: 40),
              Text(
                'Tell us who you are',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: Text(
                  'Every great business starts with a name and a niche.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Business Name',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 5),
              BlocBuilder<BusinessCreationCubit, BusinessCreationState>(
                builder: (context, state) {
                  return TextFormField(
                    initialValue: state.draft.name,
                    onChanged: (value) {
                      context.read<BusinessCreationCubit>().businessNameChanged(
                        value,
                      );
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      context.read<BusinessCreationCubit>().businessNameChanged(
                        value!,
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: 'Enter your business name',
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                'What best describes your business?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 5),
              _dropDownComponent(),
              const SizedBox(height: 80),
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
          ),
        ),
      ),
    );
  }

  Widget _dropDownComponent() {
    return BlocBuilder<BusinessCreationCubit, BusinessCreationState>(
      builder: (context, state) {
        final currentCategory = state.draft.categories?.isNotEmpty == true
            ? BusinessType.fromLabel(state.draft.categories!.first)
            : BusinessType.retail;

        return FormField<BusinessType>(
          initialValue: currentCategory,
          onSaved: (value) {
            if (value != null) {
              context.read<BusinessCreationCubit>().businessCategoryChanged(
                value.label,
              );
            }
          },
          builder: (FormFieldState<BusinessType> fieldState) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownMenu<BusinessType>(
                      initialSelection: fieldState.value,
                      width: constraints.maxWidth,
                      leadingIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: HugeIcon(
                          icon:
                              fieldState.value?.icon ??
                              BusinessType.retail.icon,
                          size: 20,
                        ),
                      ),
                      onSelected: (newValue) {
                        fieldState.didChange(
                          newValue,
                        ); // Updates local form state
                        if (newValue != null) {
                          context
                              .read<BusinessCreationCubit>()
                              .businessCategoryChanged(newValue.label);
                        }
                      },
                      dropdownMenuEntries: BusinessType.values.map((type) {
                        return DropdownMenuEntry<BusinessType>(
                          value: type,
                          label: type.label,
                          labelWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                type.label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                type.description,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    if (fieldState.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 12),
                        child: Text(
                          fieldState.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
