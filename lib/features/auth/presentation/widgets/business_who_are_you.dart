import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/data/models/business_type.dart';

class BusinessWhoAreYou extends StatefulWidget {
  const BusinessWhoAreYou({super.key});

  @override
  State<BusinessWhoAreYou> createState() => _BusinessWhoAreYouState();
}

class _BusinessWhoAreYouState extends State<BusinessWhoAreYou> {
  final _formKey = GlobalKey<FormState>();
  late var selectedType = BusinessType.retail;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about your business',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: Text(
                'Every great business starts with a name and a niche.',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Business Name',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(hintText: 'Enter your business name'),
            ),
            SizedBox(height: 40),
            Text(
              'What best describes your business?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 5),
            _dropDownComponent(),
          ],
        ),
      ),
    );
  }

  Widget _dropDownComponent() {
    // Use LayoutBuilder to ensure the menu matches the width of the form field
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<BusinessType>(
          initialSelection: selectedType,
          width: constraints.maxWidth,
          // Makes it fill the width
          leadingIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: HugeIcon(
              icon: selectedType.icon,
              size: 20,
              color: Colors.black,
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          // This anchors the menu strictly below the field
          menuStyle: MenuStyle(
            maximumSize: WidgetStateProperty.all(const Size.fromHeight(300)),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
          ),
          onSelected: (BusinessType? newValue) {
            if (newValue != null) {
              setState(() {
                selectedType = newValue;
              });
            }
          },
          dropdownMenuEntries: BusinessType.values.map((type) {
            return DropdownMenuEntry<BusinessType>(
              value: type,
              label: type.label,
              // Customizing the menu item look
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
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
