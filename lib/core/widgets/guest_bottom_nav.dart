import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/history/pages/history_page.dart';
import '../../features/profile/pages/profile_page.dart';

class GuestBottomNav extends StatelessWidget {
  final int currentIndex;
  const GuestBottomNav({super.key, required this.currentIndex});

  void _navigateToPage(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: const {'isGuest': true},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home_rounded, 'Beranda', 0),
          _buildNavItem(context, Icons.person_rounded, 'Profil', 1),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    bool isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          if (index == 0) {
            _navigateToPage(context, AppRoutes.home);
          } else if (index == 1) {
            _navigateToPage(context, AppRoutes.profile);
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppColors.primary
                  : AppColors.mutedForeground.withOpacity(0.6),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? AppColors.primary
                    : AppColors.mutedForeground.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
