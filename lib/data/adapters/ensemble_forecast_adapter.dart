import '../../models/forecast_model.dart';

class EnsembleForecastAdapter {
  ForecastModel getCurrentForecast() {
    return ForecastModel(
      timestamp: DateTime.now(),
      solarForecast: 50.0,
      windForecast: 20.0,
      demandForecast: 40.0,
      priceForecast: 0.20,
      confidence: 0.85,
      uncertaintyRanges: {'solarMax': 60.0, 'solarMin': 40.0},
      ensembleMembers: [45.0, 55.0, 48.0],
    );
  }

  double getForecastAccuracy() {
    return 0.94;
  }

  Map<String, dynamic> getForecastAlerts() {
    return {'alerts': []};
  }

  Map<String, dynamic> getEnsembleStatistics() {
    return {'mean': 50.0, 'std': 5.0};
  }

  Map<String, dynamic> getModelPerformance() {
    return {'accuracy': 0.94, 'mae': 2.5};
  }

  void updateForecast() {
    // Update forecast logic
  }
}
