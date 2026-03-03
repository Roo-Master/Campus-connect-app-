import 'package:flutter/foundation.dart';

import '../models/notification_model2.dart';

class NotificationService2 extends ChangeNotifier {
  final List<NotificationModel2> _notifications = [];

  // Mock data for demonstration
  NotificationService2() {
    _loadMockNotifications();
  }

  List<NotificationModel2> get notifications => _notifications;

  List<NotificationModel2> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();

  int get unreadCount => unreadNotifications.length;

  void _loadMockNotifications() {
    _notifications.addAll([
      NotificationModel2(
        id: '1',
        title: 'New Assignment',
        message: 'Database Management assignment due next week',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.assignment,
      ),
      NotificationModel2(
        id: '2',
        title: 'Exam Schedule',
        message: 'Mid-term exam schedule has been published',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: NotificationType.academic,
      ),
      NotificationModel2(
        id: '3',
        title: 'Campus Event',
        message: 'Tech Fest 2024 registrations open',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.event,
      ),
      NotificationModel2(
        id: '4',
        title: 'Grades Released',
        message: 'Your Data Structures marks have been uploaded',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.grades,
      ),
    ]);
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = NotificationModel2(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        timestamp: _notifications[index].timestamp,
        isRead: true,
        type: _notifications[index].type,
      );
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = NotificationModel2(
        id: _notifications[i].id,
        title: _notifications[i].title,
        message: _notifications[i].message,
        timestamp: _notifications[i].timestamp,
        isRead: true,
        type: _notifications[i].type,
      );
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}