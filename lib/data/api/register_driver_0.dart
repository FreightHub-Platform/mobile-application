import 'package:freight_hub/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.StreamedResponse> registerDriver0({
  required int driverId,
  required String firstName,
  required String lastName,
  required String phone,
  required String nic,
  required String street,
  required String city,
  required String province,
  required String zipCode

}) async {
  // Headers for the request
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  // Construct the request
  var request = http.Request('POST', Uri.parse('$tCoreBaseUrl/driver/register/0'))
    ..body = json.encode({
      "id": driverId,
      "fname": firstName,
      "lname": lastName,
      "contactNumber": phone,
      "nic": nic,
      "addressLine1": street,
      "city": city,
      "province": province,
      "postalCode": zipCode
    })
    ..headers.addAll(headers);

  // Send the request and return the response
  return await request.send();
}