import 'package:flutter/material.dart';
import 'package:graney/infrastructure/services/alert_service.dart';
import '../../domain/entities/bloom_analysis_entity.dart';
import '../../../../domain/shared/enums/vegetation_type.dart';

class PracticalApplicationsPanel extends StatelessWidget {
  final BloomAnalysisEntity? analysis;

  const PracticalApplicationsPanel({super.key, this.analysis});

  @override
  Widget build(BuildContext context) {
    if (analysis == null) return const SizedBox();

    final alerts = AlertService.generateAlerts(analysis!);
    final recommendation = AlertService.getConservationRecommendation(
      analysis!,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎯 Aplicaciones Prácticas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            if (alerts.isNotEmpty) ...[
              const Text(
                '🚨 Alertas de Salud:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...alerts.map((alert) => Text('• $alert')),
              const SizedBox(height: 12),
            ],

            const Text(
              '💚 Conservación:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• $recommendation'),

            const SizedBox(height: 12),

            const Text(
              '🌍 Aplicaciones:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• ${_getApplicationText(analysis!)}'),
          ],
        ),
      ),
    );
  }

  String _getApplicationText(BloomAnalysisEntity analysis) {
    if (analysis.vegetationType == VegetationType.agricultural) {
      return 'Monitoreo de cultivos - Optimización de cosechas';
    } else if (analysis.vegetationType == VegetationType.forest) {
      return 'Conservación de bosques - Estudio de biodiversidad';
    } else {
      return 'Investigación ecológica - Monitoreo ambiental';
    }
  }
}
