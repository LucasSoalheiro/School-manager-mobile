import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  factory StatusBadge.fromStatus(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return const StatusBadge(
          text: 'Entregue',
          color: AppColors.info,
          icon: Icons.upload_file_outlined,
        );
      case 'graded':
        return const StatusBadge(
          text: 'Avaliado',
          color: AppColors.success,
          icon: Icons.check_circle_outline,
        );
      case 'active':
        return const StatusBadge(
          text: 'Ativo',
          color: AppColors.success,
          icon: Icons.check_circle_outline,
        );
      case 'closed':
      case 'inactive':
        return const StatusBadge(
          text: 'Encerrada',
          color: AppColors.textSecondaryLight,
          icon: Icons.lock_outline,
        );
      case 'pending':
      default:
        return const StatusBadge(
          text: 'Pendente',
          color: AppColors.warning,
          icon: Icons.access_time_outlined,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
