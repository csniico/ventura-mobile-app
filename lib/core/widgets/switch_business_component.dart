import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/models/business/business.dart';
import 'package:ventura/core/services/business/business_service.dart';
import 'package:ventura/core/widgets/search_bar_component.dart';
import 'package:ventura/core/widgets/text_component.dart';

class SwitchBusinessComponent extends StatefulWidget {
  const SwitchBusinessComponent({
    super.key,
    required this.businesses,
    required this.displayTitle,
    required this.onBusinessSwitch,
  });

  final List<Business> businesses;
  final String? displayTitle;
  final Function(Business) onBusinessSwitch;

  @override
  State<SwitchBusinessComponent> createState() =>
      _SwitchBusinessComponentState();
}

class _SwitchBusinessComponentState extends State<SwitchBusinessComponent> {
  Business? currentBusiness;

  @override
  void initState() {
    super.initState();
    currentBusiness = BusinessService().currentBusiness;
  }

  // The parent now handles all logic and navigation.
  // This method just reports the event.
  void handleBusinessSwitch(Business business) {
    setState(() {
      currentBusiness = business;
    });
    widget.onBusinessSwitch(business);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Center(child: _buildDragHandle()),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: TextComponent(text: 'Switch Business', type: 'title'),
              ),
              SizedBox(height: 12),
              SearchBarComponent<dynamic>(
                hint: "Search businesses...",
                onSearch: (query) async {
                  return [];
                },
                onResults: (results) {},
              ),
              const SizedBox(height: 10),
              ...widget.businesses.map(
                (item) => _switchBusinessCardItem(
                  item.name,
                  isSelected: item.id == currentBusiness?.id,
                  onTap: () {
                    handleBusinessSwitch(item);
                  },
                  role: "Admin",
                ),
              ),
            ],
          ),
          _addNewBusinessButton(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 5,
      margin: const EdgeInsets.only(top: 8, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _addNewBusinessButton() {
    return TextButton(
      onPressed: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
          border: Border.all(color: const Color(0xFF4285F4), width: 1.5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedAdd01,
              size: 20,
              strokeWidth: 4,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            TextComponent(
              text: 'Add New Business',
              type: 'title',
              size: 14,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchBusinessCardItem(
    String businessName, {
    bool isSelected = false,
    String? role,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: _businessItem(businessName, isSelected: isSelected, role: role),
      ),
    );
  }

  Widget _businessItem(
    String businessName, {
    bool isSelected = false,
    String? role,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: _businessItemDecoration(isSelected),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              _businessAvatar(businessName),
              const SizedBox(width: 12),
              _businessNameAndRole(businessName, role, isSelected: isSelected),
            ],
          ),
          if (isSelected) _businessItemCheckMark(),
        ],
      ),
    );
  }

  Widget _businessItemCheckMark() {
    return HugeIcon(
      icon: HugeIcons.strokeRoundedCheckmarkCircle02,
      size: 24,
      strokeWidth: 2,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  BoxDecoration _businessItemDecoration(bool isSelected) {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        width: 1.5,
      ),
    );
  }

  Widget _businessNameAndRole(
    String businessName,
    String? role, {
    bool isSelected = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextComponent(
          text: businessName,
          type: 'title',
          size: 16,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        const SizedBox(height: 2),
        if (role != null) TextComponent(text: role, type: 'caption', size: 12),
      ],
    );
  }

  Widget _businessAvatar(String? businessName) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.amber,
    ];
    final shades = [700, 800, 900];
    final randomShade = shades[Random().nextInt(shades.length)];
    final randomColor = colors[Random().nextInt(colors.length)];
    return CircleAvatar(
      radius: 24,
      backgroundColor: randomColor[randomShade],
      child: Text(
        businessName != null && businessName.isNotEmpty
            ? businessName[0].toUpperCase()
            : '?',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
