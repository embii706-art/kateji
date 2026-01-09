import 'package:flutter/material.dart';
import '../../services/kegiatan_service.dart';
import '../../models/kegiatan_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatter.dart';

class KegiatanListScreen extends StatelessWidget {
  const KegiatanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kegiatan'),
      ),
      body: StreamBuilder<List<KegiatanModel>>(
        stream: KegiatanService().getKegiatanStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final kegiatanList = snapshot.data ?? [];

          if (kegiatanList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text('Belum ada kegiatan'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: kegiatanList.length,
            itemBuilder: (context, index) {
              final kegiatan = kegiatanList[index];
              return _buildKegiatanCard(context, kegiatan);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur tambah kegiatan akan segera hadir')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildKegiatanCard(BuildContext context, KegiatanModel kegiatan) {
    Color statusColor;
    switch (kegiatan.status) {
      case 'dijadwalkan':
        statusColor = AppColors.info;
        break;
      case 'berlangsung':
        statusColor = AppColors.warning;
        break;
      case 'selesai':
        statusColor = AppColors.success;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return Card(
      child: InkWell(
        onTap: () {
          // Navigate to detail
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
                      kegiatan.judul,
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
                      kegiatan.status.toUpperCase(),
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
                kegiatan.deskripsi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    Formatter.date(kegiatan.tanggal),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    kegiatan.waktu,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      kegiatan.lokasi,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.people, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${kegiatan.pesertaIds.length} peserta',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
