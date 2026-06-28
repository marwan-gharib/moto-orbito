/// Deep link and invite link constants used across the app.
final class AppLinks {
  const AppLinks._();

  // ── Deep Link Scheme ───────────────────────────────────────────────────────
  static const String scheme = 'motoorbito';

  // ── Deep Link Paths ────────────────────────────────────────────────────────
  static const String joinGroup = '/join/';

  // ── Full Deep Link Template ────────────────────────────────────────────────
  /// Build a full join link: motoorbito://join/{inviteCode}
  static String joinGroupLink(String inviteCode) =>
      '$scheme:/$joinGroup$inviteCode';
}
