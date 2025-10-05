import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NdviChart extends StatelessWidget {
  final Map<String, double> monthlyData;

  const NdviChart({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    final spots = monthlyData.entries.toList().asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NDVI Mensual',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.withValues(alpha: .2),
                      ),
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                  minY: 0,
                  maxY: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
