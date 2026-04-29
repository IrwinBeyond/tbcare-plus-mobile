import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../routes/app_routes.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background Auras
          _buildScatteredAuras(screenWidth, screenHeight),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Back Button
                  _buildBackButton(context),
                  const SizedBox(height: 32),
                  
                  // Header
                  const Text('Create Account', style: AppTextStyles.heading1),
                  const Text('Start your health journey', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 32),

                  // Register Form Card
                  _buildRegisterCard(),

                  const SizedBox(height: 40),
                  
                  // Footer
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
        child: const Icon(Icons.arrow_back, color: AppColors.foreground, size: 20),
      ),
    );
  }

  Widget _buildRegisterCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Full Name'),
              const SizedBox(height: 8),
              _buildTextField(hint: 'Enter your full name', icon: Icons.person_outline),
              const SizedBox(height: 20),

              _buildLabel('Email Address'),
              const SizedBox(height: 8),
              _buildTextField(hint: 'Enter your email address', icon: Icons.mail_outline),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Age'),
                        const SizedBox(height: 8),
                        _buildTextField(hint: 'Years', icon: Icons.calendar_today_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Gender'),
                        const SizedBox(height: 8),
                        _buildDropdownField(hint: 'Select'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildLabel('Password'),
              const SizedBox(height: 8),
              _buildTextField(hint: 'Create a password', icon: Icons.lock_outline, isPassword: true),
              const SizedBox(height: 20),

              _buildLabel('Confirm Password'),
              const SizedBox(height: 8),
              _buildTextField(hint: 'Repeat your password', icon: Icons.shield_outlined, isPassword: true),
              const SizedBox(height: 32),

              _buildCreateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
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

  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.mutedForeground.withOpacity(0.5), fontSize: 15),
          prefixIcon: Icon(icon, color: AppColors.primary.withOpacity(0.7), size: 20),
          suffixIcon: isPassword ? Icon(Icons.visibility_off_outlined, color: AppColors.mutedForeground.withOpacity(0.5), size: 20) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDropdownField({required String hint}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: TextStyle(color: AppColors.mutedForeground.withOpacity(0.5), fontSize: 15),
          ),
          Icon(Icons.keyboard_arrow_down, color: AppColors.mutedForeground.withOpacity(0.5), size: 20),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create Account', style: AppTextStyles.buttonPrimary),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Already have an account?',
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 58,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              'Login to Account',
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
        Positioned(top: -50, right: -50, child: _buildAura(150, AppColors.primary.withOpacity(0.1))),
        Positioned(top: sh * 0.3, left: -100, child: _buildAura(150, AppColors.secondary.withOpacity(0.05))),
        Positioned(bottom: 100, right: 20, child: _buildAura(100, AppColors.accent.withOpacity(0.1))),
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
          BoxShadow(
            color: color,
            blurRadius: size,
            spreadRadius: size / 2,
          ),
        ],
      ),
    );
  }
}
