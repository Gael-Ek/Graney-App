import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/timeline_provider.dart';
import '../widgets/temporal_slider.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TimelineProvider>().loadTimeline(
        const LatLng(20.9674, -89.5926),
        DateTime.now().subtract(const Duration(days: 180)),
        DateTime.now(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline de Floración'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<TimelineProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.timeline == null) {
            return const Center(child: Text('No hay datos de timeline'));
          }

          final timeline = provider.timeline!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: timeline.points.length,
                  itemBuilder: (context, index) {
                    final point = timeline.points[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          point.hasBloom ? Icons.eco : Icons.circle,
                          color: point.hasBloom ? Colors.green : Colors.grey,
                        ),
                        title: Text(
                          '${point.date.day}/${point.date.month}/${point.date.year}',
                        ),
                        subtitle: Text(
                          'NDVI: ${point.ndvi.toStringAsFixed(2)}',
                        ),
                        trailing: point.hasBloom
                            ? const Chip(
                                label: Text('Floración'),
                                backgroundColor: Colors.green,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
              TemporalSlider(
                timeline: timeline,
                currentIndex: provider.currentIndex,
                onChanged: provider.updateIndex,
              ),
            ],
          );
        },
      ),
    );
  }
}
