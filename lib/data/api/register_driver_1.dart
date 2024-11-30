import 'package:freight_hub/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.StreamedResponse> registerDriver1({
  required int driverId,
  required Map<String, dynamic> documentData

}) async {
  // Headers for the request
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  // Construct the request
  var request = http.Request('POST', Uri.parse('$tCoreBaseUrl/driver/register/1'))
    ..body = json.encode({
      "id": driverId,
      "profilePic": documentData['profile_photo'],
      "liFrontPic": documentData['driving_licence_front'],
      "liRearPic": documentData['driving_licence_back'],
      "licenseNumber": documentData['licence_number'],
      "licenseExpiry": documentData['licence_expiry_date'],
      "hasExpire": documentData['has_expiry_date'],
      "nicFrontPic": documentData['nic_front'],
      "nicRearPic": documentData['nic_back'],
      "billingProof": documentData['billing_proof'],
    })
    ..headers.addAll(headers);

  // Send the request and return the response
  return await request.send();
}