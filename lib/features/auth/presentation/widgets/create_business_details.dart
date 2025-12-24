import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventura/core/presentation/pages/main_screen.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/cubit/business_creation_cubit.dart';
import 'package:ventura/features/auth/presentation/widgets/image_picker_canvas.dart';
import 'package:ventura/features/auth/presentation/widgets/step_progress_indicator.dart';

class CreateBusinessDetails extends StatefulWidget {
  final PageController pageController;

  const CreateBusinessDetails({super.key, required this.pageController});

  @override
  State<CreateBusinessDetails> createState() => _CreateBusinessDetailsState();
}

class _CreateBusinessDetailsState extends State<CreateBusinessDetails> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  pickImage(File pickedFile) {
    context.read<BusinessCreationCubit>().businessLogoChanged(pickedFile);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessCreationCubit, BusinessCreationState>(
      listener: (context, state) {
        switch (state) {
          case BusinessCreateFailed():
            ToastService.showError(state.message);
            break;
          case BusinessCreateSuccess():
            ToastService.showSuccess('Business profile created successfully');
            context.read<AuthBloc>().add(UserProfileCreateSuccess(user: state.user, business: state.business));
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MainScreen()),
              (_) => false,
            );
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        return BlocBuilder<BusinessCreationCubit, BusinessCreationState>(
          builder: (context, state) {
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
                        'Tell us about your business',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: Text(
                          'Your logo is the visual identity of your business. '
                          'A compelling description helps customers understand what you offer.',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Tag line',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        initialValue: state.draft.tagLine,
                        onChanged: (value) {
                          context
                              .read<BusinessCreationCubit>()
                              .businessTagLineChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your business tag line';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          context
                              .read<BusinessCreationCubit>()
                              .businessTagLineChanged(value!);
                        },
                        decoration: const InputDecoration(
                          hintText: "eg. Zoey's - Empowering Your Business",
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Business Description',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextFormField(
                        initialValue: state.draft.description,
                        onChanged: (value) {
                          context
                              .read<BusinessCreationCubit>()
                              .businessDescriptionChanged(value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your business description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          context
                              .read<BusinessCreationCubit>()
                              .businessDescriptionChanged(value!);
                        },
                        maxLines: null,
                        minLines: 4,
                        maxLength: 2000,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          hintText: 'Enter description',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Business Logo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<BusinessCreationCubit, BusinessCreationState>(
                        builder: (context, state) {
                          debugPrint(
                            'BlocBuilder rebuild - logo: ${state.draft.logo}',
                          );
                          return ImagePickerCanvas(
                            onTap: state.isLoading == true
                                ? () {}
                                : () async {
                                    final XFile? pickedFile = await _picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      pickImage(File(pickedFile.path));
                                    }
                                  },
                            onRemove: () {
                              debugPrint('Remove logo');
                              context
                                  .read<BusinessCreationCubit>()
                                  .businessLogoChanged(null);
                            },
                            imagePath: state.draft.logo,
                            isLoading: state.isLoading == true,
                          );
                        },
                      ),
                      const SizedBox(height: 80),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            context
                                .read<BusinessCreationCubit>()
                                .createBusinessProfile();
                          }
                        },
                        child: const Text('Finish'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
