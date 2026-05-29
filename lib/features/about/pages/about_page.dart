import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Auras
          _buildScatteredAuras(screenWidth, screenHeight),

          // Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(context),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: Column(
                      children: [
                        // What is TBCare+?
                        _buildInfoCard(
                          icon: Icons.info_outline_rounded,
                          title: 'Apa itu TBCare+?',
                          child: const Text(
                            'TBCare+ adalah aplikasi kesehatan digital yang dirancang untuk mendukung deteksi dini tuberkulosis (TBC) melalui skrining berbasis gejala dan kesadaran kesehatan.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.foreground,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Our Purpose
                        _buildInfoCard(
                          icon: Icons.gps_fixed_rounded,
                          title: 'Tujuan Kami',
                          child: Column(
                            children: [
                              _buildCheckItem(
                                'Membantu pengguna mengidentifikasi gejala awal TBC',
                              ),
                              const SizedBox(height: 12),
                              _buildCheckItem(
                                'Mendorong konsultasi medis tepat waktu',
                              ),
                              const SizedBox(height: 12),
                              _buildCheckItem(
                                'Meningkatkan kesadaran tentang tuberkulosis',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // How It Works
                        _buildInfoCard(
                          icon: Icons.list_alt_rounded,
                          title: 'Cara Kerja',
                          child: _buildTimeline(),
                        ),
                        const SizedBox(height: 20),

                        // Disclaimer
                        _buildDisclaimerCard(),
                        const SizedBox(height: 20),

                        // About Tuberculosis
                        _buildInfoCard(
                          icon: Icons.monitor_heart_outlined,
                          title: 'Tentang Tuberkulosis',
                          child: const Text(
                            'Tuberkulosis adalah penyakit menular melalui udara yang disebabkan oleh bakteri yang terutama menyerang paru-paru tetapi juga dapat memengaruhi bagian tubuh lainnya.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.foreground,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Footer
                        _buildFooter(),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── HEADER ───────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
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
          ),
          const SizedBox(height: 24),

          // Title
          const Text(
            'Tentang Aplikasi Ini',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.foreground,
              letterSpacing: -1.0,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pelajari lebih lanjut tentang TBCare+',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  // ─── INFO CARD ────────────────────────────────────────────
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF047857).withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: Icon(icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // ─── CHECK ITEM ───────────────────────────────────────────
  Widget _buildCheckItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.1),
          ),
          child: const Icon(Icons.check, size: 12, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground,
              height: 1.375,
            ),
          ),
        ),
      ],
    );
  }

  // ─── TIMELINE ─────────────────────────────────────────────
  Widget _buildTimeline() {
    final steps = [
      'Jawab pemeriksaan kesehatan singkat atau lengkap',
      'Terima evaluasi risiko',
      'Dapatkan rekomendasi berdasarkan kondisi Anda',
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index < steps.length - 1 ? 16 : 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step number with connecting line
              Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: AppColors.primary, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  if (index < steps.length - 1)
                    Container(
                      width: 1,
                      height: 20,
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Step text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    steps[index],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.foreground,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ─── DISCLAIMER CARD ──────────────────────────────────────
  Widget _buildDisclaimerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.warning.withValues(alpha: 0.2),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  size: 20,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Penafian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.foreground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Aplikasi ini bukan pengganti diagnosis medis profesional. Pengguna disarankan untuk berkonsultasi dengan penyedia layanan kesehatan untuk pemeriksaan dan perawatan yang akurat.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground,
              height: 1.625,
            ),
          ),
        ],
      ),
    );
  }

  // ─── FOOTER ───────────────────────────────────────────────
  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/images/img_logo_app.png',
              width: 56,
              height: 56,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.shield_outlined,
                color: AppColors.primary,
                size: 48,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Versi 1.0 • Dikembangkan untuk\ntujuan edukasi dan\nkesadaran kesehatan',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.mutedForeground,
            height: 1.625,
          ),
        ),
      ],
    );
  }

  // ─── BACKGROUND AURAS ─────────────────────────────────────
  Widget _buildScatteredAuras(double sw, double sh) {
    return Stack(
      children: [
        Positioned(
          top: -sh * 0.05,
          right: -sw * 0.1,
          child: _buildAura(175, AppColors.primary.withValues(alpha: 0.1)),
        ),
        Positioned(
          top: sh * 0.4,
          left: -sw * 0.2,
          child: _buildAura(150, AppColors.secondary.withValues(alpha: 0.05)),
        ),
        Positioned(
          bottom: sh * 0.1,
          right: -sw * 0.1,
          child: _buildAura(125, AppColors.accent.withValues(alpha: 0.05)),
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
