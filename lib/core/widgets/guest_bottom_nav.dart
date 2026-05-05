import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/history/pages/history_page.dart';
import '../../features/profile/pages/profile_page.dart';

class GuestBottomNav extends StatelessWidget {
  final int currentIndex;
  const GuestBottomNav({super.key, required this.currentIndex});

  void _navigateWithSlide(BuildContext context, Widget page, String routeName, bool slideFromRight) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        settings: RouteSettings(name: routeName),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final begin = Offset(slideFromRight ? 1.0 : -1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
      (route) => false,
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
          _buildNavItem(context, Icons.home_rounded, 'Home', 0),
          _buildNavItem(context, Icons.access_time_rounded, 'History', 1),
          _buildNavItem(context, Icons.person_rounded, 'Profile', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    bool isActive = currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          bool slideFromRight = index > currentIndex;
          if (index == 0) {
            _navigateWithSlide(context, const HomePage(), AppRoutes.home, slideFromRight);
          } else if (index == 1) {
            _navigateWithSlide(context, const HistoryPage(), AppRoutes.history, slideFromRight);
          } else if (index == 2) {
            _navigateWithSlide(context, const ProfilePage(), AppRoutes.profile, slideFromRight);
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.mutedForeground.withOpacity(0.6),
              size: 26,
            ),
            if (isActive) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
