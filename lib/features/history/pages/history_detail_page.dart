import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class HistoryDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const HistoryDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item['color'] as Color;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Filter symptoms where status is true
    final List<dynamic> rawSymptoms = item['symptoms'] ?? [
      {
        'name': 'Batuk Kronis',
        'status': true,
        'desc': 'Batuk yang berlangsung lebih dari 2 minggu. Ini bisa menjadi tanda berbagai masalah pernapasan dan memerlukan pemantauan oleh tenaga medis untuk memastikan diagnosis yang tepat.'
      },
      {
        'name': 'Nyeri Dada',
        'status': true,
        'desc': 'Nyeri tajam saat bernapas atau batuk. Ini mungkin mengindikasikan peradangan pada lapisan paru-paru atau kondisi serius lainnya yang memerlukan perhatian segera dan tes diagnostik.'
      },
      {
        'name': 'Kelelahan',
        'status': true,
        'desc': 'Merasa sangat lelah atau lemah. Ini adalah gejala sistemik umum yang dapat berdampak signifikan pada aktivitas sehari-hari dan sering terlihat pada infeksi kronis.'
      },
      {
        'name': 'Keringat Malam',
        'status': false,
        'desc': 'Berkeringat deras saat tidur. Sering disertai demam, ini adalah gejala klasik dari beberapa infeksi seperti tuberkulosis.'
      },
      {
        'name': 'Penurunan Berat Badan',
        'status': true,
        'desc': 'Penurunan berat badan yang tidak dapat dijelaskan. Kehilangan berat badan tanpa usaha bisa menjadi tanda masalah kesehatan serius dan harus diperiksa oleh dokter.'
      },
    ];

    final symptoms = rawSymptoms.where((s) => s['status'] == true).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Auras
          _buildScatteredAuras(screenWidth, screenHeight, color),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, color),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Result Summary Card
                        _buildSummaryCard(color),
                        const SizedBox(height: 24),

                        // Insight Section
                        const Text(
                          'Wawasan Gejala',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.foreground,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Symptom List
                        ...symptoms.map((s) => _buildSymptomItem(context, s, color)).toList(),
                        
                        const SizedBox(height: 32),
                        
                        // Recommendation
                        _buildRecommendationCard(color),
                        const SizedBox(height: 40),
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

  Widget _buildHeader(BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: color),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Detail Pemeriksaan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: color.withOpacity(0.2), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['date'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: color.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['type'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: color.withOpacity(0.6),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'], color: color, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    item['percentage'],
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: color,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    'Tingkat Risiko',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Container(width: 2, height: 60, color: color.withOpacity(0.1)),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['riskLevel'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: color,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Memerlukan perhatian segera',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: color.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomItem(BuildContext context, Map<String, dynamic> symptom, Color themeColor) {
    return GestureDetector(
      onTap: () => _showSymptomDetail(context, symptom, themeColor),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: themeColor.withOpacity(0.15), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColor.withOpacity(0.15), themeColor.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: themeColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    symptom['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.foreground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    symptom['desc'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mutedForeground.withOpacity(0.8),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: themeColor.withOpacity(0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showSymptomDetail(BuildContext context, Map<String, dynamic> symptom, Color color) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const SizedBox(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(Icons.info_outline_rounded, color: color, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    symptom['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.foreground,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'PENJELASAN',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              symptom['desc'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.foreground.withOpacity(0.7),
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  backgroundColor: color,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 8,
                                  shadowColor: color.withOpacity(0.4),
                                ),
                                child: const Text(
                                  'Mengerti, terima kasih',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecommendationCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withBlue(100)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rekomendasi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Silakan kunjungi fasilitas kesehatan terdekat untuk tes dahak atau rontgen dada.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
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

  Widget _buildScatteredAuras(double sw, double sh, Color color) {
    return Stack(
      children: [
        Positioned(
          top: -sh * 0.1,
          right: -sw * 0.2,
          child: _buildAura(200, color.withOpacity(0.1)),
        ),
        Positioned(
          bottom: sh * 0.1,
          left: -sw * 0.3,
          child: _buildAura(250, color.withOpacity(0.05)),
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
