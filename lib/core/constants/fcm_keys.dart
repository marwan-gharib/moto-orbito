/// FCM notification type strings and payload field names.
final class FcmKeys {
  const FcmKeys._();

  // ── Notification Types ─────────────────────────────────────────────────────
  static const String rideStarted = 'ride_started';
  static const String rideEnded = 'ride_ended';
  static const String speedAlert = 'speed_alert';
  static const String geofenceAlert = 'geofence_alert';
  static const String maintenanceDue = 'maintenance_due';
  static const String insuranceExpiry = 'insurance_expiry';
  static const String registrationExpiry = 'registration_expiry';
  static const String groupMemberJoined = 'group_member_joined';
  static const String rideInvitation = 'ride_invitation';
  static const String weeklyReportReady = 'weekly_report_ready';

  // ── Payload Fields ─────────────────────────────────────────────────────────
  static const String type = 'type';
  static const String targetId = 'target_id';

  // ── Local Notification Channel ─────────────────────────────────────────────
  static const String channelId = 'moto_orbito_channel';
  static const String channelName = 'Moto Orbito';
}
