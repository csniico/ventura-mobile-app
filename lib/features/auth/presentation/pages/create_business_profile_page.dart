import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/core/domain/use_cases/asset_upload_image.dart';
import 'package:ventura/features/auth/presentation/cubit/business_creation_cubit.dart';
import 'package:ventura/features/auth/presentation/widgets/create_business_contact_page.dart';
import 'package:ventura/features/auth/presentation/widgets/create_business_details.dart';
import 'package:ventura/features/auth/presentation/widgets/create_business_name.dart';
import 'package:ventura/init_dependencies.dart';

class CreateBusinessProfilePage extends StatefulWidget {
  final String userId;
  final String firstName;

  const CreateBusinessProfilePage({
    super.key,
    required this.userId,
    required this.firstName,
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(),
        body: SafeArea(
          child: BlocProvider(
            create: (context) => serviceLocator<BusinessCreationCubit>(),
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: controller,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create Business Profile 1 for ${widget.firstName}',
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
                CreateBusinessName(pageController: controller),
                CreateBusinessContactPage(pageController: controller),
                CreateBusinessDetails(pageController: controller),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
