import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/fcm_keys.dart';
import '../../constants/supabase_keys.dart';
import '../../router/routes.dart';
import '../../utils/app_logger.dart';


final class FcmService {
  FcmService(
    this._messaging,
    this._localNotifications,
    this._storage,
    this._onNavigate,
  );

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final FlutterSecureStorage _storage;
  final void Function(String location) _onNavigate;

  Future<void> initialize() async {
    await _messaging.requestPermission();
    await _initializeLocalNotifications();

    final token = await _messaging.getToken();
    if (token != null) {
      await _storage.write(key: SupabaseKeys.pendingFcmToken, value: token);
    }

    _messaging.onTokenRefresh.listen((token) {
      _storage.write(key: SupabaseKeys.pendingFcmToken, value: token);
    });

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  Future<String?> getPendingToken() =>
      _storage.read(key: SupabaseKeys.pendingFcmToken);

  Future<void> clearPendingToken() =>
      _storage.delete(key: SupabaseKeys.pendingFcmToken);

  Future<void> _initializeLocalNotifications() {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: darwin);
    return _localNotifications.initialize(settings: settings);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final androidDetails = AndroidNotificationDetails(
      FcmKeys.channelId,
      FcmKeys.channelName,
      importance: Importance.high,
      priority: Priority.high,
    );
    final details = NotificationDetails(android: androidDetails);
    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
      payload: message.data.toString(),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    final payload = NotificationPayload.fromMap(message.data);
    final location = payload.toLocation();
    if (location == null) {
      AppLogger.warning('Unrecognized notification type');
      _onNavigate(AppRoute.home);
      return;
    }
    _onNavigate(location);
  }
}

final class NotificationPayload {
  const NotificationPayload({required this.type, required this.targetId});

  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    return NotificationPayload(
      type: map[FcmKeys.type] as String?,
      targetId:
          (map[FcmKeys.targetId] ??
                  map[SupabaseKeys.rideId] ??
                  map[SupabaseKeys.groupId] ??
                  map[SupabaseKeys.motorcycleId])
              as String?,
    );
  }

  final String? type;
  final String? targetId;

  String? toLocation() {
    return switch (type) {
      FcmKeys.rideStarted ||
      FcmKeys.speedAlert ||
      FcmKeys.geofenceAlert when targetId != null => '/live-map/$targetId',
      FcmKeys.maintenanceDue when targetId != null =>
        '/maintenance/$targetId',
      FcmKeys.insuranceExpiry ||
      FcmKeys.registrationExpiry when targetId != null =>
        '/motorcycles/$targetId',
      FcmKeys.groupMemberJoined when targetId != null =>
        '/groups/$targetId/members',
      FcmKeys.weeklyReportReady => AppRoute.aiWeekly,
      _ => null,
    };
  }
}

