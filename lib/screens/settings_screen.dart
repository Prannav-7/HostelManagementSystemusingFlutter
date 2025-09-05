import 'package:flutter/material.dart';
import 'login_selection_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System';

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
  ];
  final List<String> _themes = ['Light', 'Dark', 'System'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[700],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          _buildSectionCard(
            title: 'Profile',
            icon: Icons.person,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo[100],
                  child: Icon(Icons.person, color: Colors.indigo[700]),
                ),
                title: const Text('John Doe'),
                subtitle: const Text('Room 1205 • john.doe@email.com'),
                trailing: const Icon(Icons.edit),
                onTap: _editProfile,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Notification Settings
          _buildSectionCard(
            title: 'Notifications',
            icon: Icons.notifications,
            children: [
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive notifications on your device'),
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
                activeColor: Colors.indigo[600],
              ),
              SwitchListTile(
                title: const Text('Email Notifications'),
                subtitle: const Text('Receive notifications via email'),
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
                activeColor: Colors.indigo[600],
              ),
              SwitchListTile(
                title: const Text('Sound'),
                subtitle: const Text('Play notification sounds'),
                value: _soundEnabled,
                onChanged: (value) {
                  setState(() {
                    _soundEnabled = value;
                  });
                },
                activeColor: Colors.indigo[600],
              ),
              SwitchListTile(
                title: const Text('Vibration'),
                subtitle: const Text('Vibrate for notifications'),
                value: _vibrationEnabled,
                onChanged: (value) {
                  setState(() {
                    _vibrationEnabled = value;
                  });
                },
                activeColor: Colors.indigo[600],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // App Preferences
          _buildSectionCard(
            title: 'App Preferences',
            icon: Icons.settings,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: Text(_selectedLanguage),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _selectLanguage,
              ),
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme'),
                subtitle: Text(_selectedTheme),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _selectTheme,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Hotel Services
          _buildSectionCard(
            title: 'Hotel Services',
            icon: Icons.hotel,
            children: [
              ListTile(
                leading: const Icon(Icons.room_service, color: Colors.orange),
                title: const Text('Room Service Menu'),
                subtitle: const Text('View available room service options'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _openRoomServiceMenu,
              ),
              ListTile(
                leading: const Icon(
                  Icons.local_laundry_service,
                  color: Colors.blue,
                ),
                title: const Text('Laundry Service'),
                subtitle: const Text('Schedule laundry pickup'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _scheduleLaundry,
              ),
              ListTile(
                leading: const Icon(Icons.directions_car, color: Colors.green),
                title: const Text('Valet Parking'),
                subtitle: const Text('Request car pickup/delivery'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _requestValet,
              ),
              ListTile(
                leading: const Icon(Icons.spa, color: Colors.purple),
                title: const Text('Spa & Wellness'),
                subtitle: const Text('Book spa appointments'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _bookSpa,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Support & Information
          _buildSectionCard(
            title: 'Support & Information',
            icon: Icons.help,
            children: [
              ListTile(
                leading: const Icon(Icons.help_outline, color: Colors.blue),
                title: const Text('FAQ'),
                subtitle: const Text('Frequently asked questions'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _openFAQ,
              ),
              ListTile(
                leading: const Icon(Icons.policy, color: Colors.indigo),
                title: const Text('Privacy Policy'),
                subtitle: const Text('View our privacy policy'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _openPrivacyPolicy,
              ),
              ListTile(
                leading: const Icon(Icons.description, color: Colors.green),
                title: const Text('Terms of Service'),
                subtitle: const Text('View terms and conditions'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _openTermsOfService,
              ),
              ListTile(
                leading: const Icon(Icons.star_rate, color: Colors.amber),
                title: const Text('Rate Our App'),
                subtitle: const Text('Share your feedback'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _rateApp,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Account Actions
          _buildSectionCard(
            title: 'Account',
            icon: Icons.account_circle,
            children: [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.orange),
                title: const Text('Sign Out'),
                subtitle: const Text('Sign out of your account'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _signOut,
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Delete Account'),
                subtitle: const Text('Permanently delete your account'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _deleteAccount,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // App Version
          Center(
            child: Text(
              'Hotel Complaint App v1.0.0',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.indigo[700]),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[700],
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: const Text('Profile editing feature coming soon!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _selectLanguage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.of(context).pop();
                },
                activeColor: Colors.indigo[600],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _selectTheme() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _themes.map((theme) {
              return RadioListTile<String>(
                title: Text(theme),
                value: theme,
                groupValue: _selectedTheme,
                onChanged: (value) {
                  setState(() {
                    _selectedTheme = value!;
                  });
                  Navigator.of(context).pop();
                },
                activeColor: Colors.indigo[600],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _openRoomServiceMenu() {
    _showFeatureDialog(
      'Room Service Menu',
      'Browse our delicious room service options and place orders directly from the app.',
    );
  }

  void _scheduleLaundry() {
    _showFeatureDialog(
      'Laundry Service',
      'Schedule laundry pickup and delivery times that work for your schedule.',
    );
  }

  void _requestValet() {
    _showFeatureDialog(
      'Valet Parking',
      'Request your car to be brought to the front entrance or taken to the garage.',
    );
  }

  void _bookSpa() {
    _showFeatureDialog(
      'Spa & Wellness',
      'Book relaxing spa treatments and wellness services during your stay.',
    );
  }

  void _openFAQ() {
    _showFeatureDialog(
      'FAQ',
      'Find answers to commonly asked questions about hotel services and policies.',
    );
  }

  void _openPrivacyPolicy() {
    _showFeatureDialog(
      'Privacy Policy',
      'Learn how we protect and handle your personal information.',
    );
  }

  void _openTermsOfService() {
    _showFeatureDialog(
      'Terms of Service',
      'Review the terms and conditions for using our hotel services and app.',
    );
  }

  void _rateApp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rate Our App'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('How would you rate your experience with our app?'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 32),
                  Icon(Icons.star, color: Colors.amber, size: 32),
                  Icon(Icons.star, color: Colors.amber, size: 32),
                  Icon(Icons.star, color: Colors.amber, size: 32),
                  Icon(Icons.star_border, color: Colors.amber, size: 32),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your feedback!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate to login screen and remove all previous routes
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginSelectionScreen(),
                  ),
                  (route) => false, // Remove all previous routes
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You have been signed out successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to permanently delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Account deletion is not available at this time',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showFeatureDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
