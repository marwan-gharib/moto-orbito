/// Supabase table names and column identifiers.
/// Never store credentials here — those live in the flavor entry points.
final class SupabaseKeys {
  const SupabaseKeys._();

  // ── Tables ─────────────────────────────────────────────────────────────────
  static const String users = 'users';
  static const String motorcycles = 'motorcycles';
  static const String groups = 'groups';
  static const String groupMembers = 'group_members';
  static const String rides = 'rides';
  static const String rideParticipants = 'ride_participants';
  static const String rideLocations = 'ride_locations';
  static const String rideReports = 'ride_reports';
  static const String maintenanceLogs = 'maintenance_logs';
  static const String maintenanceReminders = 'maintenance_reminders';
  static const String fuelLogs = 'fuel_logs';
  static const String notifications = 'notifications';
  static const String geofences = 'geofences';

  // ── Storage Buckets ────────────────────────────────────────────────────────
  static const String motorcyclesBucket = 'motorcycles';
  static const String groupsBucket = 'groups';
  static const String profilesBucket = 'profiles';

  // ── Shared Column Names ────────────────────────────────────────────────────
  static const String id = 'id';
  static const String userId = 'user_id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';

  // ── users columns ──────────────────────────────────────────────────────────
  static const String fcmToken = 'fcm_token';
  static const String speedLimitKmh = 'speed_limit_kmh';
  static const String isPrimary = 'is_primary';

  // ── rides columns ──────────────────────────────────────────────────────────
  static const String rideId = 'ride_id';
  static const String riderId = 'rider_id';
  static const String lat = 'lat';
  static const String lng = 'lng';
  static const String speedKmh = 'speed_kmh';
  static const String timestamp = 'timestamp';

  // ── Realtime ──────────────────────────────────────────────────────────────────
  static const String realtimeLocationEvent = 'location';

  // ── groups columns ─────────────────────────────────────────────────────
  static const String groupId = 'group_id';
  static const String inviteCode = 'invite_code';

  // ── motorcycles columns ─────────────────────────────────────────────
  static const String motorcycleId = 'motorcycle_id';

  // ── Secure Storage keys ────────────────────────────────────────────────────
  static const String pendingFcmToken = 'pending_fcm_token';
  static const String jwtToken = 'jwt';
}
