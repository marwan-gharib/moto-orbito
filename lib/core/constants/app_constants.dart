/// General app-wide constants that don't belong to a specific subsystem.
final class AppConstants {
  const AppConstants._();

  // ── Storage ────────────────────────────────────────────────────────────────
  static const int maxUploadBytes = 5242880; // 5 MB
  static const int maxMotorcyclePhotos = 5;

  // ── Groups ─────────────────────────────────────────────────────────────────
  static const int inviteCodeLength = 6;

  // ── GPS Tracking ───────────────────────────────────────────────────────────
  static const int locationUpdateIntervalSeconds = 3;

  // ── Pagination ─────────────────────────────────────────────────────────────
  static const int paginationPageSize = 20;

  // ── Search ─────────────────────────────────────────────────────────────────
  static const int searchDebounceMsec = 400;

  // ── Reminders ─────────────────────────────────────────────────────────────
  static const List<int> expiryReminderDays = [30, 7, 1];

  // ── AI ─────────────────────────────────────────────────────────────────────
  static const int aiMaxRetries = 2;
  static const int aiTimeoutSeconds = 30;

  // ── Locale ─────────────────────────────────────────────────────────────────
  static const String defaultLocale = 'ar';

  // ── UI Labels ──────────────────────────────────────────────────────────────
  static const String otpCodeLabel = 'OTP Code';
}
