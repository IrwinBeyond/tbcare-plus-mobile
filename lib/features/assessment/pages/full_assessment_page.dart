import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/guest_bottom_nav.dart';
import '../../../routes/app_routes.dart';

class FullAssessmentPage extends StatefulWidget {
  const FullAssessmentPage({super.key});

  @override
  State<FullAssessmentPage> createState() => _FullAssessmentPageState();
}

class _FullAssessmentPageState extends State<FullAssessmentPage> {
  // Section 1: General Symptoms (toggle switches)
  final Map<String, bool> _generalSymptoms = {
    'persistent_cough': false,
    'coughing_blood': false,
    'prolonged_fever': false,
    'weight_loss': false,
  };

  // Section 2: Symptom Variations (chip selection)
  final Map<String, bool> _symptomVariations = {
    'mild_cough': false,
    'severe_cough': false,
    'low_fever': false,
    'high_fever': false,
    'night_sweats': false,
    'fatigue': false,
    'loss_appetite': false,
  };

  // Section 3: Lymph Node TB (checkboxes)
  final Map<String, bool> _lymphNodeSymptoms = {
    'swelling_lumps': false,
    'inflammation': false,
    'movable_lumps': false,
    'enlarging_lumps': false,
    'lump_rupture': false,
  };

  // Section 4: Spinal & Breast TB (grid cards)
  final Map<String, bool> _spinalBreastSymptoms = {
    'back_pain': false,
    'stiffness': false,
    'breast_lump': false,
    'breast_inflammation': false,
  };

  // Section expansion states
  final Map<int, bool> _sectionExpanded = {
    0: true,
    1: true,
    2: true,
    3: true,
  };

  int get _answeredCount {
    int count = 0;
    count += _generalSymptoms.values.where((v) => v).length;
    count += _symptomVariations.values.where((v) => v).length;
    count += _lymphNodeSymptoms.values.where((v) => v).length;
    count += _spinalBreastSymptoms.values.where((v) => v).length;
    return count;
  }

  int get _totalQuestions {
    return _generalSymptoms.length +
        _symptomVariations.length +
        _lymphNodeSymptoms.length +
        _spinalBreastSymptoms.length;
  }

  @override
  void initState() {
    super.initState();
    // Reset all symptoms to false (blank) when entering the page
    _generalSymptoms.updateAll((key, value) => false);
    _symptomVariations.updateAll((key, value) => false);
    _lymphNodeSymptoms.updateAll((key, value) => false);
    _spinalBreastSymptoms.updateAll((key, value) => false);
  }

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
                // Header with back button + title
                _buildHeader(context),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      children: [
                        // Info Banner
                        _buildInfoBanner(),
                        const SizedBox(height: 20),

                        // Section 1: General Symptoms
                        _buildGeneralSymptomsSection(),
                        const SizedBox(height: 16),

                        // Section 2: Symptom Variations
                        _buildSymptomVariationsSection(),
                        const SizedBox(height: 16),

                        // Section 3: Lymph Node TB
                        _buildLymphNodeSection(),
                        const SizedBox(height: 16),

                        // Section 4: Spinal & Breast TB
                        _buildSpinalBreastSection(),
                        const SizedBox(height: 24),

                        // Submit Button
                        _buildSubmitSection(),
                        const SizedBox(height: 16),
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

  // ─── HEADER ───────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Back Button
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
              child: const Icon(Icons.arrow_back, color: AppColors.foreground, size: 20),
            ),
          ),

          // Title + Badge (Centered)
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Full Health Assessment',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.foreground,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '$_answeredCount/$_totalQuestions ANSWERED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Spacer to balance back button
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ─── INFO BANNER ──────────────────────────────────────────
  Widget _buildInfoBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
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
                child: const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Please answer each symptom based on your current condition for the most accurate result.',
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
        ),
      ),
    );
  }

  // ─── SECTION WRAPPER ──────────────────────────────────────
  Widget _buildSectionCard({
    required int sectionIndex,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget content,
  }) {
    bool isExpanded = _sectionExpanded[sectionIndex] ?? true;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
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
            children: [
              // Section Header
              GestureDetector(
                onTap: () {
                  setState(() {
                    _sectionExpanded[sectionIndex] = !isExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                  ),
                  child: Row(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.foreground,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content (animated)
              AnimatedCrossFade(
                firstChild: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: content,
                ),
                secondChild: const SizedBox.shrink(),
                crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SECTION 1: GENERAL SYMPTOMS ─────────────────────────
  Widget _buildGeneralSymptomsSection() {
    final symptoms = [
      {'key': 'persistent_cough', 'icon': Icons.show_chart_rounded, 'label': 'Persistent cough with phlegm (> 3 weeks)'},
      {'key': 'coughing_blood', 'icon': Icons.water_drop_outlined, 'label': 'Coughing up blood'},
      {'key': 'prolonged_fever', 'icon': Icons.thermostat_outlined, 'label': 'Prolonged fever'},
      {'key': 'weight_loss', 'icon': Icons.monitor_weight_outlined, 'label': 'Weight loss over recent months'},
    ];

    return _buildSectionCard(
      sectionIndex: 0,
      icon: Icons.show_chart_rounded,
      title: 'General Symptoms',
      subtitle: 'Pulmonary TB signs',
      content: Column(
        children: symptoms.map((s) {
          final key = s['key'] as String;
          final icon = s['icon'] as IconData;
          final label = s['label'] as String;
          final isSelected = _generalSymptoms[key] ?? false;

          return _buildToggleItem(key, icon, label, isSelected);
        }).toList(),
      ),
    );
  }

  Widget _buildToggleItem(String key, IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _generalSymptoms[key] = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.transparent,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.muted.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.mutedForeground,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.foreground,
                  height: 1.4,
                ),
              ),
            ),
            Switch(
              value: isSelected,
              onChanged: (val) {
                setState(() {
                  _generalSymptoms[key] = val;
                });
              },
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withOpacity(0.3),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }

  // ─── SECTION 2: SYMPTOM VARIATIONS ────────────────────────
  Widget _buildSymptomVariationsSection() {
    final variations = [
      {'key': 'mild_cough', 'icon': Icons.show_chart_rounded, 'label': 'Mild Cough'},
      {'key': 'severe_cough', 'icon': Icons.show_chart_rounded, 'label': 'Severe Cough'},
      {'key': 'low_fever', 'icon': Icons.thermostat_outlined, 'label': 'Low Fever'},
      {'key': 'high_fever', 'icon': Icons.thermostat_outlined, 'label': 'High Fever'},
      {'key': 'night_sweats', 'icon': Icons.nightlight_outlined, 'label': 'Night Sweats'},
      {'key': 'fatigue', 'icon': Icons.battery_alert_outlined, 'label': 'Fatigue'},
      {'key': 'loss_appetite', 'icon': Icons.no_food_outlined, 'label': 'Loss of Appetite'},
    ];

    return _buildSectionCard(
      sectionIndex: 1,
      icon: Icons.list_alt_rounded,
      title: 'Symptom Variations',
      subtitle: 'Select all that apply',
      content: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: variations.map((v) {
            final key = v['key'] as String;
            final icon = v['icon'] as IconData;
            final label = v['label'] as String;
            final isSelected = _symptomVariations[key] ?? false;

            return _buildChip(key, icon, label, isSelected);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildChip(String key, IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _symptomVariations[key] = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.mutedForeground,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SECTION 3: LYMPH NODE TB ─────────────────────────────
  Widget _buildLymphNodeSection() {
    final items = [
      {'key': 'swelling_lumps', 'label': 'Swelling or lumps in neck, groin, or armpit'},
      {'key': 'inflammation', 'label': 'Inflammation around lymph nodes'},
      {'key': 'movable_lumps', 'label': 'Movable or soft-textured lumps'},
      {'key': 'enlarging_lumps', 'label': 'Enlarging lumps that worsen over time'},
      {'key': 'lump_rupture', 'label': 'Lump rupture with pus discharge'},
    ];

    return _buildSectionCard(
      sectionIndex: 2,
      icon: Icons.commit_rounded,
      title: 'Lymph Node TB',
      subtitle: 'Swelling and related signs',
      content: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final key = item['key'] as String;
          final label = item['label'] as String;
          final isChecked = _lymphNodeSymptoms[key] ?? false;
          final isLast = index == items.length - 1;

          return _buildCheckboxItem(key, label, isChecked, showDivider: !isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildCheckboxItem(String key, String label, bool isChecked, {bool showDivider = true}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _lymphNodeSymptoms[key] = !isChecked;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(bottom: BorderSide(color: AppColors.border.withOpacity(0.5)))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox visual
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: isChecked ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isChecked ? AppColors.primary : AppColors.mutedForeground.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: isChecked ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: isChecked ? AppColors.primary : AppColors.foreground,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SECTION 4: SPINAL & BREAST TB ───────────────────────
  Widget _buildSpinalBreastSection() {
    final items = [
      {'key': 'back_pain', 'icon': Icons.accessibility_new_rounded, 'label': 'Back Pain'},
      {'key': 'stiffness', 'icon': Icons.person_remove_outlined, 'label': 'Stiffness'},
      {'key': 'breast_lump', 'icon': Icons.radio_button_unchecked, 'label': 'Breast Lump'},
      {'key': 'breast_inflammation', 'icon': Icons.local_fire_department_outlined, 'label': 'Breast Inflammation'},
    ];

    return _buildSectionCard(
      sectionIndex: 3,
      icon: Icons.accessibility_new_rounded,
      title: 'Spinal & Breast TB',
      subtitle: 'Bone, back, and lump issues',
      content: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: items.map((item) {
            final key = item['key'] as String;
            final icon = item['icon'] as IconData;
            final label = item['label'] as String;
            final isSelected = _spinalBreastSymptoms[key] ?? false;

            return _buildGridCard(key, icon, label, isSelected);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGridCard(String key, IconData icon, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _spinalBreastSymptoms[key] = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.primary.withOpacity(0.3) : Colors.white,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.muted.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? AppColors.primary : AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.mutedForeground,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SUBMIT BUTTON ────────────────────────────────────────
  Widget _buildSubmitSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.result);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: AppColors.primary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Submit Assessment',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── BACKGROUND AURAS ─────────────────────────────────────
  Widget _buildScatteredAuras(double sw, double sh) {
    return Stack(
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
        Positioned(
          bottom: sh * 0.2,
          right: sw * 0.1,
          child: _buildAura(125, AppColors.muted.withOpacity(0.15)),
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
