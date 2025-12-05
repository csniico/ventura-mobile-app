import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/core/models/business/business.dart';
import 'package:ventura/core/models/user/user.dart';
import 'package:ventura/core/services/business/business_service.dart';
import 'package:ventura/core/services/user/user_service.dart';
import 'package:ventura/core/widgets/switch_business_component.dart';
import 'package:ventura/core/widgets/user_avatar.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  User? _user;
  Business? _business;
  List<Business>? _businesses;
  final List<Map<String, dynamic>> _userListItems = [
    {
      'icon': HugeIcons.strokeRoundedPackage,
      'title': 'Inventory',
      'route': '/inventory',
    },
    {
      'icon': HugeIcons.strokeRoundedUserMultiple,
      'title': 'Team',
      'route': '/team',
    },
    {
      'icon': HugeIcons.strokeRoundedBank,
      'title': 'Accounting',
      'route': '/accounting',
    },
    {
      'icon': HugeIcons.strokeRoundedCalendar01,
      'title': 'Analytics',
      'route': '/orders',
    },
  ];

  final List<Map<String, dynamic>> _systemListItems = [
    {
      'icon': HugeIcons.strokeRoundedNewOffice,
      'title': 'Business Profile',
      'route': '/business_profile',
    },
    {
      'icon': HugeIcons.strokeRoundedSettings01,
      'title': 'Settings',
      'route': '/settings',
    },
    {
      'icon': HugeIcons.strokeRoundedCustomerSupport,
      'title': 'Help & Support',
      'route': '/help_and_support',
    },
  ];

  @override
  void initState() {
    super.initState();
    _user = UserService().user;
    _business = BusinessService().currentBusiness;
    _businesses = BusinessService().userBusinesses;
  }

  void _handleSwitchBusiness() {
    Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey[900],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 0.9,
          child: SwitchBusinessComponent(
            businesses: [..._businesses!],
            displayTitle: "Switch Business",
            onBusinessSwitch: (Business business) {
              setState(() {
                _business = business;
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      tilePadding: const EdgeInsets.all(8),
      children: [
        RepaintBoundary(
          key: const ValueKey('drawerHeader'),
          child: _drawerHeader(_business),
        ),
        ..._userListItems.map(
          (e) => _listItem(
            hugeIcon: e['icon'],
            title: e['title'],
            route: e['route'],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Divider(color: Colors.grey.shade300, thickness: 1),
        ),
        ..._systemListItems.map(
          (e) => _listItem(
            hugeIcon: e['icon'],
            title: e['title'],
            route: e['route'],
          ),
        ),
      ],
    );
  }

  Widget _drawerHeader(Business? business) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const UserAvatar(),
          const SizedBox(height: 20),
          _businessUserInfo(business),
          const SizedBox(height: 10),
          _switchBusinessButton(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _businessUserInfo(Business? business) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          business != null ? business.name : "No Business Selected",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        if (_user != null)
          Text(
            '${_user!.firstName} ${_user!.lastName!.isEmpty || _user!.lastName == null ? "" : _user!.lastName}',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  Widget _switchBusinessButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _handleSwitchBusiness,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
        child: Row(
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedRepeat,
              size: 16,
              strokeWidth: 3,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 5),
            Text(
              'Switch Business',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listItem({
    required List<List<dynamic>> hugeIcon,
    required String title,
    required String route,
  }) {
    return ListTile(
      leading: HugeIcon(
        icon: hugeIcon,
        size: 20,
        strokeWidth: 2,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[800]
            : Colors.grey[300],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[800]
              : Colors.grey[300],
        ),
      ),
      onTap: () {
        ModalRoute.of(context)?.settings.name != route
            ? Navigator.pushNamed(context, route)
            : Navigator.pop(context);
      },
    );
  }
}
