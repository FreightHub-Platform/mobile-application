import 'package:freight_hub/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.StreamedResponse> getWallet({
  required int driverId

}) async {

  // Headers for the request
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  // Construct the request
  var request = http.Request('POST', Uri.parse('$tCoreBaseUrl/transactions/wallet'))
    ..body = json.encode({
      "id": driverId,
    })
    ..headers.addAll(headers);

  // Send the request and return the response
  return await request.send();

}