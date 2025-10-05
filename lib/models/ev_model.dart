class EVModel {
  final String id;
  final String model;
  double batteryLevel;
  final double capacity;
  bool isCharging;
  bool isGridConnected;
  double currentPower;

  EVModel({
    required this.id,
    required this.model,
    required this.batteryLevel,
    required this.capacity,
    required this.isCharging,
    required this.isGridConnected,
    required this.currentPower,
  });
}

class EVFleet {
  List<EVModel> vehicles = [];
  double totalV2GPower = 0.0;
  
  void addVehicle(EVModel vehicle) {
    vehicles.add(vehicle);
  }
  
  double getAvailableV2GPower() {
    return vehicles
        .where((v) => v.isGridConnected && !v.isCharging && v.batteryLevel > 20)
        .map((v) => v.currentPower)
        .fold(0.0, (sum, power) => sum + power);
  }
}