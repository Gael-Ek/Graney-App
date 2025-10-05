import 'package:flutter/material.dart';
import '../../domain/entities/bloom_analysis_entity.dart';
import '../../../../domain/shared/enums/bloom_type.dart';

class BloomAnalysisPanel extends StatelessWidget {
  final BloomAnalysisEntity? analysis;
  final bool isLoading;

  const BloomAnalysisPanel({super.key, this.analysis, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (analysis == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(
                Icons.location_searching,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Selecciona una ubicación para analizar floración',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ AHORA analysis NO ES NULL
    final analysisData = analysis!;
    final primaryColor = Color(
      BloomAnalysisEntity.getColorFromHex(analysisData.primaryColor),
    );
    final textColor = Color(
      BloomAnalysisEntity.getColorFromHex(analysisData.textOnPrimaryColor),
    );
    final badgeStyle = analysisData.intensityBadgeStyle;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con color unificado
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    badgeStyle['emoji']!,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Análisis de Floración - ${analysisData.bloomIntensity.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (analysisData.bloomType != null &&
                analysisData.bloomType != BloomType.none)
              Column(
                children: [
                  _buildMetricCard(
                    icon: Icons.local_florist,
                    label: 'Tipo de Floración',
                    value: analysisData.bloomType!.displayName,
                    emoji: analysisData.bloomType!.emoji,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 12),
                ],
              ),

            _buildMetricCard(
              icon: Icons.eco,
              label: 'Índice de Vegetación (NDVI)',
              value: analysisData.ndviValue.toStringAsFixed(2),
              emoji: _getNDVIEmoji(analysisData.ndviValue),
              color: primaryColor,
            ),
            const SizedBox(height: 12),

            _buildMetricCard(
              icon: Icons.auto_graph,
              label: 'Probabilidad de Floración',
              value:
                  '${(analysisData.bloomProbability * 100).toStringAsFixed(0)}%',
              emoji: _getProbabilityEmoji(analysisData.bloomProbability),
              color: primaryColor,
            ),
            const SizedBox(height: 12),

            _buildMetricCard(
              icon: Icons.verified,
              label: 'Confianza del Análisis',
              value: '${(analysisData.confidence * 100).toStringAsFixed(0)}%',
              emoji: _getConfidenceEmoji(analysisData.confidence),
              color: primaryColor,
            ),
            const SizedBox(height: 12),

            _buildMetricCard(
              icon: Icons.park,
              label: 'Tipo de Vegetación',
              value: analysisData.vegetationType.displayName,
              emoji: '🌿',
              color: primaryColor,
            ),
            const SizedBox(height: 16),

            // Badge de intensidad con colores unificados
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(
                  BloomAnalysisEntity.getColorFromHex(
                    badgeStyle['background']!,
                  ),
                ),
                border: Border.all(
                  color: Color(
                    BloomAnalysisEntity.getColorFromHex(badgeStyle['border']!),
                  ),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    badgeStyle['emoji']!,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'INTENSIDAD: ${analysisData.bloomIntensity.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(
                        BloomAnalysisEntity.getColorFromHex(
                          badgeStyle['text']!,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (analysisData.dataSources != null)
              _buildDataSources(analysisData.dataSources!, primaryColor),

            const SizedBox(height: 16),

            Text(
              'Última actualización: ${_formatDate(analysisData.lastUpdate)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required String emoji,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataSources(Map<String, bool> dataSources, Color color) {
    final activeSources = dataSources.entries
        .where((entry) => entry.value)
        .length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.data_usage, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fuentes de Datos ($activeSources activas)',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  dataSources.entries
                      .where((e) => e.value)
                      .map((e) => e.key)
                      .join(', '),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getNDVIEmoji(double ndvi) {
    if (ndvi > 0.7) return '🌿🌺';
    if (ndvi > 0.5) return '🌿';
    if (ndvi > 0.3) return '🍂';
    return '🏜️';
  }

  String _getProbabilityEmoji(double probability) {
    if (probability > 0.8) return '🎯';
    if (probability > 0.6) return '✅';
    if (probability > 0.4) return '⚠️';
    return '❌';
  }

  String _getConfidenceEmoji(double confidence) {
    if (confidence > 0.8) return '🔮';
    if (confidence > 0.6) return '📊';
    return '🎲';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
