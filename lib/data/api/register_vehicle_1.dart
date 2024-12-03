import 'package:freight_hub/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.StreamedResponse> registerVehicle1({
  required int driverId,
  required int vehicleId,
  required Map<String, dynamic> vehicleDocumentData

}) async {
  // Headers for the request
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  // Construct the request
  var request = http.Request('POST', Uri.parse('$tCoreBaseUrl/vehicle/register/1'))
    ..body = json.encode({
      "id": vehicleId,
      "driverId": driverId,
      "revenueLicensePic": vehicleDocumentData['vehicle_revenue_licence'],
      "licenseExpiry": vehicleDocumentData['revenue_licence_expiry_date'],
      "insurancePic": vehicleDocumentData['vehicle_insurance'],
      "insuranceExpiry": vehicleDocumentData['insurance_expiry_date'],
      "registrationDoc": vehicleDocumentData['vehicle_registration_document']
    })
    ..headers.addAll(headers);

  // Send the request and return the response
  return await request.send();
}