/// All application links: deep links, API endpoint paths, and OAuth URIs.
/// Base URLs for API calls are NOT stored here — they come from flavor entry
/// points and are injected at runtime.
final class AppLinks {
  const AppLinks._();

  // ── Deep Link Scheme & Paths ──────────────────────────────────────────────
  static const String scheme = 'motoorbito';
  static const String joinGroup = '/join/';

  static String joinGroupLink(String inviteCode) =>
      '$scheme:/$joinGroup$inviteCode';

  // ── OAuth ─────────────────────────────────────────────────────────────────
  static const String oauthRedirectUri = 'io.moto.orbito://callback';

  // ── Supabase Edge Functions ───────────────────────────────────────────────
  static const String aiProxy = '/functions/v1/ai-proxy';
  static const String weeklyReport = '/functions/v1/weekly-report';
  static const String deleteAccount = '/functions/v1/delete-account';

  // ── Supabase RPC ──────────────────────────────────────────────────────────
  static const String version = 'version';
}
