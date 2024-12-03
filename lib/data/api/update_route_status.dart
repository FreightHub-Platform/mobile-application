import 'package:freight_hub/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.StreamedResponse> confirmRoute({
  required int driverId,
  required int routeId,
  required String status

}) async {

  // Headers for the request
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  // Construct the request
  var request = http.Request('POST', Uri.parse('$tCoreBaseUrl/route/update-status'))
    ..body = json.encode({
      "route_id": routeId,
      "driver_id": driverId,
      "status": status
    })
    ..headers.addAll(headers);

  // Send the request and return the response
  return await request.send();

}

Future<http.StreamedResponse> updateTripStarted({
  required int driverId,
  required int routeId

}) async {

  // Headers for the request
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  // Construct the request
  var request = http.Request('POST', Uri.parse('$tCoreBaseUrl/route/update-status'))
    ..body = json.encode({
      "route_id": routeId,
      "driver_id": driverId,
      "status": "arriving"
    })
    ..headers.addAll(headers);

  // Send the request and return the response
  return await request.send();

}

Future<http.StreamedResponse> updateArrival({
  required int driverId,
  required int routeId

}) async {

  // Headers for the request
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  // Construct the request
  var request = http.Request('POST', Uri.parse('$tCoreBaseUrl/route/update-status'))
    ..body = json.encode({
      "route_id": routeId,
      "driver_id": driverId,
      "status": "loading"
    })
    ..headers.addAll(headers);

  // Send the request and return the response
  return await request.send();

}

Future<http.StreamedResponse> updateDeliveryStart({
  required int driverId,
  required int routeId,
  required int poId,
  required int? otp

}) async {

  // Headers for the request
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  // Construct the request
  var request = http.Request('POST', Uri.parse('$tCoreBaseUrl/route/update-status'))
    ..body = json.encode({
      "route_id": routeId,
      "driver_id": driverId,
      "po_id": poId,
      "otp": otp,
      "status": "ongoing"
    })
    ..headers.addAll(headers);

  // Send the request and return the response
  return await request.send();

}

Future<http.StreamedResponse> startUnloading({
  required int poId,
  required int routeId

}) async {

  // Headers for the request
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  // Construct the request
  var request = http.Request('POST', Uri.parse('$tCoreBaseUrl/purchase-order/unload'))
    ..body = json.encode({
      "route_id": routeId,
      "po_id": poId,
      "status": "unloading"
    })
    ..headers.addAll(headers);

  // Send the request and return the response
  return await request.send();

}

Future<http.StreamedResponse> finishUnloading({
  required int poId,
  required int routeId,
  required int? otp

}) async {

  // Headers for the request
  var headers = {
    'accept': '*/*',
    'Content-Type': 'application/json',
  };

  // Construct the request
  var request = http.Request('POST', Uri.parse('$tCoreBaseUrl/purchase-order/complete'))
    ..body = json.encode({
      "route_id": routeId,
      "po_id": poId,
      "otp": otp,
      "status": "completed"
    })
    ..headers.addAll(headers);

  // Send the request and return the response
  return await request.send();

}