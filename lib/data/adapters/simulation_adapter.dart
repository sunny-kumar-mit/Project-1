import 'dart:async';
import 'dart:math';
import '../../models/metric_point.dart';
import '../../models/ev_model.dart';
import 'market_adapter.dart';
import 'ev_adapter.dart';
import 'ensemble_forecast_adapter.dart';

class SimulationAdapter {
  final StreamController<MetricPoint> _streamController = 
      StreamController<MetricPoint>.broadcast();
  Timer? _timer;
  final Random _rnd = Random();
  DateTime _currentTime = DateTime.now();
  bool _isPaused = false;
  
  final EVFleet _evFleet = EVFleet();
  double _batteryLevel = 65.0;
  double _learningEfficiency = 0.85;

  final MarketAdapter _marketAdapter = MarketAdapter();
  final EVAdapter _evAdapter = EVAdapter();
  final EnsembleForecastAdapter _forecastAdapter = EnsembleForecastAdapter();

  Stream<MetricPoint> get dataStream => _streamController.stream;
  EVFleet get evFleet => _evFleet;
  MarketAdapter get marketAdapter => _marketAdapter;
  EVAdapter get evAdapter => _evAdapter;
  EnsembleForecastAdapter get forecastAdapter => _forecastAdapter;

  SimulationAdapter() {
    _initializeEVFleet();
  }

  void _initializeEVFleet() {
    _evFleet.addVehicle(EVModel(
      id: 'EV001',
      model: 'Tesla Model 3',
      batteryLevel: 75.0,
      capacity: 75.0,
      isCharging: false,
      isGridConnected: true,
      currentPower: 5.0,
    ));
    
    _evFleet.addVehicle(EVModel(
      id: 'EV002',
      model: 'Nissan Leaf',
      batteryLevel: 60.0,
      capacity: 40.0,
      isCharging: true,
      isGridConnected: true,
      currentPower: -3.0,
    ));
  }

  void start() {
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!_isPaused) {
        _currentTime = _currentTime.add(const Duration(seconds: 2));
        final metric = _generateData(_currentTime);
        _streamController.add(metric);
        _updateLearningEfficiency();
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void togglePause() {
    _isPaused = !_isPaused;
  }

  bool get isPaused => _isPaused;

  MetricPoint _generateData(DateTime timestamp) {
    final currentForecast = _forecastAdapter.getCurrentForecast();
    final hour = timestamp.hour + timestamp.minute / 60.0;

    // Use forecast data with some random noise
    final solarBase = currentForecast.solarForecast;
    final solarNoise = _rnd.nextDouble() * 4 - 2;
    final solar = (solarBase + solarNoise).clamp(0.0, 85.0);

    final windBase = currentForecast.windForecast;
    final windNoise = _rnd.nextDouble() * 6 - 3;
    final wind = (windBase + windNoise).clamp(0.0, 35.0);

    final totalGeneration = solar + wind;

    // Smart consumption with comfort optimization
    final consumption = _calculateConsumption(hour);

    // EV V2G integration
    final evPower = _calculateEVPower(hour);

    // Enhanced battery with adaptive control
    final netPower = totalGeneration - consumption + evPower;
    final batteryLevel = _calculateBatteryLevel(netPower);

    // Market participation
    final marketPrice = _calculateMarketPrice(hour);
    final gridImport = netPower < 0 ? netPower.abs() * marketPrice : 0.0;

    // Carbon reduction calculation
    final carbonReduction = totalGeneration * 0.4 + evPower.clamp(0.0, double.infinity) * 0.3;

    return MetricPoint(
      timestamp: timestamp,
      generation: totalGeneration,
      consumption: consumption,
      batteryLevel: batteryLevel,
      gridImport: gridImport,
      evPower: evPower,
      comfortScore: _calculateComfortScore(hour),
      marketPrice: marketPrice,
      carbonReduction: carbonReduction,
    );
  }

  double _calculateSolarGeneration(double hour) {
    if (hour < 6 || hour > 18) return 0.0;
    final normalizedHour = (hour - 6) / 12.0;
    final curve = sin(normalizedHour * pi);
    return (curve * 80 * _learningEfficiency).toDouble();
  }

  double _calculateConsumption(double hour) {
    final baseLoad = 25 + 12 * sin((hour - 14) * pi / 12);
    final peaks = _rnd.nextDouble() > 0.85 ? _rnd.nextDouble() * 25 : 0.0;
    return (baseLoad + peaks + _rnd.nextDouble() * 3).clamp(15, 90).toDouble();
  }

  double _calculateEVPower(double hour) {
    // Simulate V2G behavior - EVs discharge during peak hours
    final isPeakHour = (hour >= 17 && hour <= 21) || (hour >= 7 && hour <= 9);
    final basePower = isPeakHour ? 8.0 : -4.0;
    return basePower + _rnd.nextDouble() * 4 - 2;
  }

  double _calculateBatteryLevel(double netPower) {
    final efficiency = 0.95;
    if (netPower > 0) {
      _batteryLevel = (_batteryLevel + netPower * 0.08 * efficiency).clamp(0.0, 100.0);
    } else {
      _batteryLevel = (_batteryLevel + netPower * 0.05).clamp(0.0, 100.0);
    }
    return _batteryLevel;
  }

  double _calculateMarketPrice(double hour) {
    // Higher prices during peak hours
    final isPeak = (hour >= 17 && hour <= 21) || (hour >= 7 && hour <= 9);
    return isPeak ? 0.25 + _rnd.nextDouble() * 0.15 : 0.12 + _rnd.nextDouble() * 0.08;
  }

  double _calculateComfortScore(double hour) {
    // Higher comfort during occupied hours with efficient energy use
    final occupiedHours = (hour >= 8 && hour <= 18);
    final baseScore = occupiedHours ? 85.0 : 70.0;
    return (baseScore + _rnd.nextDouble() * 10).clamp(60.0, 95.0);
  }

  void _updateLearningEfficiency() {
    // Self-learning improvement over time
    _learningEfficiency = (_learningEfficiency + 0.001).clamp(0.8, 0.98);
  }

  // Emergency response simulation
  void activateEmergencyMode() {
    _batteryLevel = 90.0; // Prioritize battery for critical loads
  }

  // Predictive maintenance simulation
  Map<String, dynamic> getMaintenancePredictions() {
    return {
      'solarInverter': _rnd.nextDouble() > 0.7 ? 'Needs inspection' : 'Normal',
      'batteryHealth': '${(85 + _rnd.nextDouble() * 10).toStringAsFixed(1)}%',
      'windTurbine': _rnd.nextDouble() > 0.9 ? 'Maintenance due' : 'Optimal',
    };
  }

  void dispose() {
    _timer?.cancel();
    _streamController.close();
  }
}