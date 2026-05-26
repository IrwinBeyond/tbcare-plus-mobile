import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/home_header.dart';
import '../../../core/widgets/guest_bottom_nav.dart';
import '../../../routes/app_routes.dart';

class SymptomInfoPage extends StatefulWidget {
  const SymptomInfoPage({super.key});

  @override
  State<SymptomInfoPage> createState() => _SymptomInfoPageState();
}

class _SymptomInfoPageState extends State<SymptomInfoPage> {
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
              children: [
                const HomeHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wawasan Gejala Anda',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.foreground,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Memahami kondisi Anda saat ini dan apa artinya bagi kesehatan Anda.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Risk Alert Banner
                        _buildRiskAlertBanner(),

                        const SizedBox(height: 28),

                        // Reported Symptoms Section
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Gejala yang Dilaporkan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.foreground,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildSymptomCard(
                          Icons.show_chart_rounded,
                          'Batuk terus-menerus (2-3 minggu)',
                          'Batuk yang berlangsung lama adalah gejala utama tuberkulosis paru dan dapat menyebarkan bakteri melalui udara.',
                        ),
                        const SizedBox(height: 12),
                        _buildSymptomCard(
                          Icons.monitor_weight_outlined,
                          'Penurunan berat badan tanpa sebab',
                          'Penurunan berat badan dapat terjadi karena infeksi kronis yang memengaruhi metabolisme tubuh.',
                        ),
                        const SizedBox(height: 12),
                        _buildSymptomCard(
                          Icons.battery_alert_outlined,
                          'Kelelahan terus-menerus',
                          'Kelelahan menunjukkan bahwa tubuh sedang melawan infeksi dan kehilangan energi seiring waktu.',
                        ),
                        const SizedBox(height: 12),
                        _buildSymptomCard(
                          Icons.thermostat_outlined,
                          'Demam berkepanjangan atau keringat malam',
                          'Ini adalah respons imun umum terhadap infeksi tuberkulosis, terutama sering terjadi pada malam hari.',
                        ),

                        const SizedBox(height: 28),

                        // Why these symptoms matter
                        _buildWhyItMattersCard(),

                        const SizedBox(height: 20),

                        // Disclaimer
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.muted.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Tuberkulosis adalah penyakit menular melalui udara yang disebabkan oleh Mycobacterium tuberculosis.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic,
                              color: AppColors.mutedForeground,
                              height: 1.6,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // CTA Section
                        _buildCtaSection(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const GuestBottomNav(currentIndex: -1),
    );
  }

  Widget _buildRiskAlertBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.destructive.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.destructive.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.destructive.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.destructive,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.destructive.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.destructive,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'TINGKAT RISIKO TINGGI',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.destructive,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Berdasarkan jawaban Anda, Anda menunjukkan tanda-tanda yang sangat terkait dengan gejala TBC.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomCard(IconData icon, String title, String description) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.warning, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.foreground,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mutedForeground,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhyItMattersCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.medical_services_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Mengapa gejala ini penting',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foreground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Gejala ini umumnya terkait dengan tuberkulosis tahap awal dan digunakan untuk skrining klinis awal sebelum konfirmasi laboratorium.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mutedForeground,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCtaSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Disarankan untuk melanjutkan dengan pemeriksaan lengkap untuk evaluasi yang lebih akurat.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Continue Full Assessment Button
          SizedBox(
            width: double.infinity,
            height: 58,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.fullAssessment);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.destructive,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: AppColors.destructive.withOpacity(0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Lanjutkan Pemeriksaan Lengkap',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Back to Home Button
          SizedBox(
            width: double.infinity,
            height: 58,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Kembali ke Beranda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScatteredAuras(double sw, double sh) {
    return Stack(
      children: [
        Positioned(
          top: -sw * 0.1,
          right: -sw * 0.15,
          child: _buildAura(130, AppColors.primary.withOpacity(0.08)),
        ),
        Positioned(
          top: sh * 0.4,
          left: -sw * 0.2,
          child: _buildAura(180, AppColors.secondary.withOpacity(0.04)),
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
