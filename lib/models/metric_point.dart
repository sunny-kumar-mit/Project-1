class MetricPoint {
  final DateTime timestamp;
  final double generation;
  final double consumption;
  final double batteryLevel;
  final double gridImport;
  final double evPower;
  final double comfortScore;
  final double marketPrice;
  final double carbonReduction;

  MetricPoint({
    required this.timestamp,
    required this.generation,
    required this.consumption,
    required this.batteryLevel,
    required this.gridImport,
    required this.evPower,
    required this.comfortScore,
    required this.marketPrice,
    required this.carbonReduction,
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'generation': generation,
      'consumption': consumption,
      'batteryLevel': batteryLevel,
      'gridImport': gridImport,
      'evPower': evPower,
      'comfortScore': comfortScore,
      'marketPrice': marketPrice,
      'carbonReduction': carbonReduction,
    };
  }

  factory MetricPoint.fromMap(Map<String, dynamic> map) {
    return MetricPoint(
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      generation: map['generation'],
      consumption: map['consumption'],
      batteryLevel: map['batteryLevel'],
      gridImport: map['gridImport'],
      evPower: map['evPower'],
      comfortScore: map['comfortScore'],
      marketPrice: map['marketPrice'],
      carbonReduction: map['carbonReduction'],
    );
  }
}