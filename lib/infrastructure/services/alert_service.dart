import 'package:graney/graney/bloom_analysis/domain/entities/bloom_analysis_entity.dart';

import '../../../domain/shared/enums/vegetation_type.dart';

class AlertService {
  static List<String> generateAlerts(BloomAnalysisEntity analysis) {
    final alerts = <String>[];

    if (analysis.isBloomDetected) {
      if (analysis.bloomIntensity == 'alta') {
        alerts.add(
          'Alta producción de polen - Personas alérgicas tomar precauciones',
        );
        alerts.add('Época ideal para observación de polinizadores');
      }

      if (analysis.vegetationType == VegetationType.agricultural) {
        alerts.add('🌾 Cultivos en floración - Optimizar riego y nutrientes');
      }
    }

    return alerts;
  }

  static String getConservationRecommendation(BloomAnalysisEntity analysis) {
    if (analysis.isBloomDetected) {
      return 'Considerar actividades de conservación durante este periodo de floración';
    }
    return 'Periodo de baja actividad floral - Planificar para próxima temporada';
  }
}
