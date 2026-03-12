import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _emergencyContactController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _addressController = TextEditingController(text: widget.user.address);
    _emergencyContactController =
        TextEditingController(text: widget.user.emergencyContact);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppTheme.primary.withOpacity(0.1),
                        child: Text(
                          widget.user.initials,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Change Photo'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Personal Information
            _buildSectionTitle('Personal Information'),
            const SizedBox(height: 12),
            _buildTextField(_firstNameController, 'First Name', Icons.person),
            _buildTextField(_lastNameController, 'Last Name', Icons.person),
            _buildTextField(_emailController, 'Email', Icons.email, enabled: false),
            _buildTextField(_phoneController, 'Phone Number', Icons.phone),
            _buildTextField(_addressController, 'Address', Icons.location_on, maxLines: 3),

            const SizedBox(height: 24),

            // Emergency Contact
            _buildSectionTitle('Emergency Contact'),
            const SizedBox(height: 12),
            _buildTextField(
                _emergencyContactController, 'Emergency Contact', Icons.contact_phone),

            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                child: _isSaving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool enabled = true,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: !enabled,
          fillColor: enabled ? null : Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: enabled ? BorderSide(color: Colors.grey.shade300) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    setState(() => _isSaving = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.of(context).pop();
    }
  }
}