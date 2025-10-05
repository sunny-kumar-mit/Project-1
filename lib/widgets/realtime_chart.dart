import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RealtimeChart extends StatelessWidget {
  final List<FlSpot> generationSpots;
  final List<FlSpot> consumptionSpots;
  final List<FlSpot> evSpots;
  final bool isDarkMode;

  const RealtimeChart({
    super.key,
    required this.generationSpots,
    required this.consumptionSpots,
    required this.evSpots,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 20,
          verticalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${value.toInt()}s',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}kW',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
            width: 1,
          ),
        ),
        minX: 0,
        maxX: generationSpots.isNotEmpty ? generationSpots.last.x : 60,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: generationSpots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.1),
            ),
            gradient: LinearGradient(
              colors: [Colors.green, Colors.green.shade400],
            ),
          ),
          LineChartBarData(
            spots: consumptionSpots,
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.orange.withOpacity(0.1),
            ),
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.orange.shade400],
            ),
          ),
          LineChartBarData(
            spots: evSpots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withOpacity(0.1),
            ),
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blue.shade400],
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
    );
  }
}