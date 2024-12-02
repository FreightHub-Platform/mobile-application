class RouteModel {
  final int routeId;
  final String pickupPoint;
  final List<String> itemTypes;
  final String routeDistance;
  final String consignerName;
  final String dropOff;
  final String dropTime;
  final String estdProfit;
  final String routeStatus;
  final String dropPoint;

  RouteModel({
    required this.routeId,
    required this.pickupPoint,
    required this.itemTypes,
    required this.routeDistance,
    required this.consignerName,
    required this.dropOff,
    required this.dropTime,
    required this.estdProfit,
    required this.routeStatus,
    required this.dropPoint,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      routeId: json['routeId'] ?? 0,
      pickupPoint: json['pickupPoint'] ?? '',
      itemTypes: List<String>.from(json['itemTypes'] ?? []),
      routeDistance: json['routeDistance'] ?? '',
      consignerName: json['consignerName'] ?? '',
      dropOff: json['dropOff'] ?? '',
      dropTime: json['dropTime'] ?? '',
      estdProfit: json['estd_profit'] ?? '',
      routeStatus: json['routeStatus'] ?? '',
      dropPoint: json['dropPoint'] ?? '',
    );
  }
}