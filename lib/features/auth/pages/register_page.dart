import 'package:flutter/material.dart';
import '../../../core/services/auth_api_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _errorMessage;
  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    bool ok = true;
    setState(() {
      _fullNameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      if (_fullNameCtrl.text.trim().isEmpty) {
        _fullNameError = 'Nama lengkap tidak boleh kosong';
        ok = false;
      }
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
      if (_confirmPasswordCtrl.text.isEmpty) {
        _confirmPasswordError = 'Konfirmasi password tidak boleh kosong';
        ok = false;
      } else if (_confirmPasswordCtrl.text != _passwordCtrl.text) {
        _confirmPasswordError = 'Password tidak cocok';
        ok = false;
      }
    });
    return ok;
  }

  Future<void> _onRegister() async {
    if (!_validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await AuthApiService.register(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        nickname: _fullNameCtrl.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
        arguments: 'Akun berhasil dibuat! Silakan login.',
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          _buildScatteredAuras(sw, sh),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildBackButton(context),
                  const SizedBox(height: 32),
                  const Text('Buat Akun', style: AppTextStyles.heading1),
                  const Text(
                    'Mulai perjalanan kesehatan Anda',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_errorMessage != null) ...[
                          _buildErrorBanner(_errorMessage!),
                          const SizedBox(height: 20),
                        ],
                        _buildLabel('Nama'),
                        const SizedBox(height: 8),
                        _buildFieldBox(
                          controller: _fullNameCtrl,
                          hint: 'Masukkan nama Anda',
                          icon: Icons.badge_outlined,
                          textInputAction: TextInputAction.next,
                          error: _fullNameError,
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Alamat Email'),
                        const SizedBox(height: 8),
                        _buildFieldBox(
                          controller: _emailCtrl,
                          hint: 'Masukkan alamat email Anda',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          error: _emailError,
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Kata Sandi'),
                        const SizedBox(height: 8),
                        _buildFieldBox(
                          controller: _passwordCtrl,
                          hint: 'Buat kata sandi',
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
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Konfirmasi Kata Sandi'),
                        const SizedBox(height: 8),
                        _buildFieldBox(
                          controller: _confirmPasswordCtrl,
                          hint: 'Ulangi kata sandi Anda',
                          icon: Icons.shield_outlined,
                          obscure: _obscureConfirmPassword,
                          error: _confirmPasswordError,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.mutedForeground,
                              size: 20,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onRegister(),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _onRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: AppColors.primary.withValues(
                                alpha: 0.4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: _isLoading
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
                                      Text(
                                        'Buat Akun',
                                        style: AppTextStyles.buttonPrimary,
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 20),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildFooter(context),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.7),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
      ),
    );
  }

  Widget _buildFieldBox({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
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
            color: AppColors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: error != null
                  ? AppColors.destructive.withValues(alpha: 0.4)
                  : AppColors.primary.withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    (error != null ? AppColors.destructive : AppColors.primary)
                        .withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onSubmitted: onFieldSubmitted,
            onChanged: (_) {
              if (error != null) setState(() {});
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.mutedForeground.withValues(alpha: 0.5),
                fontSize: 15,
              ),
              prefixIcon: Icon(
                icon,
                color: error != null
                    ? AppColors.destructive.withValues(alpha: 0.7)
                    : AppColors.primary.withValues(alpha: 0.7),
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

  Widget _buildErrorBanner(String message) {
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
              message,
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
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.foreground,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        const Text('Sudah punya akun?', style: AppTextStyles.bodyMedium),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 58,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Masuk ke Akun',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScatteredAuras(double sw, double sh) {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: _buildAura(80, AppColors.primary.withValues(alpha: 0.06)),
        ),
        Positioned(
          top: sh * 0.3,
          left: -100,
          child: _buildAura(80, AppColors.secondary.withValues(alpha: 0.04)),
        ),
        Positioned(
          bottom: 100,
          right: 20,
          child: _buildAura(60, AppColors.accent.withValues(alpha: 0.06)),
        ),
      ],
    );
  }

  Widget _buildAura(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: size, spreadRadius: size * 0.4),
        ],
      ),
    );
  }
}
