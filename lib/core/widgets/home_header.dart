import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../routes/app_routes.dart';

class HomeHeader extends StatelessWidget {
  final bool isGuest;
  final String? userName;
  final bool showProfile;
  const HomeHeader({
    super.key,
    this.isGuest = true,
    this.userName,
    this.showProfile = true,
  });

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
                  width: 56,
                  height: 56,
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
                      'assets/images/img_logo_app.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 24,
                      color: Color(0xFF076453),
                      letterSpacing: -0.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'TB',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const TextSpan(
                        text: 'Care',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      WidgetSpan(
                        child: Transform.translate(
                          offset: const Offset(0, -6),
                          child: const Text(
                            '+',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF00BC99),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Right: Avatar + Greeting (navigates to Profile)
          if (showProfile)
            GestureDetector(
              onTap: () {
                if (ModalRoute.of(context)?.settings.name != AppRoutes.profile) {
                  Navigator.pushNamed(context, AppRoutes.profile);
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
                      color: isGuest ? AppColors.muted.withOpacity(0.3) : null,
                      border: Border.all(color: Colors.white, width: 2),
                      image: isGuest
                          ? null
                          : const DecorationImage(
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
                    child: isGuest
                        ? const Icon(Icons.person_outline_rounded, color: AppColors.mutedForeground, size: 24)
                        : null,
                  ),
                  if (!isGuest) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Halo, ${(userName != null && userName!.isNotEmpty) ? userName! : 'Pengguna'}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ],
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
