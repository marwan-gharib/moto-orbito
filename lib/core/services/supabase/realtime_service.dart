import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/app_logger.dart';
import 'supabase_service.dart';

abstract interface class RealtimeService {
  void subscribeToRide({
    required String rideId,
    required void Function(Map<String, dynamic> payload) onEvent,
  });

  Future<void> broadcastLocation({
    required String rideId,
    required String riderId,
    required double lat,
    required double lng,
    required double speedKmh,
    required DateTime timestamp,
  });

  Future<void> unsubscribeFromRide(String rideId);
}

final class RealtimeServiceImpl implements RealtimeService {
  RealtimeServiceImpl(this._supabaseService);

  final SupabaseService _supabaseService;
  final Map<String, RealtimeChannel> _channels = {};

  @override
  void subscribeToRide({
    required String rideId,
    required void Function(Map<String, dynamic> payload) onEvent,
  }) {
    final channelName = _channelName(rideId);
    final channel = _supabaseService.client.channel(channelName)
      ..onBroadcast(
        event: 'location',
        callback: (payload) => onEvent(Map<String, dynamic>.from(payload)),
      )
      ..subscribe((status, error) {
        if (error != null) {
          AppLogger.warning('Realtime subscription failed');
        }
      });
    _channels[rideId] = channel;
  }

  @override
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
      event: 'location',
      payload: {
        'rider_id': riderId,
        'lat': lat,
        'lng': lng,
        'speed_kmh': speedKmh,
        'timestamp': timestamp.toIso8601String(),
      },
    );
  }

  @override
  Future<void> unsubscribeFromRide(String rideId) async {
    final channel = _channels.remove(rideId);
    if (channel == null) return;
    await _supabaseService.client.removeChannel(channel);
  }

  String _channelName(String rideId) => 'ride:$rideId';
}
