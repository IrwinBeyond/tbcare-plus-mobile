import 'package:flutter/material.dart';
import '../../../core/services/assessment_api_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/network_exception.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/home_header.dart';
import '../../../core/widgets/guest_bottom_nav.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../../routes/app_routes.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _isGuest = true;
  String? _userName;
  String? _profilePicture;
  List<Map<String, dynamic>> _historyItems = [];
  bool _loading = true;
  NetworkException? _historyError;

  bool _argumentsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argumentsLoaded) {
      _argumentsLoaded = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map) {
        if (args.containsKey('isGuest')) {
          _isGuest = args['isGuest'] as bool;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAuthAndHistory();
  }

  Future<void> _loadAuthAndHistory() async {
    final loggedIn = await StorageService.isLoggedIn();
    if (!mounted) return;
    if (!loggedIn) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.cover,
        (route) => false,
      );
      return;
    }
    final user = await StorageService.getUser();
    if (!mounted) return;
    setState(() {
      _isGuest = false;
      _userName = user?.fullName;
      _profilePicture = user?.profilePicture;
    });

    await _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _historyError = null;
    });
    try {
      final history = await AssessmentApiService.fetchHistorySessions();
      if (!mounted) return;
      setState(() {
        _historyItems = history;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _historyError = NetworkException.from(e);
        _loading = false;
      });
    }
  }

  String _translateAssessmentType(String? dbValue) {
    if (dbValue == null) return 'Pemeriksaan';
    switch (dbValue.toLowerCase()) {
      case 'quick assessment':
      case 'quick check':
        return 'Cek Cepat';
      case 'full assessment':
      case 'pemeriksaan lengkap':
        return 'Pemeriksaan Lengkap';
      default:
        return dbValue; // Keep DB value as-is if unknown
    }
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
                HomeHeader(
                  isGuest: _isGuest,
                  userName: _userName ?? StorageService.cachedUser?.fullName,
                  profilePicture:
                      _profilePicture ??
                      StorageService.cachedUser?.profilePicture,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchHistory,
                    color: AppColors.primary,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Riwayat Pemeriksaan',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: AppColors.foreground,
                              letterSpacing: -1.0,
                            ),
                          ),
                          const Text(
                            'Hasil skrining terbaru Anda',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Content
                          _loading
                              ? const Padding(
                                  padding: EdgeInsets.only(top: 60),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : _historyError != null
                              ? ErrorState(
                                  message: _historyError!.userMessage,
                                  type: _historyError!.type,
                                  onRetry: _fetchHistory,
                                )
                              : _historyItems.isEmpty
                              ? _buildEmptyState()
                              : _buildTimelineList(),
                        ],
                      ),
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
              currentIndex: 1,
              onTap: (i) {
                final routes = [
                  AppRoutes.home,
                  AppRoutes.history,
                  AppRoutes.profile,
                ];
                if (i < routes.length) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    routes[i],
                    (route) => false,
                    arguments: {'isGuest': _isGuest},
                  );
                }
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(
              Icons.history_rounded,
              size: 80,
              color: AppColors.muted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Riwayat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.mutedForeground,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hasil pemeriksaan Anda akan muncul di sini.',
              style: TextStyle(color: AppColors.mutedForeground),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _historyItems.length,
      itemBuilder: (context, index) {
        final raw = _historyItems[index];

        DateTime createdAt;
        try {
          createdAt = DateTime.parse(raw['createdAt']);
        } catch (_) {
          createdAt = DateTime.now();
        }

        // Indonesian date format: "27 Mei 2026"
        final months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'Mei',
          'Jun',
          'Jul',
          'Agu',
          'Sep',
          'Okt',
          'Nov',
          'Des',
        ];
        final dateStr =
            '${createdAt.day} ${months[createdAt.month - 1]} ${createdAt.year}';

        final riskLevelCode = (raw['riskLevelCode'] ?? 'LOW')
            .toString()
            .toUpperCase();
        Color color = AppColors.primary;
        IconData icon = Icons.check_circle_outline_rounded;
        String riskTitle = (raw['riskLevelTitle'] ?? 'Low Risk').toString();

        if (riskLevelCode.contains('HIGH')) {
          color = const Color(0xFFEF4444);
          icon = Icons.error_outline_rounded;
        } else if (riskLevelCode.contains('MEDIUM') ||
            riskLevelCode.contains('MODERATE')) {
          color = const Color(0xFFF59E0B);
          icon = Icons.warning_amber_rounded;
        } else {
          color = const Color(0xFF10B981);
          icon = Icons.check_circle_outline_rounded;
        }

        final assessmentType = _translateAssessmentType(
          raw['assessmentTypeName'] as String?,
        );
        final tbType = (raw['primaryTbTypeName'] ?? '').toString();
        final percentage = '${(raw['totalScore'] as num).round()}%';

        final item = {
          'sessionKey': raw['sessionKey'],
          'date': dateStr,
          'riskLevel': riskTitle,
          'riskLevelCode': riskLevelCode,
          'percentage': percentage,
          'tbType': tbType,
          'type': assessmentType,
          'color': color,
          'icon': icon,
        };

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline vertical line and dot
              Column(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: item['color'] as Color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: (item['color'] as Color).withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 2,
                      color: (item['color'] as Color).withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Card Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.historyDetail,
                        arguments: item,
                      );
                    },
                    child: _buildHistoryCard(item),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> item) {
    final color = item['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: date + type badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: AppColors.mutedForeground.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item['date'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  item['type'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Risk level + score
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['riskLevel'] as String,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: color,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          item['percentage'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: color.withValues(alpha: 0.8),
                          ),
                        ),
                        if ((item['tbType'] as String).isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Text(
                            '• ${item['tbType']}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: color.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'] as IconData, color: color, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
