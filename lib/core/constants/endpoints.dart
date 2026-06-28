/// API endpoint paths used across the app.
/// Base URLs are NOT stored here — they come from flavor entry points
/// and are injected at runtime.
final class Endpoints {
  const Endpoints._();

  // ── Supabase Edge Functions ────────────────────────────────────────────────
  static const String aiProxy = '/functions/v1/ai-proxy';
  static const String weeklyReport = '/functions/v1/weekly-report';

  // ── Supabase RPC ───────────────────────────────────────────────────────────
  static const String version = 'version';
}
