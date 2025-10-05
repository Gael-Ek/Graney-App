import 'package:flutter/material.dart';
import 'package:graney/graney/cummunity/presentation/pages/forum_screen.dart';
import 'package:graney/graney/cummunity/presentation/pages/gallery_screen.dart';
import 'package:graney/graney/statistics/presentation/pages/stats_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header de la comunidad
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.people, color: Colors.white, size: 32),
                        SizedBox(width: 12),
                        Text(
                          'Comunidad Graney',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Conecta con otros entusiastas de la naturaleza',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tarjetas de características
              _buildFeatureCard(
                context,
                icon: Icons.forum,
                title: 'Foro de Discusión',
                description:
                    'Comparte hallazgos y experiencias con la comunidad',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForumScreen()),
                ),
              ),
              _buildFeatureCard(
                context,
                icon: Icons.photo_library,
                title: 'Galería Comunitaria',
                description: 'Sube fotos de floraciones que hayas encontrado',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GalleryScreen(),
                  ),
                ),
              ),
              _buildFeatureCard(
                context,
                icon: Icons.leaderboard,
                title: 'Estadísticas NASA',
                description: 'Datos agregados de floraciones en tu región',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatsScreen()),
                ),
              ),
              const SizedBox(height: 30),

              // Actividad reciente
              _buildRecentActivity(),
              const SizedBox(height: 20), // Espacio adicional al final
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: Colors.blue, size: 28),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
            fontSize: 16,
          ),
        ),
        subtitle: Text(description, style: const TextStyle(fontSize: 14)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actividad Reciente',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildActivityItem(
                  'Ana Martínez',
                  'Reportó una floración en Puebla',
                  'Hace 2 horas',
                  Icons.eco,
                  Colors.green,
                ),
                const Divider(),
                _buildActivityItem(
                  'Carlos Rodríguez',
                  'Subió fotos de cultivos en floración',
                  'Hace 5 horas',
                  Icons.photo_library,
                  Colors.blue,
                ),
                const Divider(),
                _buildActivityItem(
                  'María González',
                  'Compartió datos de NDVI en el foro',
                  'Ayer',
                  Icons.forum,
                  Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String user,
    String action,
    String time,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: .1),
        child: Icon(icon, size: 20, color: color),
      ),
      title: Text(
        user,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      subtitle: Text(action, style: const TextStyle(fontSize: 12)),
      trailing: Text(
        time,
        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
      ),
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(vertical: -3), // Más compacto
      minLeadingWidth: 40,
    );
  }
}
