import 'package:hugeicons/hugeicons.dart';

enum BusinessType {
  retail(
    'Retail',
    'General shops, boutiques, and outlets',
    HugeIcons.strokeRoundedStore01,
  ),
  foodAndBeverage(
    'Food & Beverage',
    'Restaurants, cafes, and bars',
    HugeIcons.strokeRoundedSpoonAndFork,
  ),
  services(
    'Services',
    'Consulting, hair salons, and repairs',
    HugeIcons.strokeRoundedScissor,
  ),
  healthAndWellness(
    'Health',
    'Gyms, spas, and clinics',
    HugeIcons.strokeRoundedHealth,
  ),
  education(
    'Education',
    'Schools, tutors, and workshops',
    HugeIcons.strokeRoundedMortarboard02,
  ),
  technology(
    'Technology',
    'Software, hardware, and IT services',
    HugeIcons.strokeRoundedComputerPhoneSync,
  ),
  other('Other', 'Any other business type', HugeIcons.strokeRoundedIceCubes);

  final String label;
  final String description;
  final List<List<dynamic>> icon;

  const BusinessType(this.label, this.description, this.icon);

  // Helper to convert string from DB/API back to Enum
  static BusinessType fromName(String name) {
    return BusinessType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => BusinessType.other,
    );
  }
}
