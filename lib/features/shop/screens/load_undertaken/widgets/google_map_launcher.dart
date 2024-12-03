import 'package:url_launcher/url_launcher.dart';

class GoogleMapsLauncher {
  // Method to launch Google Maps with a specific location
  static Future<void> openMapForLocation({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final Uri mapUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude${label != null ? '&query_place_id=$label' : ''}'
    );

    try {
      if (await canLaunchUrl(mapUrl)) {
        await launchUrl(
          mapUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $mapUrl';
      }
    } catch (e) {
      throw('Error launching Google Maps: $e');
      // Optionally show an error dialog or snackbar
    }
  }

  // Method to open directions to a specific location
  static Future<void> openDirections({
    required double startLatitude,
    required double startLongitude,
    required double destLatitude,
    required double destLongitude,
  }) async {
    final Uri directionsUrl = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$startLatitude,$startLongitude&destination=$destLatitude,$destLongitude'
    );

    try {
      if (await canLaunchUrl(directionsUrl)) {
        await launchUrl(
          directionsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $directionsUrl';
      }
    } catch (e) {
      throw('Error launching Google Maps directions: $e');
      // Optionally show an error dialog or snackbar
    }
  }
}