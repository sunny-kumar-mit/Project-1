import 'dart:math';

class ForecastModel {
  final DateTime timestamp;
  final double solarForecast;
  final double windForecast;
  final double demandForecast;
  final double priceForecast;
  final double confidence;
  final Map<String, double> uncertaintyRanges;
  final List<double> ensembleMembers;

  ForecastModel({
    required this.timestamp,
    required this.solarForecast,
    required this.windForecast,
    required this.demandForecast,
    required this.priceForecast,
    required this.confidence,
    required this.uncertaintyRanges,
    required this.ensembleMembers,
  });

  double get totalGenerationForecast => solarForecast + windForecast;

  double get forecastUncertainty => uncertaintyRanges['solarMax']! - uncertaintyRanges['solarMin']!;
}

class EnsembleMember {
  final String modelName;
  final double solarPrediction;
  final double windPrediction;
  final double demandPrediction;
  double weight;
  final double accuracy;

  EnsembleMember({
    required this.modelName,
    required this.solarPrediction,
    required this.windPrediction,
    required this.demandPrediction,
    required this.weight,
    required this.accuracy,
  });
}

class WeatherData {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final double cloudCover;
  final double precipitation;
  final DateTime timestamp;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.cloudCover,
    required this.precipitation,
    required this.timestamp,
  });
}
