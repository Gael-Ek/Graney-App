import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graney/graney/bloom_analysis/presentation/widgets/collapsible_analysis_panel.dart';
import 'package:graney/graney/cummunity/presentation/pages/community_screen.dart';
import 'package:graney/infrastructure/services/nasa_tile_provider.dart';
import 'package:graney/graney/statistics/presentation/pages/stats_screen.dart';
import 'package:graney/graney/timeline/presentation/pages/timeline_page.dart';
import 'package:graney/presentation/widgets/sidebar.dart';
import 'package:provider/provider.dart';
import '../providers/bloom_analysis_provider.dart';
import '../widgets/history_panel.dart';
import '../widgets/practical_applications_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(20.9674, -89.5926);
  Set<TileOverlay> _tileOverlays = {};
  Set<Circle> _circles = {};
  bool _showNasaLayer = false;
  String _selectedLayerType = 'ndvi';
  bool _showAnalysisPanel = true;

  // Radio del círculo en kilómetros
  final double _analysisRadiusKm = 10.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _analyzeLocation(_selectedLocation);
    });
  }

  void _analyzeLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _updateCircle(location);
    });
    context.read<BloomAnalysisProvider>().analyzeBloom(location);
  }

  void _updateCircle(LatLng center) {
    _circles = {
      Circle(
        circleId: const CircleId('analysis_area'),
        center: center,
        radius: _analysisRadiusKm * 1000, // Convertir km a metros
        fillColor: Colors.blue.withValues(alpha: .1),
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ),
    };
  }

  void _toggleNasaLayer() {
    setState(() {
      _showNasaLayer = !_showNasaLayer;
      if (_showNasaLayer) {
        _addNasaTileOverlay();
      } else {
        _tileOverlays.clear();
      }
    });
  }

  void _addNasaTileOverlay() {
    final tileProvider = NasaTileProvider(
      layerType: _selectedLayerType,
      targetLocation: _selectedLocation,
      maxDistance: 0.5,
    );

    final overlay = TileOverlay(
      tileOverlayId: const TileOverlayId('nasa_overlay'),
      tileProvider: tileProvider,
      transparency: 0.3,
    );

    setState(() {
      _tileOverlays = {overlay};
    });
  }

  void _handleNavigation(int index) {
    _scaffoldKey.currentState?.closeDrawer();

    switch (index) {
      case 1: // Comunidad
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CommunityScreen()),
        );
        break;
      case 2: // Estadísticas
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StatsScreen()),
        );
        break;
      case 3: // Timeline
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TimelinePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(
        currentIndex: 0,
        onClose: () => _scaffoldKey.currentState?.closeDrawer(),
        onItemSelected: _handleNavigation,
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Graney - Monitoreo de Floración'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _showAnalysisPanel ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _showAnalysisPanel = !_showAnalysisPanel;
              });
            },
            tooltip: _showAnalysisPanel ? 'Ocultar panel' : 'Mostrar panel',
          ),
          IconButton(
            icon: Icon(_showNasaLayer ? Icons.layers : Icons.layers_outlined),
            onPressed: _toggleNasaLayer,
            tooltip: 'Capas NASA',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.map),
            onSelected: (value) {
              setState(() {
                _selectedLayerType = value;
                if (_showNasaLayer) {
                  _addNasaTileOverlay();
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'ndvi', child: Text('NDVI (MODIS)')),
              const PopupMenuItem(value: 'evi', child: Text('EVI (MODIS)')),
              const PopupMenuItem(
                value: 'viirs',
                child: Text('VIIRS Color Real'),
              ),
              const PopupMenuItem(
                value: 'landsat',
                child: Text('Landsat 8/9 ⭐'),
              ), // NUEVO
              const PopupMenuItem(
                value: 'sentinel',
                child: Text('Sentinel-2 (ESA)'),
              ), // NUEVO
              const PopupMenuItem(
                value: 'temperature',
                child: Text('Temperatura'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: _showAnalysisPanel ? 3 : 7,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation,
                    zoom:
                        10, // Zoom ligeramente aumentado para mejor visualización del círculo
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onTap: _analyzeLocation,
                  markers: {
                    Marker(
                      markerId: const MarkerId('selected_location'),
                      position: _selectedLocation,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueGreen,
                      ),
                      infoWindow: InfoWindow(
                        title: 'Área de Análisis',
                        snippet: 'Radio: ${_analysisRadiusKm}km',
                      ),
                    ),
                  },
                  circles: _circles,
                  tileOverlays: _tileOverlays,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: true,
                ),
                if (_showNasaLayer)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.layers,
                            color: Colors.blue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedLayerType.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Leyenda del círculo
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: .1),
                            border: Border.all(color: Colors.blue, width: 2),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Área de análisis (${_analysisRadiusKm}km)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_showAnalysisPanel)
            Expanded(
              flex: 4,
              child: Consumer<BloomAnalysisProvider>(
                builder: (context, provider, child) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CollapsibleAnalysisPanel(
                          analysis: provider.currentAnalysis,
                          isLoading: provider.isAnalyzing,
                        ),
                        const SizedBox(height: 16),
                        if (provider.currentAnalysis != null)
                          PracticalApplicationsPanel(
                            analysis: provider.currentAnalysis,
                          ),
                        const SizedBox(height: 16),
                        HistoryPanel(
                          history: provider.historicalData,
                          isLoading: provider.isAnalyzing,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
