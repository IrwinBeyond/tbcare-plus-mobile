import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../core/services/asset_service.dart';

ImageProvider _profileImage(String url) => AssetService.profileImage(url);

class HomeHeader extends StatelessWidget {
  final bool isGuest;
  final String? userName;
  final String? profilePicture;
  final bool showProfile;
  const HomeHeader({
    super.key,
    this.isGuest = true,
    this.userName,
    this.profilePicture,
    this.showProfile = true,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app-home-header',
      flightShuttleBuilder:
          (flightContext, animation, direction, fromContext, toContext) =>
              toContext.widget,
      child: Material(
        type: MaterialType.transparency,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Logo + App Name
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
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

          // Right: Avatar + Greeting (navigates to Profile)
          if (showProfile)
            GestureDetector(
              onTap: () {
                if (ModalRoute.of(context)?.settings.name !=
                    AppRoutes.profile) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.profile,
                    (route) => false,
                    arguments: {'isGuest': isGuest},
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
                      gradient:
                          (!isGuest &&
                              (profilePicture == null ||
                                  profilePicture!.isEmpty))
                          ? const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            )
                          : null,
                      color: isGuest ? AppColors.muted.withValues(alpha: 0.3) : null,
                      border: Border.all(color: Colors.white, width: 2),
                      image:
                          (!isGuest &&
                              profilePicture != null &&
                              profilePicture!.isNotEmpty)
                          ? DecorationImage(
                              image: _profileImage(profilePicture!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isGuest
                        ? const Icon(
                            Icons.person_outline_rounded,
                            color: AppColors.mutedForeground,
                            size: 24,
                          )
                        : (profilePicture == null || profilePicture!.isEmpty)
                        ? Center(
                            child: Text(
                              (userName ?? 'U')[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : null,
                  ),
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
