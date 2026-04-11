import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/presentation/widgets/ventura_app_bar/ventura_app_bar.dart';
import 'package:ventura/core/presentation/widgets/ventura_app_bar/app_bar_type.dart';
import 'package:ventura/features/auth/presentation/cubit/business_creation_cubit.dart';
import 'package:ventura/features/auth/presentation/widgets/create_business_contact_page.dart';
import 'package:ventura/features/auth/presentation/widgets/create_business_details.dart';
import 'package:ventura/features/auth/presentation/widgets/create_business_name.dart';
import 'package:ventura/init_dependencies.dart';

class CreateBusinessProfilePage extends StatefulWidget {
  final User user;
  final bool isUpdating;

  const CreateBusinessProfilePage({
    super.key,
    required this.user,
    this.isUpdating = false,
  });

  @override
  State<CreateBusinessProfilePage> createState() =>
      _CreateBusinessProfilePageState();
}

class _CreateBusinessProfilePageState extends State<CreateBusinessProfilePage> {
  final PageController controller = PageController(initialPage: 0);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (controller.hasClients && controller.page! > 0) {
          controller.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: VenturaAppBar(
          type: AppBarType.secondary,
        ),
        body: SafeArea(
          child: BlocProvider(
            create: (context) =>
                serviceLocator<BusinessCreationCubit>()
                  ..initialize(widget.user),
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: controller,
              children: [
                if (!widget.isUpdating)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Create Business Profile for ${widget.user.firstName}',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: ElevatedButton(
                            onPressed: () {
                              controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text('Get Started'),
                          ),
                        ),
                      ],
                    ),
                  ),
                CreateBusinessName(
                  pageController: controller,
                  user: widget.user,
                ),
                CreateBusinessContactPage(
                  pageController: controller,
                  user: widget.user,
                ),
                CreateBusinessDetails(
                  pageController: controller,
                  user: widget.user,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
