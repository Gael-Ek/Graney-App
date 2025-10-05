// presentation/shared/widgets/sidebar.dart
import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final VoidCallback onClose;
  final Function(int) onItemSelected;
  final int currentIndex;

  const Sidebar({
    super.key,
    required this.onClose,
    required this.onItemSelected,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.eco, color: Colors.blue, size: 30),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Graney',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Monitoreo Inteligente',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(color: Colors.grey[300], height: 1),
          ),
          const SizedBox(height: 24),

          _buildMenuOption(
            icon: Icons.home,
            title: 'Inicio',
            isSelected: currentIndex == 0,
            onTap: () => onItemSelected(0),
          ),
          _buildMenuOption(
            icon: Icons.people,
            title: 'Comunidad',
            isSelected: currentIndex == 1,
            onTap: () => onItemSelected(1),
          ),
          _buildMenuOption(
            icon: Icons.leaderboard,
            title: 'Estadísticas',
            isSelected: currentIndex == 2,
            onTap: () => onItemSelected(2),
          ),
          _buildMenuOption(
            icon: Icons.timeline,
            title: 'Timeline',
            isSelected: currentIndex == 3,
            onTap: () => onItemSelected(3),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Datos provistos por NASA',
                      style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'v1.0.0',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.blue.withValues(alpha: .1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey[700],
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 16)
            : null,
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        minLeadingWidth: 0,
      ),
    );
  }
}
