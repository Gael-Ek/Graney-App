import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/timeline_entity.dart';

class TemporalSlider extends StatelessWidget {
  final TimelineEntity timeline;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const TemporalSlider({
    super.key,
    required this.timeline,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat(
                    'dd MMM yyyy',
                  ).format(timeline.points[currentIndex].date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'NDVI: ${timeline.points[currentIndex].ndvi.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: timeline.points[currentIndex].hasBloom
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Slider(
              value: currentIndex.toDouble(),
              min: 0,
              max: (timeline.points.length - 1).toDouble(),
              divisions: timeline.points.length - 1,
              onChanged: (value) => onChanged(value.toInt()),
              activeColor: Colors.blue,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMM yyyy').format(timeline.startDate),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  DateFormat('MMM yyyy').format(timeline.endDate),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
