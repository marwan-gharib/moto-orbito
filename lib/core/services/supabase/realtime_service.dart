import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/supabase_keys.dart';
import '../../utils/app_logger.dart';
import 'supabase_service.dart';

final class RealtimeService {
  RealtimeService(this._supabaseService);

  final SupabaseService _supabaseService;
  final Map<String, RealtimeChannel> _channels = {};

  void subscribeToRide({
    required String rideId,
    required void Function(Map<String, dynamic> payload) onEvent,
  }) {
    final channelName = _channelName(rideId);
    final channel = _supabaseService.client.channel(channelName)
      ..onBroadcast(
        event: SupabaseKeys.realtimeLocationEvent,
        callback: (payload) => onEvent(Map<String, dynamic>.from(payload)),
      )
      ..subscribe((status, error) {
        if (error != null) {
          AppLogger.warning('Realtime subscription failed');
        }
      });
    _channels[rideId] = channel;
  }

  Future<void> broadcastLocation({
    required String rideId,
    required String riderId,
    required double lat,
    required double lng,
    required double speedKmh,
    required DateTime timestamp,
  }) async {
    final channel =
        _channels[rideId] ??
        _supabaseService.client.channel(_channelName(rideId));
    _channels[rideId] = channel;
    await channel.sendBroadcastMessage(
      event: SupabaseKeys.realtimeLocationEvent,
      payload: {
        SupabaseKeys.riderId: riderId,
        SupabaseKeys.lat: lat,
        SupabaseKeys.lng: lng,
        SupabaseKeys.speedKmh: speedKmh,
        SupabaseKeys.timestamp: timestamp.toIso8601String(),
      },
    );
  }

  Future<void> unsubscribeFromRide(String rideId) async {
    final channel = _channels.remove(rideId);
    if (channel == null) return;
    await _supabaseService.client.removeChannel(channel);
  }

  String _channelName(String rideId) => '${SupabaseKeys.rideId}:$rideId';
}

