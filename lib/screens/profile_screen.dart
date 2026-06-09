import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'account_settings_screen.dart';
import 'help_support_screen.dart';
import 'payment_methods_screen.dart';
import 'security_privacy_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final fullName = auth.user?.userMetadata?['full_name'] as String? ??
        auth.user?.email?.split('@').first ??
        'User';
    final email = auth.email;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEEF2FF), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 24,
                          offset: const Offset(0, 12))
                    ],
                  ),
                  child: const Icon(Icons.person,
                      size: 54, color: Color(0xFF4F46E5)),
                ),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFF4F46E5).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4))
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              fullName,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 40),
            _buildMenuItem(
              context,
              icon: Icons.person_outline,
              label: 'Account Settings',
              iconBgColor: const Color(0xFFEEF2FF),
              iconColor: const Color(0xFF4F46E5),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AccountSettingsScreen())),
            ),
            const SizedBox(height: 14),
            _buildMenuItem(
              context,
              icon: Icons.credit_card,
              label: 'Payment Methods',
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF10B981),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PaymentMethodsScreen())),
            ),
            const SizedBox(height: 14),
            _buildMenuItem(
              context,
              icon: Icons.security,
              label: 'Security & Privacy',
              iconBgColor: const Color(0xFFFFF7ED),
              iconColor: const Color(0xFFF97316),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SecurityPrivacyScreen())),
            ),
            const SizedBox(height: 14),
            _buildMenuItem(
              context,
              icon: Icons.help_outline,
              label: 'Help & Support',
              iconBgColor: const Color(0xFFFEF2F2),
              iconColor: const Color(0xFFF43F5E),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HelpSupportScreen())),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.read<AuthProvider>().signOut(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEF2F2),
                  foregroundColor: const Color(0xFFF43F5E),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Sign Out',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color iconBgColor,
    required Color iconColor,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827))),
                ),
                const Icon(Icons.chevron_right,
                    color: Color(0xFFCBD5E1), size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
