import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/guest_bottom_nav.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../routes/app_routes.dart';
import '../../../core/services/storage_service.dart';

class SymptomInfoPage extends StatefulWidget {
  final bool isGuest;
  const SymptomInfoPage({super.key, this.isGuest = true});
  @override
  State<SymptomInfoPage> createState() => _SymptomInfoPageState();
}

class _SymptomInfoPageState extends State<SymptomInfoPage> {
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
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.isGuest
          ? const GuestBottomNav(currentIndex: -1)
          : AppBottomNav(
              currentIndex: -1,
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
                    arguments: {'isGuest': widget.isGuest},
                  );
              },
            ),
    );
  }

  Widget _buildHeader(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
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
        const SizedBox(width: 16),
        const Expanded(
          child: Text(
            'Informasi Gejala',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.foreground,
              letterSpacing: -0.3,
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    ),
  );

  Widget _buildContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInfoBanner(),
      const SizedBox(height: 24),
      _buildSection('Gejala Umum TBC', Icons.coronavirus_outlined, [
        'Batuk berdahak lebih dari 2 minggu',
        'Batuk darah',
        'Nyeri dada saat bernapas atau batuk',
        'Berkeringat di malam hari tanpa aktivitas',
        'Demam dan menggigil',
        'Kehilangan nafsu makan',
        'Penurunan berat badan tanpa sebab jelas',
        'Kelelahan yang tidak wajar',
      ]),
      const SizedBox(height: 16),
      _buildSection('Gejala TBC Ekstra Paru', Icons.accessibility_new_rounded, [
        'Pembengkakan kelenjar getah bening',
        'Nyeri tulang atau sendi',
        'Sakit kepala dan kaku kuduk (meningitis TBC)',
        'Nyeri perut (TBC usus)',
        'Sesak napas (TBC pleura)',
      ]),
      const SizedBox(height: 24),
      _buildDisclaimerCard(),
    ],
  );

  Widget _buildInfoBanner() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.85),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.05),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Gejala TBC dapat bervariasi tergantung pada jenis dan tingkat keparahan infeksi. Konsultasikan dengan tenaga medis untuk diagnosis yang akurat.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.foreground,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildSection(String title, IconData icon, List<String> items) =>
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foreground,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.foreground,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildDisclaimerCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.warning.withOpacity(0.1),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFF59E0B).withOpacity(0.15),
          blurRadius: 30,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Text(
            'Informasi ini hanya untuk edukasi. Silakan lanjutkan ke pemeriksaan lengkap untuk penilaian risiko yang lebih akurat.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.foreground,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildScatteredAuras(double sw, double sh) => Stack(
    children: [
      Positioned(
        top: -sw * 0.05,
        right: -sw * 0.1,
        child: _buildAura(175, AppColors.primary.withOpacity(0.08)),
      ),
      Positioned(
        top: sh * 0.3,
        left: -sw * 0.2,
        child: _buildAura(150, AppColors.secondary.withOpacity(0.04)),
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
