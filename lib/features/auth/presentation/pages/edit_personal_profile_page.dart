import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/widgets/auth_field.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_user_image.dart';
import 'package:ventura/features/auth/presentation/widgets/submit_form_button.dart';

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

  pickImage(File pickedFile, User user) {
    context.read<AuthBloc>().add(
      UserAvatarProfileChanged(file: pickedFile, user: user),
    );
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
    return Scaffold(
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
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is Authenticated) {
              return Column(
                children: [
                  //   image
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
                            imageUrl: state.user.avatarUrl,
                          ),
                          Positioned(
                            top: 144 - 144 / 3,
                            right: 144 + 10,
                            child: GestureDetector(
                              onTap: () async {
                                final XFile? pickedFile = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  pickImage(File(pickedFile.path), state.user);
                                }
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    width: 2,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                                child: Center(
                                  child: HugeIcon(
                                    color: Colors.white24,
                                    icon: HugeIcons.strokeRoundedCameraAdd01,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                title: 'Save',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      EditUserProfileEvent(
                                        user: state.user,
                                        userId: state.user.id,
                                        firstName: _fistNameController.text,
                                        avatarUrl: state.user.avatarUrl,
                                        lastName: _lastNameController.text,
                                      ),
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
                  //   first name
                  //   last name
                ],
              );
            }
            return Center(child: Text('Loading...'));
          },
        ),
      ),
    );
  }
}
