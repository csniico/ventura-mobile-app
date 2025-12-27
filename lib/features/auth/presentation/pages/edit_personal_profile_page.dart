import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_user_image.dart';

class EditPersonalProfilePage extends StatefulWidget {
  const EditPersonalProfilePage({super.key});

  @override
  State<EditPersonalProfilePage> createState() =>
      _EditPersonalProfilePageState();
}

class _EditPersonalProfilePageState extends State<EditPersonalProfilePage> {
  pickImage(File pickedFile, User user) {
    context.read<AuthBloc>().add(
      UserAvatarProfileChanged(file: pickedFile, user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text('Edit Personal Profile')),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is AuthSuccess) {
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
