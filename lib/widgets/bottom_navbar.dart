import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Colors.brown.shade600;
    final Color inactiveColor = Colors.grey;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // KIRI: Home (index 0)
            _buildNavItem(
              icon: currentIndex == 0 ? Icons.home : Icons.home_outlined,
              label: 'Home',
              isActive: currentIndex == 0,
              color: currentIndex == 0 ? activeColor : inactiveColor,
              onTap: () => onTap(0),
            ),

            // TENGAH: Linimasa (index 1) ← INI YANG KAMU MAU DI TENGAH
            _buildNavItem(
              icon: currentIndex == 1 ? Icons.timeline : Icons.timeline_outlined,
              label: 'Linimasa',
              isActive: currentIndex == 1,
              color: currentIndex == 1 ? activeColor : inactiveColor,
              onTap: () => onTap(1),
            ),

            // KANAN: Profil (index 2)
            _buildNavItem(
              icon: currentIndex == 2 ? Icons.person : Icons.person_outline,
              label: 'Profil',
              isActive: currentIndex == 2,
              color: currentIndex == 2 ? activeColor : inactiveColor,
              onTap: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}