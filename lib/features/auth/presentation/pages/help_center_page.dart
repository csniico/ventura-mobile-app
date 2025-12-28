import 'package:flutter/material.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center'), elevation: 0),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [_buildAuthAndBusinessPage(), _buildAppointmentsPage()],
      ),
    );
  }

  Widget _buildAuthAndBusinessPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPageDot(0),
              const SizedBox(width: 8),
              _buildPageDot(1),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Getting Started',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 32),

          // Sign Up Section
          _buildHelpSection(
            title: 'Creating Your Account',
            items: [
              'Open the Ventura app and tap "Sign Up"',
              'Enter your email address and create a strong password',
              'Provide your first name and last name',
              'Alternatively, tap "Continue with Google" for quick sign-up',
              'Check your email for a verification code',
              'Enter the 6-digit code to verify your account',
            ],
          ),

          // Sign In Section
          _buildHelpSection(
            title: 'Signing In',
            items: [
              'Tap "Sign In" on the welcome screen',
              'Enter your registered email and password',
              'Or use "Continue with Google" if you signed up with Google',
              'Tap "Sign In" to access your account',
              'If you have not created a business profile, you\'ll be prompted to do so',
            ],
          ),

          // Reset Password Section
          _buildHelpSection(
            title: 'Resetting Your Password',
            items: [
              'On the Sign In page, tap "Forgot your password?"',
              'Enter your registered email address',
              'Check your email for a verification code',
              'Enter the 6-digit code in the app',
              'Create and confirm your new password',
              'Your password is now reset - you can sign in with the new password',
            ],
          ),

          // Create Business Section
          _buildHelpSection(
            title: 'Creating a Business Profile',
            items: [
              'After email verification, you\'ll be prompted to create a business profile',
              'Step 1: Business Name - Enter your business name and select business type (retail, service, etc.)',
              'Step 2: Contact Information - Provide business address, country, state/region, city, email (optional), and phone number (required)',
              'Step 3: Business Details - Add a tagline, description, and upload a logo (optional)',
              'All required fields must be completed to proceed',
              'Tap "Create Business Profile" to finish setup',
            ],
          ),

          // Required Business Properties
          _buildHelpSection(
            title: 'Required Business Information',
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

          // Profile Management Section
          _buildHelpSection(
            title: 'Managing Your Profile',
            items: [
              'Tap the Profile tab from the bottom navigation',
              'View your personal and business information',
              'Under "Account Management", tap "Personal Information" to update your name and profile picture',
              'Tap "Business Details" to edit business information',
              'Tap "Change Password" to update your password',
            ],
          ),

          // Update Account Section
          _buildHelpSection(
            title: 'Updating Personal Information',
            items: [
              'Go to Profile > Personal Information',
              'Tap the camera icon to change your profile picture',
              'Update your first name or last name',
              'Tap "Save" to apply changes',
              'Your profile will be updated across the app',
            ],
          ),

          // Update Business Section
          _buildHelpSection(
            title: 'Updating Business Information',
            items: [
              'Go to Profile > Business Details',
              'Update any business field (name, type, contact info, logo, etc.)',
              'All the same fields from business creation are editable',
              'Tap "Save" to update your business profile',
            ],
          ),

          // Logout Section
          _buildHelpSection(
            title: 'Logging Out',
            items: [
              'Go to the Profile tab',
              'Scroll down to "Support & Legal" section',
              'Tap "Logout" (shown in red)',
              'Confirm you want to sign out',
              'Make sure to sync all data before logging out',
              'You\'ll be redirected to the sign-in screen',
            ],
          ),

          const SizedBox(height: 40),

          // Next Page Button
          Center(
            child: ElevatedButton.icon(
              onPressed: _nextPage,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Appointments Help'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildAppointmentsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPageDot(0),
              const SizedBox(width: 8),
              _buildPageDot(1),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Managing Appointments',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 32),

          // Create Appointment Section
          _buildHelpSection(
            title: 'Creating an Appointment',
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

          // Required Appointment Fields
          _buildHelpSection(
            title: 'Required Appointment Information',
            items: [
              'Title (required)',
              'Start Date (required)',
              'Start Time (required)',
              'End Date (required)',
              'End Time (required)',
              'User ID (automatically linked to your account)',
              'Business ID (automatically linked to your business)',
              'Description (optional)',
              'Notes (optional)',
              'Recurring settings (optional)',
            ],
          ),

          // Recurring Appointments
          _buildHelpSection(
            title: 'Setting Up Recurring Appointments',
            items: [
              'Toggle "Recurring" switch when creating an appointment',
              'Choose when the recurring appointments should end',
              'Set the "Repeat Until" date and time',
              'Select the frequency: Daily, Weekly, Bi-Weekly, Monthly, Bi-Monthly, Quarterly, or Yearly',
              'The system will automatically schedule appointments based on your settings',
            ],
          ),

          // View Appointments
          _buildHelpSection(
            title: 'Viewing Your Appointments',
            items: [
              'All appointments are displayed on the Appointments page',
              'Appointments are organized by date',
              'Each appointment card shows: title, date, and time range',
              'Tap on an appointment to view full details',
              'Use the calendar view to see appointments by date',
            ],
          ),

          // Update Appointments
          _buildHelpSection(
            title: 'Updating an Appointment',
            items: [
              'Tap on the appointment you want to edit',
              'Modify any field (title, dates, times, description, etc.)',
              'Tap "Save" to update the appointment',
              'Changes will be reflected immediately',
            ],
          ),

          // Delete Appointments
          _buildHelpSection(
            title: 'Deleting an Appointment',
            items: [
              'Tap and hold on the appointment card',
              'Or swipe the appointment card to reveal delete option',
              'Confirm the deletion',
              'The appointment will be permanently removed',
              'This action cannot be undone',
            ],
          ),

          // Google Calendar Integration
          _buildHelpSection(
            title: 'Google Calendar Integration',
            items: [
              'Appointments can be synced with Google Calendar',
              'Each appointment has a Google Event ID field',
              'This allows two-way sync between Ventura and Google Calendar',
              'Changes made in either platform can be reflected in both',
            ],
          ),

          const SizedBox(height: 40),

          // Back Button
          Center(
            child: ElevatedButton.icon(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Auth Help'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHelpSection({
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 15, height: 1.6)),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPageDot(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Theme.of(context).primaryColor
            : Colors.grey.shade300,
      ),
    );
  }
}
