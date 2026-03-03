import 'package:flutter/material.dart';

class NotificationService with ChangeNotifier {
  int _unreadCount = 0;
  bool _hasNewNotifications = false;

  int get unreadCount => _unreadCount;
  bool get hasNewNotifications => _hasNewNotifications;

  void updateUnreadCount(int count) {
    _unreadCount = count;
    _hasNewNotifications = count > 0;
    notifyListeners();
  }

  void incrementUnreadCount() {
    _unreadCount++;
    _hasNewNotifications = true;
    notifyListeners();
  }

  void clearUnreadCount() {
    _unreadCount = 0;
    _hasNewNotifications = false;
    notifyListeners();
  }

  // Show local notification (placeholder)
  void showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) {
    debugPrint('Notification: $title - $body');
  }

  // Schedule notification (placeholder)
  void scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) {
    debugPrint('Scheduled Notification: $title at $scheduledTime');
  }

  // Cancel all notifications
  void cancelAllNotifications() {
    _unreadCount = 0;
    _hasNewNotifications = false;
    notifyListeners();
  }
}