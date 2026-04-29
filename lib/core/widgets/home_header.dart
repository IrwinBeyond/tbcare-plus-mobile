import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../features/profile/pages/profile_page.dart';

class HomeHeader extends StatelessWidget {
  final bool isGuest;
  const HomeHeader({super.key, this.isGuest = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Logo + App Name (Linked to Home)
          GestureDetector(
            onTap: () {
              // Only navigate if we're not already on Home
              if (ModalRoute.of(context)?.settings.name != AppRoutes.home) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
              }
            },
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'TBCare+',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // Right: Avatar + Greeting (navigates to Profile)
          GestureDetector(
            onTap: () {
              if (ModalRoute.of(context)?.settings.name != AppRoutes.profile) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const ProfilePage(),
                    settings: const RouteSettings(name: AppRoutes.profile),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      return SlideTransition(position: animation.drive(tween), child: child);
                    },
                  ),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: const DecorationImage(
                      image: NetworkImage('https://storage.googleapis.com/banani-avatars/avatar/male/18-25/European/4'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Hello, Guest',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
