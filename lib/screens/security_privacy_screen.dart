import 'package:flutter/material.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  const SecurityPrivacyScreen({Key? key}) : super(key: key);

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  bool faceIdEnabled = true;
  bool twoFactorEnabled = false;
  bool locationTracking = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Security & Privacy', style: TextStyle(color: Color(0xFF111827), fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Security',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),
            _buildToggleItem(
              title: 'Face ID / Touch ID',
              subtitle: 'Unlock with biometrics',
              icon: Icons.fingerprint,
              value: faceIdEnabled,
              onChanged: (val) {
                setState(() {
                  faceIdEnabled = val;
                });
              },
            ),
            _buildToggleItem(
              title: 'Two-Factor Authentication',
              subtitle: 'Extra security for your account',
              icon: Icons.security,
              value: twoFactorEnabled,
              onChanged: (val) {
                setState(() {
                  twoFactorEnabled = val;
                });
              },
            ),
            
            const SizedBox(height: 32),
            const Text(
              'Privacy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),
            _buildToggleItem(
              title: 'Location Services',
              subtitle: 'Used to track expenses by place',
              icon: Icons.location_on_outlined,
              value: locationTracking,
              onChanged: (val) {
                setState(() {
                  locationTracking = val;
                });
              },
            ),
            
            const SizedBox(height: 32),
            const Text(
              'Active Sessions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),
            _buildSessionItem(
              device: 'iPhone 14 Pro Max',
              location: 'Kuala Lumpur, Malaysia',
              time: 'Active now',
              icon: Icons.phone_iphone,
              isActive: true,
            ),
            _buildSessionItem(
              device: 'MacBook Pro M2',
              location: 'Petaling Jaya, Malaysia',
              time: 'Last active 2 days ago',
              icon: Icons.laptop_mac,
              isActive: false,
            ),
            
            const SizedBox(height: 40),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  _showChangePasswordDialog(context);
                },
                icon: const Icon(Icons.lock_reset, color: Color(0xFFF43F5E)),
                label: const Text(
                  'Change Password',
                  style: TextStyle(
                    color: Color(0xFFF43F5E),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFFF97316), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4F46E5),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem({
    required String device,
    required String location,
    required String time,
    required IconData icon,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$location • $time',
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Current',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF059669),
                ),
              ),
            )
          else
            const Icon(Icons.more_vert, color: Color(0xFFCBD5E1)),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogTextField('Current Password', obscureText: true),
            const SizedBox(height: 16),
            _buildDialogTextField('New Password', obscureText: true),
            const SizedBox(height: 16),
            _buildDialogTextField('Confirm New Password', obscureText: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF6B7280))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F46E5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Update', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(String hint, {bool obscureText = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
        ),
      ),
    );
  }
}
