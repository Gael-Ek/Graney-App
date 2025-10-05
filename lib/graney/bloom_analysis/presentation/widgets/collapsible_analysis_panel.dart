import 'package:flutter/material.dart';
import '../../domain/entities/bloom_analysis_entity.dart';
import '../widgets/bloom_analysis_panel.dart';

class CollapsibleAnalysisPanel extends StatefulWidget {
  final BloomAnalysisEntity? analysis;
  final bool isLoading;

  const CollapsibleAnalysisPanel({
    super.key,
    this.analysis,
    this.isLoading = false,
  });

  @override
  State<CollapsibleAnalysisPanel> createState() =>
      _CollapsibleAnalysisPanelState();
}

class _CollapsibleAnalysisPanelState extends State<CollapsibleAnalysisPanel> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    // Obtener color del análisis o usar azul por defecto
    final headerColor = widget.analysis != null
        ? Color(
            BloomAnalysisEntity.getColorFromHex(widget.analysis!.primaryColor),
          )
        : Colors.blue;

    return Card(
      elevation: 4,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: headerColor.withValues(alpha: .1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.analytics, color: headerColor),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Análisis de Floración',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: headerColor,
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BloomAnalysisPanel(
                      analysis: widget.analysis,
                      isLoading: widget.isLoading,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
