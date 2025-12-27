import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfilePageSectionLists {
  final String title;
  final List<List<dynamic>> icon;
  final Color? color;
  final String? route;
  final String? label;

  ProfilePageSectionLists({
    required this.title,
    required this.icon,
    this.color,
    this.route,
    this.label,
  });
}

List<ProfilePageSectionLists> accountManagement = [
  ProfilePageSectionLists(
    title: 'Personal Information',
    icon: HugeIcons.strokeRoundedUser,
    route: 'edit-profile-page',
  ),
  ProfilePageSectionLists(
    title: 'Business Details',
    icon: HugeIcons.strokeRoundedNewOffice,
    route: 'business-details',
  ),
  ProfilePageSectionLists(
    title: 'Change Password',
    icon: HugeIcons.strokeRoundedSquareLock01,
    route: 'change-password',
  ),
];

List<ProfilePageSectionLists> appSettings = [
  ProfilePageSectionLists(
    title: 'Data & Backup',
    icon: HugeIcons.strokeRoundedDatabaseSync01,
    route: 'data-backup',
  ),
  ProfilePageSectionLists(
    title: 'Security',
    icon: HugeIcons.strokeRoundedLockSync02,
    route: 'profile-security',
  ),
];

List<ProfilePageSectionLists> supportAndLegal = [
  ProfilePageSectionLists(
    title: 'Help Center',
    icon: HugeIcons.strokeRoundedHelpCircle,
    route: 'help-center',
  ),
  ProfilePageSectionLists(
    title: 'Terms of Service',
    icon: HugeIcons.strokeRoundedFile02,
    route: 'terms-of-service',
  ),
  ProfilePageSectionLists(
    title: 'Privacy Policy',
    icon: HugeIcons.strokeRoundedSecurityLock,
    route: 'privacy-policy',
  ),
  ProfilePageSectionLists(
    title: 'Logout',
    icon: HugeIcons.strokeRoundedLogout02,
    route: null,
    label: 'logout',
    color: Colors.red
  ),
];
