import 'package:flutter/material.dart';
import 'package:graney/graney/bloom_analysis/domain/entities/bloom_analysis_entity.dart';

class HistoryPanel extends StatelessWidget {
  final List<BloomAnalysisEntity> history;
  final bool isLoading;

  const HistoryPanel({
    super.key,
    required this.history,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (history.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'No hay análisis previos',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Historial de Análisis',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  '${history.length} análisis',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...history.take(5).map((analysis) => _buildHistoryItem(analysis)),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BloomAnalysisEntity analysis) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getBloomColor(analysis.bloomProbability).withValues(alpha: .1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getBloomColor(analysis.bloomProbability),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getBloomIcon(analysis.bloomProbability),
                color: _getBloomColor(analysis.bloomProbability),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  analysis.bloomStatus,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getBloomColor(analysis.bloomProbability),
                  ),
                ),
              ),
              Text(
                _formatDate(analysis.lastUpdate),
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildMiniStat('NDVI', analysis.ndviValue.toStringAsFixed(2)),
              const SizedBox(width: 12),
              _buildMiniStat(
                'Probabilidad',
                '${(analysis.bloomProbability * 100).toStringAsFixed(0)}%',
              ),
              const SizedBox(width: 12),
              _buildMiniStat(
                'Confianza',
                '${(analysis.confidence * 100).toStringAsFixed(0)}%',
              ),
            ],
          ),
          if (analysis.globeObservationCount > 0) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${analysis.globeObservationCount} observaciones GLOBE',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Color _getBloomColor(double probability) {
    if (probability > 0.8) return Colors.pink;
    if (probability > 0.6) return Colors.purple;
    if (probability > 0.4) return Colors.orange;
    if (probability > 0.2) return Colors.green;
    return Colors.grey;
  }

  IconData _getBloomIcon(double probability) {
    if (probability > 0.8) return Icons.local_florist;
    if (probability > 0.6) return Icons.eco;
    if (probability > 0.4) return Icons.nature;
    return Icons.grass;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
