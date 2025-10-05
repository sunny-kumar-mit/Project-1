import 'package:flutter/material.dart';
import '../data/adapters/ensemble_forecast_adapter.dart';

class ForecastPanel extends StatelessWidget {
  final EnsembleForecastAdapter forecastAdapter;

  const ForecastPanel({super.key, required this.forecastAdapter});

  @override
  Widget build(BuildContext context) {
    final forecast = forecastAdapter.getCurrentForecast();
    final accuracy = forecastAdapter.getForecastAccuracy();
    final alerts = forecastAdapter.getForecastAlerts();
    final stats = forecastAdapter.getEnsembleStatistics();
    final performance = forecastAdapter.getModelPerformance();

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.cloud, color: Colors.blue),
                SizedBox(width: 8),
                Text('Ensemble Forecasting', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Weather & Demand Prediction', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Accuracy', style: const TextStyle(fontSize: 12)),
                Text('${(accuracy * 100).toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Next Peak', style: const TextStyle(fontSize: 12)),
                Text('2.3 hours', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
