/// AI prompt key constants sent to the Supabase Edge Function proxy.
/// The actual prompt templates live server-side — this is the key contract.
final class AiPrompts {
  const AiPrompts._();

  static const String rideReport = 'ride_report';
  static const String maintenancePrediction = 'maintenance_prediction';
  static const String weeklyReport = 'weekly_report';
}
