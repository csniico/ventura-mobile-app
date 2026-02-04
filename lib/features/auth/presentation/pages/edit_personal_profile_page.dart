import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/services/toast_service.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/cubit/user_profile_cubit.dart';
import 'package:ventura/features/auth/presentation/widgets/auth_field.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_user_image.dart';
import 'package:ventura/features/auth/presentation/widgets/submit_form_button.dart';
import 'package:ventura/init_dependencies.dart';

class EditPersonalProfilePage extends StatefulWidget {
  const EditPersonalProfilePage({super.key});

  @override
  State<EditPersonalProfilePage> createState() =>
      _EditPersonalProfilePageState();
}

class _EditPersonalProfilePageState extends State<EditPersonalProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fistNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String? _uploadedAvatarUrl;

  void _pickAndUploadImage(File pickedFile, User user) async {
    // Upload image using UserProfileCubit
    context.read<UserProfileCubit>().uploadAvatar(imageFile: pickedFile);
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state;
    if (user is Authenticated) {
      _fistNameController.text = user.user.firstName;
      _lastNameController.text = user.user.lastName ?? '';
    }
  }

  @override
  void dispose() {
    _fistNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<UserProfileCubit>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(8.0),
            child: const SizedBox(height: 8.0),
          ),
          leading: IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Edit Personal Profile',
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        body: SafeArea(
          child: BlocListener<UserProfileCubit, UserProfileState>(
            listener: (context, profileState) {
              if (profileState is UserProfileAvatarUploaded) {
                // Store uploaded avatar URL
                setState(() {
                  _uploadedAvatarUrl = profileState.imageUrl;
                });
                ToastService.showSuccess('Avatar uploaded successfully');
              } else if (profileState is UserProfileUpdated) {
                // Update AuthBloc session with new user data
                context.read<AuthBloc>().add(
                  AuthSessionUpdated(profileState.user),
                );
                ToastService.showSuccess('Profile updated successfully');
                Navigator.pop(context);
              } else if (profileState is UserProfileError) {
                ToastService.showError(profileState.message);
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return BlocBuilder<UserProfileCubit, UserProfileState>(
                    builder: (context, profileState) {
                      final isLoading =
                          profileState is UserProfileUploading ||
                          profileState is UserProfileUpdating;

                      return Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  ProfileUserImage(
                                    profileHeight: 144,
                                    imageUrl:
                                        _uploadedAvatarUrl ??
                                        state.user.avatarUrl,
                                  ),
                                  if (profileState is UserProfileUploading)
                                    Positioned(
                                      child: Container(
                                        width: 144,
                                        height: 144,
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    top: 144 - 144 / 3,
                                    right: 144 + 10,
                                    child: GestureDetector(
                                      onTap: isLoading
                                          ? null
                                          : () async {
                                              final XFile? pickedFile =
                                                  await ImagePicker().pickImage(
                                                    source: ImageSource.gallery,
                                                  );
                                              if (pickedFile != null) {
                                                _pickAndUploadImage(
                                                  File(pickedFile.path),
                                                  state.user,
                                                );
                                              }
                                            },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: isLoading
                                              ? Colors.grey
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                          border: Border.all(
                                            width: 2,
                                            color: isLoading
                                                ? Colors.grey
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                          ),
                                        ),
                                        child: Center(
                                          child: HugeIcon(
                                            color: Colors.white24,
                                            icon: HugeIcons
                                                .strokeRoundedCameraAdd01,
                                            size: 24,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      AuthField(
                                        controller: _fistNameController,
                                        hintText: state.user.firstName,
                                        onSaved: (value) {},
                                        title: 'First name',
                                      ),
                                      SizedBox(height: 30),
                                      AuthField(
                                        controller: _lastNameController,
                                        hintText: state.user.lastName ?? '',
                                        onSaved: (value) {},
                                        title: 'Last name',
                                      ),
                                      SizedBox(height: 30),
                                      SubmitFormButton(
                                        title: isLoading ? 'Saving...' : 'Save',
                                        onPressed: () {
                                          if (isLoading) return;
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final currentAvatarUrl =
                                                _uploadedAvatarUrl ??
                                                state.user.avatarUrl;
                                            context
                                                .read<UserProfileCubit>()
                                                .updateProfile(
                                                  userId: state.user.id,
                                                  firstName:
                                                      _fistNameController.text,
                                                  lastName:
                                                      _lastNameController.text,
                                                  avatarUrl: currentAvatarUrl,
                                                );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }
                return Center(child: Text('Loading...'));
              },
            ),
          ),
        ),
      ),
    );
  }
}
