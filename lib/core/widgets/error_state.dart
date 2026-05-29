import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/network_exception.dart';

/// Reusable inline error state with a retry button.
///
/// Renders an icon appropriate to the error type, a one-line message, and a
/// retry button. Designed to drop into the same slot a loading spinner or
/// empty state would occupy on data-fetch screens.
class ErrorState extends StatelessWidget {
  final String message;
  final NetworkErrorType type;
  final VoidCallback onRetry;
  final EdgeInsetsGeometry padding;

  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.type = NetworkErrorType.unknown,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
  });

  IconData get _icon {
    switch (type) {
      case NetworkErrorType.offline:
        return Icons.wifi_off_rounded;
      case NetworkErrorType.timeout:
        return Icons.hourglass_empty_rounded;
      case NetworkErrorType.unauthorized:
        return Icons.lock_outline_rounded;
      case NetworkErrorType.server:
        return Icons.cloud_off_rounded;
      default:
        return Icons.error_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 56, color: AppColors.mutedForeground.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedForeground,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Coba Lagi'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.4)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
