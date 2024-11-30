import 'package:freight_hub/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.StreamedResponse> registerUser({
  required String username,
  required String password,
  String role = "driver"

}) async {
  // Headers for the request
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  // Construct the request
  var request = http.Request('POST', Uri.parse('$tBaseUrl/auth/register'))
    ..body = json.encode({
      "username": username,
      "password": password,
      "role": role,
    })
    ..headers.addAll(headers);

  // Send the request and return the response
  return await request.send();
}