import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static final List<_HelpTopic> _helpTopics = [
    _HelpTopic(
      title: 'Creating Your Account',
      icon: HugeIcons.strokeRoundedUserAdd02,
      items: [
        'Open the Ventura app and tap "Sign Up"',
        'Enter your email address and create a strong password',
        'Provide your first name and last name',
        'Alternatively, tap "Continue with Google" for quick sign-up',
        'Check your email for a verification code',
        'Enter the 6-digit code to verify your account',
      ],
    ),
    _HelpTopic(
      title: 'Signing In',
      icon: HugeIcons.strokeRoundedLogin02,
      items: [
        'Tap "Sign In" on the welcome screen',
        'Enter your registered email and password',
        'Or use "Continue with Google" if you signed up with Google',
        'Tap "Sign In" to access your account',
        'If you have not created a business profile, you\'ll be prompted to do so',
      ],
    ),
    _HelpTopic(
      title: 'Resetting Your Password',
      icon: HugeIcons.strokeRoundedLockSync01,
      items: [
        'On the Sign In page, tap "Forgot your password?"',
        'Enter your registered email address',
        'Check your email for a verification code',
        'Enter the 6-digit code in the app',
        'Create and confirm your new password',
        'Your password is now reset - you can sign in with the new password',
      ],
    ),
    _HelpTopic(
      title: 'Creating a Business Profile',
      icon: HugeIcons.strokeRoundedOffice,
      items: [
        'After email verification, you\'ll be prompted to create a business profile',
        'Step 1: Business Name - Enter your business name and select business type (retail, service, etc.)',
        'Step 2: Contact Information - Provide business address, country, state/region, city, email (optional), and phone number (required)',
        'Step 3: Business Details - Add a tagline, description, and upload a logo (optional)',
        'All required fields must be completed to proceed',
        'Tap "Create Business Profile" to finish setup',
      ],
    ),
    _HelpTopic(
      title: 'Required Business Information',
      icon: HugeIcons.strokeRoundedInformationCircle,
      items: [
        'Business Name (required)',
        'Business Type/Category (required)',
        'Business Address (required)',
        'Country (required)',
        'State/Region (required)',
        'City (required)',
        'Phone Number (required)',
        'Email (optional)',
        'Tagline (optional)',
        'Description (optional)',
        'Logo (optional)',
      ],
    ),
    _HelpTopic(
      title: 'Managing Your Profile',
      icon: HugeIcons.strokeRoundedUserSettings01,
      items: [
        'Tap the Profile tab from the bottom navigation',
        'View your personal and business information',
        'Under "Account Management", tap "Personal Information" to update your name and profile picture',
        'Tap "Business Details" to edit business information',
        'Tap "Change Password" to update your password',
      ],
    ),
    _HelpTopic(
      title: 'Updating Personal Information',
      icon: HugeIcons.strokeRoundedPencilEdit02,
      items: [
        'Go to Profile > Personal Information',
        'Tap the camera icon to change your profile picture',
        'Update your first name or last name',
        'Tap "Save" to apply changes',
        'Your profile will be updated across the app',
      ],
    ),
    _HelpTopic(
      title: 'Updating Business Information',
      icon: HugeIcons.strokeRoundedNoteEdit,
      items: [
        'Go to Profile > Business Details',
        'Update any business field (name, type, contact info, logo, etc.)',
        'All the same fields from business creation are editable',
        'Tap "Save" to update your business profile',
      ],
    ),
    _HelpTopic(
      title: 'Logging Out',
      icon: HugeIcons.strokeRoundedLogout02,
      items: [
        'Go to the Profile tab',
        'Scroll down to "Support & Legal" section',
        'Tap "Logout" (shown in red)',
        'Confirm you want to sign out',
        'Make sure to sync all data before logging out',
        'You\'ll be redirected to the sign-in screen',
      ],
    ),
    _HelpTopic(
      title: 'Creating an Appointment',
      icon: HugeIcons.strokeRoundedAddCircle,
      items: [
        'Navigate to the Appointments tab from the bottom navigation',
        'Tap the "+" button to create a new appointment',
        'Enter the appointment title (required)',
        'Set the start date and time',
        'Set the end date and time (must be after start time)',
        'Optionally mark as recurring and configure recurrence settings',
        'Add a description to provide context (optional)',
        'Add notes for internal reference (optional)',
        'Tap "Save" to create the appointment',
      ],
    ),
    _HelpTopic(
      title: 'Required Appointment Information',
      icon: HugeIcons.strokeRoundedCheckList,
      items: [
        'Title (required)',
        'Start Date (required)',
        'Start Time (required)',
        'End Date (required)',
        'End Time (required)',
        'Description (optional)',
        'Notes (optional)',
        'Recurring settings (optional)',
      ],
    ),
    _HelpTopic(
      title: 'Setting Up Recurring Appointments',
      icon: HugeIcons.strokeRoundedRepeat,
      items: [
        'Toggle "Recurring" switch when creating an appointment',
        'Choose when the recurring appointments should end',
        'Set the "Repeat Until" date and time',
        'Select the frequency: Daily, Weekly, Bi-Weekly, Monthly, Bi-Monthly, Quarterly, or Yearly',
        'The system will automatically schedule appointments based on your settings',
      ],
    ),
    _HelpTopic(
      title: 'Viewing Your Appointments',
      icon: HugeIcons.strokeRoundedCalendar03,
      items: [
        'All appointments are displayed on the Appointments page',
        'Appointments are organized by date',
        'Each appointment card shows: title, date, and time range',
        'Tap on an appointment to view full details',
        'Use the calendar view to see appointments by date',
      ],
    ),
    _HelpTopic(
      title: 'Updating an Appointment',
      icon: HugeIcons.strokeRoundedPropertyEdit,
      items: [
        'Tap on the appointment you want to edit',
        'Modify any field (title, dates, times, description, etc.)',
        'Tap "Save" to update the appointment',
        'Changes will be reflected immediately',
      ],
    ),
    _HelpTopic(
      title: 'Deleting an Appointment',
      icon: HugeIcons.strokeRoundedDelete02,
      items: [
        'Tap and hold on the appointment card',
        'Or swipe the appointment card to reveal delete option',
        'Confirm the deletion',
        'The appointment will be permanently removed',
        'This action cannot be undone',
      ],
    ),
    _HelpTopic(
      title: 'Google Calendar Integration',
      icon: HugeIcons.strokeRoundedDatabaseSync,
      items: [
        'Appointments can be synced with Google Calendar',
        'Each appointment has a Google Event ID field',
        'This allows two-way sync between Ventura and Google Calendar',
        'Changes made in either platform can be reflected in both',
      ],
    ),
  ];

  void _showHelpDetails(BuildContext context, _HelpTopic topic) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                topic.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: topic.items.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(fontSize: 15, height: 1.6),
                        ),
                        Expanded(
                          child: Text(
                            topic.items[index],
                            style: const TextStyle(fontSize: 15, height: 1.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8.0),
          child: const SizedBox(height: 8.0),
        ),
        title: Text(
          'Help Center',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _helpTopics.length,
          itemBuilder: (context, index) {
            final topic = _helpTopics[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: HugeIcon(icon: topic.icon),
                title: Text(
                  topic.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowRight01,
                ),
                onTap: () => _showHelpDetails(context, topic),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HelpTopic {
  final String title;
  final List<List<dynamic>> icon;
  final List<String> items;

  const _HelpTopic({
    required this.title,
    required this.icon,
    required this.items,
  });
}
