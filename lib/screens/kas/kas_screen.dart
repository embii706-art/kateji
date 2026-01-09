import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/kas_service.dart';
import '../../models/kas_model.dart';
import '../../providers/auth_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatter.dart';
import '../../utils/constants.dart';

class KasScreen extends StatefulWidget {
  const KasScreen({super.key});

  @override
  State<KasScreen> createState() => _KasScreenState();
}

class _KasScreenState extends State<KasScreen> {
  final KasService _kasService = KasService();
  String _filterJenis = 'semua';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final canManage = authProvider.hasAnyRole([UserRole.admin, UserRole.pengurus]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keuangan & Kas'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _filterJenis = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'semua', child: Text('Semua')),
              const PopupMenuItem(value: 'masuk', child: Text('Pemasukan')),
              const PopupMenuItem(value: 'keluar', child: Text('Pengeluaran')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Saldo Card
          FutureBuilder<double>(
            future: _kasService.getSaldo(),
            builder: (context, snapshot) {
              final saldo = snapshot.data ?? 0;
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Saldo Kas',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatter.currency(saldo),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Transactions List
          Expanded(
            child: StreamBuilder<List<KasModel>>(
              stream: _kasService.getKasStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                var kasList = snapshot.data ?? [];

                if (_filterJenis != 'semua') {
                  kasList = kasList.where((kas) => kas.jenis == _filterJenis).toList();
                }

                if (kasList.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.account_balance_wallet_outlined, size: 64, color: AppColors.textSecondary),
                        SizedBox(height: 16),
                        Text('Belum ada transaksi'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: kasList.length,
                  itemBuilder: (context, index) {
                    final kas = kasList[index];
                    return _buildKasCard(kas);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: canManage
          ? FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur tambah transaksi akan segera hadir')),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildKasCard(KasModel kas) {
    final isIncome = kas.jenis == 'masuk';
    
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isIncome ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? AppColors.success : AppColors.error,
          ),
        ),
        title: Text(
          kas.keterangan,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(kas.kategori),
            Text(
              Formatter.shortDate(kas.tanggal),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Text(
          '${isIncome ? '+' : '-'} ${Formatter.currency(kas.jumlah)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isIncome ? AppColors.success : AppColors.error,
          ),
        ),
        onTap: () {
          // Show detail
        },
      ),
    );
  }
}
