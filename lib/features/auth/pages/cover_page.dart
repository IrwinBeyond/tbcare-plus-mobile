import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/services/auth_api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({super.key});
  @override
  State<CoverPage> createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> with TickerProviderStateMixin {
  late AnimationController _dragController;
  late Animation<double> _dragAnimation;
  late AnimationController _entranceController;
  late Animation<double> _entranceAnimation;

  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoggingIn = false;
  String? _loginError;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _dragAnimation = CurvedAnimation(
      parent: _dragController,
      curve: Curves.easeOutQuad,
    );
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _entranceAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutQuad,
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _entranceController.forward();
    });
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final loggedIn = await StorageService.isLoggedIn();
    if (!mounted) return;
    if (loggedIn)
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
  }

  @override
  void dispose() {
    _dragController.dispose();
    _entranceController.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (!_entranceController.isCompleted) return;
    _dragController.value -= details.primaryDelta! / 400;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_dragController.value > 0.4) {
      _dragController.forward();
    } else {
      _dragController.reverse();
    }
  }

  bool _validateLogin() {
    bool ok = true;
    setState(() {
      _emailError = null;
      _passwordError = null;
      final email = _emailCtrl.text.trim();
      if (email.isEmpty) {
        _emailError = 'Email tidak boleh kosong';
        ok = false;
      } else if (!email.contains('@') || !email.contains('.')) {
        _emailError = 'Format email tidak valid (harus mengandung @ dan .)';
        ok = false;
      }
      if (_passwordCtrl.text.isEmpty) {
        _passwordError = 'Password tidak boleh kosong';
        ok = false;
      } else if (_passwordCtrl.text.length < 6) {
        _passwordError = 'Password minimal 6 karakter';
        ok = false;
      }
    });
    return ok;
  }

  Future<void> _onLogin() async {
    if (!_validateLogin()) return;
    setState(() {
      _isLoggingIn = true;
      _loginError = null;
    });
    try {
      final result = await AuthApiService.login(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      await StorageService.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      await StorageService.saveUser(result.user);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _loginError = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isLoggingIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildScatteredAuras(screenWidth, screenHeight),
          AnimatedBuilder(
            animation: Listenable.merge([_entranceAnimation, _dragAnimation]),
            builder: (ctx, child) {
              final keyboardHeight = MediaQuery.of(ctx).viewInsets.bottom;
              final tE = _entranceAnimation.value;
              final tD = _dragAnimation.value;
              const logoSize = 180.0;
              final logoStartTop = (screenHeight / 2) - (logoSize / 2);
              final logoCoverTop = screenHeight * 0.12;
              final logoLoginTop = screenHeight * -0.05;
              final logoPos = lerpDouble(
                lerpDouble(logoStartTop, logoCoverTop, tE),
                logoLoginTop,
                tD,
              )!;
              final logoOpacity = (1.0 - tD * 2.0).clamp(0.0, 1.0);
              final logoScale = 1.0 - (tD * 0.2);
              final sheetStartTop = screenHeight;
              final sheetCoverTop = screenHeight * 0.55;
              final sheetLoginTop = (screenHeight * 0.35 - keyboardHeight).clamp(0.0, screenHeight * 0.35);
              final sheetPos = lerpDouble(
                lerpDouble(sheetStartTop, sheetCoverTop, tE),
                sheetLoginTop,
                tD,
              )!;
              return Stack(
                children: [
                  Positioned(
                    top: logoPos,
                    left: (screenWidth - 210 * logoScale) / 2,
                    child: Opacity(
                      opacity: logoOpacity,
                      child: Transform.scale(
                        scale: logoScale,
                        child: _buildLogoWidget(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.08,
                    left: 24,
                    right: 24,
                    child: Opacity(
                      opacity: tD,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => _dragController.reverse(),
                            child: _buildBackIcon(),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Selamat Datang Kembali',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.foreground,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Masuk ke akun Anda',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: sheetPos,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onVerticalDragUpdate: _onVerticalDragUpdate,
                      onVerticalDragEnd: _onVerticalDragEnd,
                      child: _buildSheetContent(tD),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSheetContent(double t) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: (1.0 - t * 3.0).clamp(0.0, 1.0),
            child: SingleChildScrollView(child: _buildCoverSheetItems()),
          ),
          Opacity(
            opacity: (t * 3.0 - 2.0).clamp(0.0, 1.0),
            child: IgnorePointer(
              ignoring: t < 0.8,
              child: _buildLoginSheetItems(),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Container(
                width: 55,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverSheetItems() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          const SizedBox(height: 12),
          const Text(
            'Deteksi Dini untuk Kesehatan Lebih Baik. Pantau gejala Anda dan dapatkan wawasan akurat secara instan.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildLoginSheetItems() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_loginError != null) ...[
                  _buildLoginErrorBanner(),
                  const SizedBox(height: 20),
                ],
                _buildLabel('Alamat Email'),
                const SizedBox(height: 8),
                _buildFieldBox(
                  controller: _emailCtrl,
                  hint: 'Masukkan email Anda',
                  icon: Icons.mail_outline,
                  textInputAction: TextInputAction.next,
                  error: _emailError,
                ),
                const SizedBox(height: 24),
                _buildLabel('Kata Sandi'),
                const SizedBox(height: 8),
                _buildFieldBox(
                  controller: _passwordCtrl,
                  hint: 'Masukkan kata sandi Anda',
                  icon: Icons.lock_outline,
                  obscure: _obscurePassword,
                  error: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.mutedForeground,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _onLogin(),
                ),
                const SizedBox(height: 32),
                _buildLoginButton(),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'Belum punya akun?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Buat Akun',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.7),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.arrow_back,
        color: AppColors.foreground,
        size: 20,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Mulai', style: AppTextStyles.buttonPrimary),
          ),
        ),
        const SizedBox(height: 14),
        _buildSecondaryButton('Lanjutkan sebagai Tamu', () {
          Navigator.pushNamed(context, AppRoutes.home);
        }),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: _isLoggingIn ? null : _onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: _isLoggingIn
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Masuk', style: AppTextStyles.buttonPrimary),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                ],
              ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: AppColors.primary.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text, style: AppTextStyles.buttonSecondary),
      ),
    );
  }

  Widget _buildFieldBox({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputAction textInputAction = TextInputAction.next,
    void Function(String)? onFieldSubmitted,
    bool obscure = false,
    Widget? suffixIcon,
    String? error,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: error != null
                  ? AppColors.destructive.withOpacity(0.4)
                  : AppColors.primary.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: (error != null ? AppColors.destructive : Colors.black)
                    .withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            textInputAction: textInputAction,
            onSubmitted: onFieldSubmitted,
            onChanged: (_) {
              if (error != null) setState(() {});
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedForeground.withOpacity(0.5),
              ),
              prefixIcon: Icon(
                icon,
                color: error != null
                    ? AppColors.destructive.withOpacity(0.7)
                    : AppColors.primary.withOpacity(0.7),
                size: 20,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 6),
            child: Text(
              error,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.destructive,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoginErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _loginError!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.red.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.foreground,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoWidget() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(52),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          'assets/images/img_logo_app.png',
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildScatteredAuras(double sw, double sh) {
    return Stack(
      children: [
        Positioned(
          top: -40,
          left: -40,
          child: _buildAura(100, AppColors.primary.withOpacity(0.08)),
        ),
        Positioned(
          top: sh * 0.2,
          right: -60,
          child: _buildAura(80, AppColors.primary.withOpacity(0.06)),
        ),
        Positioned(
          bottom: sh * 0.2,
          left: -60,
          child: _buildAura(70, AppColors.accent.withOpacity(0.06)),
        ),
        Positioned(
          top: sh * 0.5,
          left: sw * 0.4,
          child: _buildAura(60, AppColors.primary.withOpacity(0.05)),
        ),
      ],
    );
  }

  Widget _buildAura(double size, Color color) {
    return Container(
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
}
