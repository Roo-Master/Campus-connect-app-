// TODO Implement this library.
class NotificationModel2 {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;

  NotificationModel2({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });
}

enum NotificationType {
  academic,
  event,
  announcement,
  assignment,
  grades,
  general,
}