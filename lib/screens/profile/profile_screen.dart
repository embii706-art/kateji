import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.userData;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.primary,
                  backgroundImage: user.fotoUrl != null ? NetworkImage(user.fotoUrl!) : null,
                  child: user.fotoUrl == null
                      ? Text(
                          user.nama[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 16),

                Text(
                  user.nama,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  UserRole.getDisplayName(user.role),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),

                if (user.jabatan != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.jabatan!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Profile Info
                _buildInfoCard(
                  children: [
                    _buildInfoRow(Icons.email, 'Email', user.email),
                    if (user.noHp != null) _buildInfoRow(Icons.phone, 'No. HP', user.noHp!),
                    if (user.nik != null) _buildInfoRow(Icons.credit_card, 'NIK', user.nik!),
                    if (user.alamat != null) _buildInfoRow(Icons.location_on, 'Alamat', user.alamat!),
                  ],
                ),

                const SizedBox(height: 16),

                // Actions
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Edit Profil',
                  onTap: () {
                    // TODO: Navigate to edit profile
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur edit profil akan segera hadir')),
                    );
                  },
                ),

                const SizedBox(height: 8),

                _buildActionButton(
                  icon: Icons.lock,
                  label: 'Ubah Password',
                  onTap: () {
                    // TODO: Navigate to change password
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur ubah password akan segera hadir')),
                    );
                  },
                ),

                const SizedBox(height: 8),

                _buildActionButton(
                  icon: Icons.info_outline,
                  label: 'Tentang Aplikasi',
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),

                const SizedBox(height: 24),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showLogoutDialog(context, authProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Keluar'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Versi 1.0.0',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({required List<Widget> children}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () async {
              await authProvider.signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushReplacementNamed('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('KELUAR'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang KARTEJI'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KARTEJI v1.0.0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Karang Taruna RT 01'),
            SizedBox(height: 16),
            Text(
              'Aplikasi digital untuk administrasi, transparansi keuangan, kegiatan, dan aspirasi warga.',
            ),
            SizedBox(height: 16),
            Text(
              '© 2026 KARTEJI. All rights reserved.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
