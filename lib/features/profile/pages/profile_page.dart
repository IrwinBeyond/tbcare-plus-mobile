import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/auth_api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/guest_bottom_nav.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/home_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isGuest = true;
  String? _userName;
  String? _userEmail;
  String? _profilePicture;

  String get _profilePicUrl => _profilePicture ?? StorageService.cachedUser?.profilePicture ?? '';
  bool _argumentsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argumentsLoaded) {
      _argumentsLoaded = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args.containsKey('isGuest'))
        _isGuest = args['isGuest'] as bool;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await StorageService.getUser();
    final tokens = (await StorageService.getAccessToken()) != null;
    if (!mounted) return;
    setState(() {
      _isGuest = user == null || !tokens;
      _userName = user?.fullName;
      _userEmail = user?.email;
      _profilePicture = user?.profilePicture;
    });
    if (user != null && tokens) {
      try {
        final updatedUser = await AuthApiService.fetchCurrentUser();
        if (mounted) {
          setState(() {
            _userName = updatedUser.fullName;
            _userEmail = updatedUser.email;
            _profilePicture = updatedUser.profilePicture;
          });
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildScatteredAuras(sw, sh),
          SafeArea(
            child: Column(
              children: [
                HomeHeader(
                  isGuest: _isGuest,
                  userName: _userName ?? StorageService.cachedUser?.fullName,
                  showProfile: false,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _isGuest ? _buildGuestCard(context) : _buildUserCard(),
                        const SizedBox(height: 24),
                        if (!_isGuest) ...[
                          _buildSectionTitle('Akun'),
                          const SizedBox(height: 12),
                          _buildMenuItem(
                            context,
                            icon: Icons.edit_outlined,
                            label: 'Edit Profil',
                            onTap: () async {
                              await Navigator.pushNamed(context, AppRoutes.editProfile);
                              if (mounted) _loadUser();
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildMenuItem(
                            context,
                            icon: Icons.lock_outline_rounded,
                            label: 'Ganti Kata Sandi',
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.changePassword,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                        if (!_isGuest) ...[
                          _buildSectionTitle('Lainnya'),
                          const SizedBox(height: 12),
                        ],
                        _buildMenuItem(
                          context,
                          icon: Icons.info_outline_rounded,
                          label: 'Tentang Aplikasi Ini',
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.about),
                        ),
                        const SizedBox(height: 32),
                        if (!_isGuest) ...[
                          _buildLogoutButton(context),
                          const SizedBox(height: 32),
                        ],
                        if (_isGuest) _buildWarningBanner(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isGuest
          ? const GuestBottomNav(currentIndex: 1)
          : AppBottomNav(
              currentIndex: 2,
              onTap: (i) {
                final routes = [
                  AppRoutes.home,
                  AppRoutes.history,
                  AppRoutes.profile,
                ];
                if (i < routes.length)
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    routes[i],
                    (route) => false,
                    arguments: {'isGuest': _isGuest},
                  );
              },
            ),
    );
  }

  Widget _buildSectionTitle(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: AppColors.foreground,
        letterSpacing: -0.3,
      ),
    ),
  );

  Widget _buildGuestCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.muted.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.muted.withOpacity(0.4),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 48,
                  color: AppColors.mutedForeground,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Anda menggunakan aplikasi sebagai tamu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.foreground,
                  letterSpacing: -0.5,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Masuk untuk menyimpan data pemeriksaan Anda dengan aman dan mengakses fitur lengkap di semua perangkat Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.mutedForeground,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.accent],
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.login),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Masuk / Daftar',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _profilePicUrl.isNotEmpty
                  ? null
                  : const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
              image: _profilePicUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(_profilePicUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: _profilePicUrl.isNotEmpty
                ? null
                : Center(
                    child: Text(
                      (_userName ?? _userEmail ?? StorageService.cachedUser?.fullName ?? StorageService.cachedUser?.email ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 24),
          Text(
            _userName ?? StorageService.cachedUser?.fullName ?? 'Pengguna',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.foreground,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          if ((_userEmail ?? StorageService.cachedUser?.email) != null)
            Text(
              _userEmail ?? StorageService.cachedUser?.email ?? '',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedForeground,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await StorageService.clear();
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.cover,
          (route) => false,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEF4444).withOpacity(0.15),
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 22,
                color: Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Keluar',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEF4444),
                  letterSpacing: -0.3,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: const Color(0xFFEF4444).withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
              child: Icon(icon, size: 22, color: AppColors.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.foreground,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.mutedForeground.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 20,
            color: AppColors.warning,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Data skrining Anda tidak akan disimpan secara permanen saat menggunakan mode tamu.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.foreground,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScatteredAuras(double sw, double sh) => Stack(
    children: [
      Positioned(
        top: -sw * 0.05,
        right: -sw * 0.1,
        child: _buildAura(175, AppColors.primary.withOpacity(0.1)),
      ),
      Positioned(
        top: sh * 0.3,
        left: -sw * 0.2,
        child: _buildAura(150, AppColors.secondary.withOpacity(0.05)),
      ),
    ],
  );

  Widget _buildAura(double size, Color color) => Container(
    width: size * 2,
    height: size * 2,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(color: color, blurRadius: size, spreadRadius: size / 2),
      ],
    ),
  );
}
