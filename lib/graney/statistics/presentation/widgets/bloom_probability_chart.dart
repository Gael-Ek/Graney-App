import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BloomProbabilityChart extends StatelessWidget {
  final Map<String, int> distribution;

  const BloomProbabilityChart({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribución de Tipos de Floración',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: distribution.entries.map((entry) {
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: entry.key,
                      color: _getColorForType(entry.key),
                      radius: 80,
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'Primavera':
        return Colors.pink;
      case 'Tropical':
        return Colors.orange;
      case 'Agrícola':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
