import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../i18n/strings.g.dart';
import '../../router/routes.dart';
import '../../utils/app_logger.dart';

abstract interface class FcmService {
  Future<void> initialize();

  Future<String?> getPendingToken();

  Future<void> clearPendingToken();
}

final class FcmServiceImpl implements FcmService {
  FcmServiceImpl(
    this._messaging,
    this._localNotifications,
    this._storage,
    this._onNavigate,
  );

  static const String _pendingTokenKey = 'fcm_token_pending';

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;
  final FlutterSecureStorage _storage;
  final void Function(String location) _onNavigate;

  @override
  Future<void> initialize() async {
    await _messaging.requestPermission();
    await _initializeLocalNotifications();

    final token = await _messaging.getToken();
    if (token != null) {
      await _storage.write(key: _pendingTokenKey, value: token);
    }

    _messaging.onTokenRefresh.listen((token) {
      _storage.write(key: _pendingTokenKey, value: token);
    });

    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  @override
  Future<String?> getPendingToken() => _storage.read(key: _pendingTokenKey);

  @override
  Future<void> clearPendingToken() => _storage.delete(key: _pendingTokenKey);

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
      'moto_orbito_default',
      t.common.appName,
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
      type: map['type'] as String?,
      targetId:
          (map['target_id'] ??
                  map['ride_id'] ??
                  map['group_id'] ??
                  map['motorcycle_id'])
              as String?,
    );
  }

  final String? type;
  final String? targetId;

  String? toLocation() {
    return switch (type) {
      'ride_started' ||
      'speed_alert' ||
      'geofence_alert' when targetId != null => '/live-map/$targetId',
      'maintenance_due' when targetId != null => '/maintenance/$targetId',
      'insurance_expiry' ||
      'registration_expiry' when targetId != null => '/motorcycles/$targetId',
      'group_member_joined' when targetId != null =>
        '/groups/$targetId/members',
      'weekly_report_ready' => AppRoute.aiWeekly,
      _ => null,
    };
  }
}
