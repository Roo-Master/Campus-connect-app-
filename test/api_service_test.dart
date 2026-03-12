import 'package:campus_connect/models/grade_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_connect/services/api_service.dart';

void main() {
  group('ApiService Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    test('getAvailableCourses returns mock data', () async {
      final courses = await apiService.getAvailableCourses('test123');
      expect(courses.isNotEmpty, true);
      expect(courses.length, 4);
    });

    test('getEnrolledCourses returns mock data', () async {
      final courses = await apiService.getEnrolledCourses('test123');
      expect(courses.isNotEmpty, true);
    });

    test('getUpcomingEvents returns mock data', () async {
      final events = await apiService.getUpcomingEvents();
      expect(events.isNotEmpty, true);
    });

    test('getGrades returns mock data', () async {
      final grades = await apiService.getGrades();
      expect(grades.isNotEmpty, true);
    });

    test('calculateCGPA returns correct value', () async {
      final grades = await apiService.getGrades();
      final cgpa = GradeModel.calculateCGPA(grades);
      expect(cgpa > 0, true);
      expect(cgpa <= 10, true);
    });
  });
}