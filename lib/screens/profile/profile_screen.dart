import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import 'settings_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _navigateToSettingsScreen(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(user),

            const SizedBox(height: 24),

            // Academic Stats
            _buildAcademicStats(user),

            const SizedBox(height: 24),

            // Profile Menu
            _buildProfileMenu(user),

            const SizedBox(height: 16),

            // Personal Info
            _buildPersonalInfo(user),

            const SizedBox(height: 16),

            // Hostel Info (if applicable)
            //if (user.isHosteller) _buildHostelInfo(user),

            const SizedBox(height: 24),

            // Logout Button
            _buildLogoutButton(authService),
          ],
        ),
      ),
    );
  }

  // Profile Header Widget
  Widget _buildProfileHeader(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              user.initials,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${user.program} • ${user.department}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ID: ${user.studentId}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Academic Stats Widget
  Widget _buildAcademicStats(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn('${user.gpa}', 'GPA'),
              _buildStatColumn('${user.completedCredits}', 'Credits'),
              _buildStatColumn('Year ${user.year}', 'Status'),
            ],
          ),
        ),
      ),
    );
  }

  // Profile Menu Widget
  Widget _buildProfileMenu(UserModel user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMenuItem(Icons.person, 'Edit Profile', () => _navigateToEditProfile(user)),
          const Divider(),
          _buildMenuItem(Icons.school, 'Academic Records', () {}),
          const Divider(),
          _buildMenuItem(Icons.credit_card, 'ID Card', () {}),
          const Divider(),
          _buildMenuItem(Icons.library_books, 'Library Account', () {}),
          const Divider(),
          _buildMenuItem(Icons.receipt, 'Fee History', () {}),
        ],
      ),
    );
  }

  // Personal Info Widget
  Widget _buildPersonalInfo(UserModel user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMenuItem(Icons.email, 'Email: ${user.email}', () {}),
          const Divider(),
          _buildMenuItem(Icons.phone, 'Phone: ${user.phoneNumber}', () {}),
          const Divider(),
          _buildMenuItem(Icons.location_on, 'Address', () {}),
          const Divider(),
          _buildMenuItem(Icons.bloodtype, 'Blood Group: ${user.bloodGroup}', () {}),
        ],
      ),
    );
  }

  // Hostel Info Widget
  Widget _buildHostelInfo(UserModel user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildMenuItem(Icons.hotel, 'Hostel: ${user.hostelBlock}', () {}),
          const Divider(),
          _buildMenuItem(Icons.meeting_room, 'Room: ${user.roomNumber}', () {}),
        ],
      ),
    );
  }

  // Logout Button Widget
  Widget _buildLogoutButton(AuthService authService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            await authService.logout();
            if (context.mounted) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build a stat column (for GPA, Credits, etc.)
  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // Helper method to build menu items
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Navigate to Edit Profile Screen
  void _navigateToEditProfile(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(user: user),
      ),
    );
  }

  // Navigate to Settings Screen
  void _navigateToSettingsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }
}