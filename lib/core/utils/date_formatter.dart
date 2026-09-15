import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateOnly = DateFormat('dd/MM/yyyy');

  static String formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '--/--/----';
    try {
      final parsed = DateTime.parse(isoDate).toLocal();
      return _dateOnly.format(parsed);
    } catch (_) {
      return isoDate;
    }
  }

  static String formatDateTime(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '--/--/---- --:--';
    try {
      final parsed = DateTime.parse(isoDate).toLocal();
      return '${_dateOnly.format(parsed)} às ${DateFormat('HH:mm').format(parsed)}';
    } catch (_) {
      return isoDate;
    }
  }

  static bool isPast(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return false;
    try {
      final parsed = DateTime.parse(isoDate).toLocal();
      return parsed.isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  static String getRelativeDeadline(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return 'Sem prazo';
    try {
      final parsed = DateTime.parse(isoDate).toLocal();
      final now = DateTime.now();
      final difference = parsed.difference(now);

      if (difference.isNegative) {
        final daysAgo = difference.inDays.abs();
        if (daysAgo == 0) return 'Expirou hoje';
        if (daysAgo == 1) return 'Expirou ontem';
        return 'Expirou há $daysAgo dias';
      }

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return 'Expira em ${difference.inMinutes} min';
        }
        return 'Expira hoje (${difference.inHours}h restantes)';
      } else if (difference.inDays == 1) {
        return 'Entrega amanhã';
      } else {
        return 'Entrega em ${difference.inDays} dias';
      }
    } catch (_) {
      return formatDate(isoDate);
    }
  }
}
