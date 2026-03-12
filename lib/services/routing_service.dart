import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

enum TravelMode { walking, driving }

class RouteStep {
  final String instruction;
  final double distance; // in meters
  final double duration; // in seconds
  final String maneuverType;

  RouteStep({
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.maneuverType,
  });

  String get distanceText {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    }
  }

  String get durationText {
    if (duration < 60) {
      return '${duration.toStringAsFixed(0)} sec';
    } else {
      return '${(duration / 60).toStringAsFixed(0)} min';
    }
  }
}

class RouteResult {
  final List<LatLng> polylinePoints;
  final List<RouteStep> steps;
  final double totalDistance; // in meters
  final double totalDuration; // in seconds
  final TravelMode mode;

  RouteResult({
    required this.polylinePoints,
    required this.steps,
    required this.totalDistance,
    required this.totalDuration,
    required this.mode,
  });

  String get totalDistanceText {
    if (totalDistance < 1000) {
      return '${totalDistance.toStringAsFixed(0)} m';
    } else {
      return '${(totalDistance / 1000).toStringAsFixed(1)} km';
    }
  }

  String get totalDurationText {
    if (totalDuration < 60) {
      return '${totalDuration.toStringAsFixed(0)} sec';
    } else if (totalDuration < 3600) {
      return '${(totalDuration / 60).toStringAsFixed(0)} min';
    } else {
      final hours = (totalDuration / 3600).floor();
      final minutes = ((totalDuration % 3600) / 60).floor();
      return '${hours}h ${minutes}min';
    }
  }
}

class RoutingService {
  static const String _baseUrl = 'https://router.project-osrm.org/route/v1';

  /// Fetch route from OSRM for walking or driving
  static Future<RouteResult?> getRoute({
    required LatLng origin,
    required LatLng destination,
    required TravelMode mode,
  }) async {
    final profile = mode == TravelMode.walking ? 'foot' : 'driving';

    final url =
        '$_baseUrl/$profile/${origin.longitude},${origin.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?steps=true&geometries=geojson&overview=full&annotations=false';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] != 'Ok' || data['routes'].isEmpty) {
          return null;
        }

        final route = data['routes'][0];
        final leg = route['legs'][0];

        // Parse polyline points from GeoJSON
        final coordinates =
        route['geometry']['coordinates'] as List<dynamic>;
        final polylinePoints = coordinates
            .map((coord) => LatLng(
          (coord[1] as num).toDouble(),
          (coord[0] as num).toDouble(),
        ))
            .toList();

        // Parse steps/instructions
        final stepsData = leg['steps'] as List<dynamic>;
        final steps = stepsData.map((step) {
          final maneuver = step['maneuver'];
          final maneuverType = maneuver['type'] ?? 'turn';
          final modifier = maneuver['modifier'] ?? '';

          String instruction = _buildInstruction(
            maneuverType,
            modifier,
            step['name'] ?? '',
          );

          return RouteStep(
            instruction: instruction,
            distance: (step['distance'] as num).toDouble(),
            duration: (step['duration'] as num).toDouble(),
            maneuverType: maneuverType,
          );
        }).toList();

        return RouteResult(
          polylinePoints: polylinePoints,
          steps: steps,
          totalDistance: (leg['distance'] as num).toDouble(),
          totalDuration: (leg['duration'] as num).toDouble(),
          mode: mode,
        );
      }
    } catch (e) {
      // Network error or timeout
      return null;
    }
    return null;
  }

  static String _buildInstruction(
      String type, String modifier, String streetName) {
    final street = streetName.isNotEmpty ? ' onto $streetName' : '';

    switch (type) {
      case 'depart':
        return 'Start heading${street.isNotEmpty ? street : ' forward'}';
      case 'arrive':
        return 'You have arrived at your destination';
      case 'turn':
        switch (modifier) {
          case 'left':
            return 'Turn left$street';
          case 'right':
            return 'Turn right$street';
          case 'slight left':
            return 'Turn slightly left$street';
          case 'slight right':
            return 'Turn slightly right$street';
          case 'sharp left':
            return 'Turn sharply left$street';
          case 'sharp right':
            return 'Turn sharply right$street';
          case 'uturn':
            return 'Make a U-turn$street';
          default:
            return 'Continue$street';
        }
      case 'continue':
        return 'Continue$street';
      case 'merge':
        return 'Merge$street';
      case 'roundabout':
        return 'Enter the roundabout$street';
      case 'exit roundabout':
        return 'Exit the roundabout$street';
      default:
        return 'Continue$street';
    }
  }

  /// Get icon for maneuver type
  static String getManeuverIcon(String maneuverType, String? modifier) {
    switch (maneuverType) {
      case 'depart':
        return '🚀';
      case 'arrive':
        return '🏁';
      case 'turn':
        switch (modifier) {
          case 'left':
          case 'slight left':
          case 'sharp left':
            return '⬅️';
          case 'right':
          case 'slight right':
          case 'sharp right':
            return '➡️';
          case 'uturn':
            return '↩️';
          default:
            return '⬆️';
        }
      case 'roundabout':
        return '🔄';
      case 'continue':
        return '⬆️';
      default:
        return '⬆️';
    }
  }
}