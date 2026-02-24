import 'package:flutter/material.dart';

class NotificationModel with ChangeNotifier {
  final String id;
  final String title;
  final String message;
  final String type;
  final String date;
  final String time;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    required this.time,
    required this.isRead,
    this.actionUrl,
    this.data,
  });

  Color get typeColor {
    switch (type) {
      case 'academic':
        return Colors.blue;
      case 'event':
        return Colors.purple;
      case 'deadline':
        return Colors.red;
      case 'announcement':
        return Colors.orange;
      case 'grade':
        return Colors.green;
      case 'emergency':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  IconData get typeIcon {
    switch (type) {
      case 'academic':
        return Icons.school;
      case 'event':
        return Icons.event;
      case 'deadline':
        return Icons.access_time;
      case 'announcement':
        return Icons.campaign;
      case 'grade':
        return Icons.grade;
      case 'emergency':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  // Mock Data
  static List<NotificationModel> getMockNotifications() {
    return [
      NotificationModel(
        id: 'n001',
        title: 'Assignment Due Tomorrow',
        message: 'Your Data Structures assignment is due tomorrow at 11:59 PM. Make sure to submit before the deadline.',
        type: 'deadline',
        date: 'Oct 12, 2024',
        time: '10:30 AM',
        isRead: false,
      ),
      NotificationModel(
        id: 'n002',
        title: 'Tech Fest Registration Open',
        message: 'Registration for Tech Fest 2024 is now open. Limited spots available!',
        type: 'event',
        date: 'Oct 11, 2024',
        time: '9:00 AM',
        isRead: false,
      ),
      NotificationModel(
        id: 'n003',
        title: 'Mid-Semester Schedule Released',
        message: 'The mid-semester examination schedule has been published. Check your dashboard for details.',
        type: 'academic',
        date: 'Oct 10, 2024',
        time: '3:00 PM',
        isRead: true,
      ),
      NotificationModel(
        id: 'n004',
        title: 'Library Maintenance',
        message: 'The main library will be closed for maintenance on Sunday from 6 AM to 12 PM.',
        type: 'announcement',
        date: 'Oct 09, 2024',
        time: '11:00 AM',
        isRead: true,
      ),
      NotificationModel(
        id: 'n005',
        title: 'Grades Posted: CS201',
        message: 'Your grades for Object Oriented Programming (CS201) have been posted.',
        type: 'grade',
        date: 'Oct 08, 2024',
        time: '2:00 PM',
        isRead: true,
      ),
    ];
  }

  // Unread count
  static int getUnreadCount(List<NotificationModel> notifications) {
    return notifications.where((n) => !n.isRead).length;
  }
}