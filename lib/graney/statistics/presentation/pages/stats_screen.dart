import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/stats_provider.dart';
import '../widgets/ndvi_chart.dart';
import '../widgets/bloom_probability_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StatsProvider>().loadStats(
        const LatLng(20.9674, -89.5926),
        12,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas NASA'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<StatsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.stats == null) {
            return const Center(child: Text('No hay datos disponibles'));
          }

          final stats = provider.stats!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryCard(stats),
                const SizedBox(height: 16),
                NdviChart(monthlyData: stats.monthlyAvgNdvi),
                const SizedBox(height: 16),
                BloomProbabilityChart(
                  distribution: stats.bloomTypeDistribution,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Resumen Regional',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'NDVI Promedio',
                  stats.avgNdvi.toStringAsFixed(2),
                ),
                _buildStatItem('NDVI Máximo', stats.maxNdvi.toStringAsFixed(2)),
                _buildStatItem('Eventos', '${stats.totalBloomEvents}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
