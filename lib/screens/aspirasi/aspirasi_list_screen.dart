import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/aspirasi_service.dart';
import '../../models/aspirasi_model.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatter.dart';
import '../../utils/constants.dart';

class AspirasiListScreen extends StatelessWidget {
  const AspirasiListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.firebaseUser?.uid;
    final canManage = authProvider.hasAnyRole([UserRole.admin, UserRole.pengurus, UserRole.ketuaRt]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aspirasi Warga'),
      ),
      body: StreamBuilder<List<AspirasiModel>>(
        stream: AspirasiService().getAspirasiStream(
          userId: canManage ? null : userId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final aspirasiList = snapshot.data ?? [];

          if (aspirasiList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.feedback_outlined, size: 64, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text('Belum ada aspirasi'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: aspirasiList.length,
            itemBuilder: (context, index) {
              final aspirasi = aspirasiList[index];
              return _buildAspirasiCard(context, aspirasi, canManage);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAspirasiDialog(context, authProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAspirasiCard(BuildContext context, AspirasiModel aspirasi, bool canManage) {
    Color statusColor;
    switch (aspirasi.status) {
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'diproses':
        statusColor = AppColors.info;
        break;
      case 'selesai':
        statusColor = AppColors.success;
        break;
      case 'ditolak':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return Card(
      child: InkWell(
        onTap: () {
          _showAspirasiDetail(context, aspirasi, canManage);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      aspirasi.judul,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      aspirasi.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                aspirasi.isi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      aspirasi.kategori,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    Formatter.shortDate(aspirasi.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (aspirasi.balasan != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(
                        'Sudah dibalas',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAspirasiDetail(BuildContext context, AspirasiModel aspirasi, bool canManage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      aspirasi.judul,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (aspirasi.createdByName != null) ...[
                          const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            aspirasi.createdByName!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        Text(
                          Formatter.dateTime(aspirasi.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      aspirasi.isi,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    if (aspirasi.balasan != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.reply, color: AppColors.success),
                                SizedBox(width: 8),
                                Text(
                                  'Balasan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              aspirasi.balasan!,
                              style: const TextStyle(fontSize: 14, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (canManage && aspirasi.balasan == null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showBalasDialog(context, aspirasi);
                    },
                    icon: const Icon(Icons.reply),
                    label: const Text('Balas Aspirasi'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAspirasiDialog(BuildContext context, AuthProvider authProvider) {
    final judulController = TextEditingController();
    final isiController = TextEditingController();
    String kategori = 'Umum';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kirim Aspirasi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: kategori,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: ['Umum', 'Infrastruktur', 'Keamanan', 'Sosial', 'Lainnya']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) kategori = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: isiController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Isi Aspirasi',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (judulController.text.isEmpty || isiController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Judul dan isi harus diisi')),
                );
                return;
              }

              final aspirasi = AspirasiModel(
                id: '',
                judul: judulController.text,
                isi: isiController.text,
                kategori: kategori,
                createdBy: authProvider.firebaseUser!.uid,
                createdByName: authProvider.userData?.nama,
                createdAt: DateTime.now(),
              );

              try {
                await AspirasiService().createAspirasi(aspirasi);
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Aspirasi berhasil dikirim')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('KIRIM'),
          ),
        ],
      ),
    );
  }

  void _showBalasDialog(BuildContext context, AspirasiModel aspirasi) {
    final balasanController = TextEditingController();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Balas Aspirasi'),
        content: TextField(
          controller: balasanController,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Balasan',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (balasanController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Balasan harus diisi')),
                );
                return;
              }

              try {
                await AspirasiService().balasAspirasi(
                  aspirasi.id,
                  balasanController.text,
                  authProvider.firebaseUser!.uid,
                );
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Balasan berhasil dikirim')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('KIRIM'),
          ),
        ],
      ),
    );
  }
}
