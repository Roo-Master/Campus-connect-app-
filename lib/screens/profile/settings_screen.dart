import 'package:flutter/material.dart';
import '../../config/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  bool _locationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Account Settings
            _buildSectionHeader('Account'),
            _buildToggleSetting(
              Icons.notifications,
              'Push Notifications',
              'Receive important updates and alerts',
              _notificationsEnabled,
                  (value) => setState(() => _notificationsEnabled = value),
            ),
            _buildToggleSetting(
              Icons.fingerprint,
              'Biometric Login',
              'Use fingerprint or face to login',
              _biometricEnabled,
                  (value) => setState(() => _biometricEnabled = value),
            ),
            _buildToggleSetting(
              Icons.location_on,
              'Location Services',
              'Enable for campus navigation',
              _locationEnabled,
                  (value) => setState(() => _locationEnabled = value),
            ),
            const Divider(),

            // Appearance
            _buildSectionHeader('Appearance'),
            _buildToggleSetting(
              Icons.dark_mode,
              'Dark Mode',
              'Switch to dark theme',
              _darkModeEnabled,
                  (value) => setState(() => _darkModeEnabled = value),
            ),
            const Divider(),

            // Preferences
            _buildSectionHeader('Preferences'),
            _buildNavigationSetting(Icons.language, 'Language', 'English'),
            _buildNavigationSetting(Icons.calendar_today, 'Academic Calendar', '2024-2025'),
            _buildNavigationSetting(Icons.email, 'Email Notifications', 'Enabled'),
            const Divider(),

            // Support
            _buildSectionHeader('Support'),
            _buildNavigationSetting(Icons.help, 'Help Center', ''),
            _buildNavigationSetting(Icons.privacy_tip, 'Privacy Policy', ''),
            _buildNavigationSetting(Icons.description, 'Terms of Service', ''),
            _buildNavigationSetting(Icons.info, 'About', 'Version 1.0.0'),
            const Divider(),

            // Data
            _buildSectionHeader('Data'),
            _buildNavigationSetting(Icons.download, 'Download My Data', ''),
            _buildNavigationSetting(Icons.delete_forever, 'Delete My Account', ''),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.shade100,
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildToggleSetting(
      IconData icon,
      String title,
      String subtitle,
      bool value,
      Function(bool) onChanged,
      ) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppTheme.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildNavigationSetting(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      onTap: () {},
    );
  }
}