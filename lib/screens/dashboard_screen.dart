import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';
import 'dart:math';

import '../data/adapters/simulation_adapter.dart';
import '../models/metric_point.dart';
import '../widgets/kpi_card.dart';
import '../widgets/realtime_chart.dart';
import '../widgets/ev_panel.dart';
import '../widgets/forecast_panel.dart';
import '../widgets/market_panel.dart';
import '../widgets/emergency_panel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  final SimulationAdapter _simulationAdapter = SimulationAdapter();
  final List<MetricPoint> _dataPoints = [];
  final int _maxDataPoints = 60;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Initialize with safe default values
  DateTime _currentTime = DateTime.now();
  late Timer _clockTimer;
  late Timer _featuresUpdateTimer;
  Map<String, dynamic> _maintenanceData = {};
  Map<String, dynamic> _forecastData = {};
  Map<String, dynamic> _marketData = {};
  Map<String, dynamic> _carbonData = {};
  bool _isNightMode = false;
  final ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFFf8f9fa),
    fontFamily: 'Segoe UI',
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.1),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: Colors.blue.shade800,
      ),
      iconTheme: IconThemeData(color: Colors.blue.shade700),
    ),
  );

  final ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: const Color(0xFF121212),
    fontFamily: 'Segoe UI',
    cardTheme: CardTheme(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black.withOpacity(0.3),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      elevation: 4,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: Colors.blue.shade200,
      ),
      iconTheme: IconThemeData(color: Colors.blue.shade300),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
  );

  @override
  void initState() {
    super.initState();

    // Initialize animation controller first
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Initialize data with safe defaults
    _initializeSafeData();

    // Start timers and streams
    _startClock();
    _startFeaturesUpdateTimer();
    _setupDataStream();
    _simulationAdapter.start();

    // Start animation after everything is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  void _startClock() {
    // Update time immediately
    _currentTime = DateTime.now();
    
    // Update every second
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  void _initializeSafeData() {
    // Initialize all data maps with safe default values
    _maintenanceData = {
      'solarInverter': 'Normal',
      'batteryHealth': '95.0%',
      'windTurbine': 'Optimal',
      'gridConnection': 'Stable',
      'nextInspection': '14 days',
      'systemUptime': '99.8%',
      'criticalAlerts': 0,
    };

    _forecastData = {
      'accuracy': '94.0%',
      'nextPeak': '2.3 hours',
      'solarOutput': '50.0 kW',
      'windOutput': '20.0 kW',
      'demandPeak': '70 kW',
      'confidence': '85%',
      'ensembleMembers': 3,
    };

    _marketData = {
      'currentPrice': '\$0.18/kWh',
      'todayProfit': '\$42.50',
      'carbonCredits': '12.5 tCO₂',
      'tradingVolume': '150 MWh',
      'priceTrend': 'Stable',
      'arbitrageOpp': '\$8.50',
      'revenueToday': '\$125',
    };

    _carbonData = {
      'co2Saved': '25.0 kg/h',
      'creditsEarned': '1.3',
      'totalReduction': '1250 kg',
      'equivalentTrees': '8 trees',
      'carbonIntensity': '120 g/kWh',
      'renewableMix': '65%',
      'savingsToday': '\$15.00',
    };
  }

  void _initializeFeaturesData() {
    _updateMaintenanceData();
    _updateForecastData();
    _updateMarketData();
    _updateCarbonData();
  }

  void _startFeaturesUpdateTimer() {
    _featuresUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _updateMaintenanceData();
          _updateForecastData();
          _updateMarketData();
          _updateCarbonData();
        });
      }
    });
  }

  void _updateMaintenanceData() {
    final random = Random();
    final maintenancePredictions = _simulationAdapter.getMaintenancePredictions();
    
    _maintenanceData = {
      'solarInverter': maintenancePredictions['solarInverter'] ?? 'Normal',
      'batteryHealth': maintenancePredictions['batteryHealth'] ?? '95.0%',
      'windTurbine': maintenancePredictions['windTurbine'] ?? 'Optimal',
      'gridConnection': random.nextDouble() > 0.95 ? 'Needs Check' : 'Stable',
      'nextInspection': '${7 + random.nextInt(14)} days',
      'systemUptime': '${99.5 + random.nextDouble() * 0.4}%',
      'criticalAlerts': random.nextInt(3),
    };
  }

  void _updateForecastData() {
    final random = Random();
    final forecast = _simulationAdapter.forecastAdapter.getCurrentForecast();
    final accuracy = _simulationAdapter.forecastAdapter.getForecastAccuracy();
    
    _forecastData = {
      'accuracy': '${(accuracy * 100).toStringAsFixed(1)}%',
      'nextPeak': '${2 + random.nextInt(4)}.${random.nextInt(9)} hours',
      'solarOutput': '${forecast.solarForecast.toStringAsFixed(1)} kW',
      'windOutput': '${forecast.windForecast.toStringAsFixed(1)} kW',
      'demandPeak': '${65 + random.nextInt(20)} kW',
      'confidence': '${(forecast.confidence * 100).toStringAsFixed(0)}%',
      'ensembleMembers': forecast.ensembleMembers.length,
    };
  }

  void _updateMarketData() {
    final random = Random();
    final latest = _latestData;
    
    _marketData = {
      'currentPrice': '\$${(latest?.marketPrice ?? 0.18 + random.nextDouble() * 0.15).toStringAsFixed(2)}/kWh',
      'todayProfit': '\$${42.50 + random.nextDouble() * 15.0}',
      'carbonCredits': '${12.5 + random.nextDouble() * 3.0} tCO₂',
      'tradingVolume': '${150 + random.nextInt(100)} MWh',
      'priceTrend': random.nextDouble() > 0.5 ? 'Rising' : 'Stable',
      'arbitrageOpp': '\$${8.5 + random.nextDouble() * 6.0}',
      'revenueToday': '\$${125 + random.nextInt(75)}',
    };
  }

  void _updateCarbonData() {
    final random = Random();
    final latest = _latestData;
    
    _carbonData = {
      'co2Saved': '${(latest?.carbonReduction ?? 25.0 + random.nextDouble() * 10.0).toStringAsFixed(1)} kg/h',
      'creditsEarned': '${((latest?.carbonReduction ?? 25.0) * 0.05 + random.nextDouble() * 0.5).toStringAsFixed(1)}',
      'totalReduction': '${1250 + random.nextInt(500)} kg',
      'equivalentTrees': '${8 + random.nextInt(5)} trees',
      'carbonIntensity': '${120 + random.nextInt(80)} g/kWh',
      'renewableMix': '${65 + random.nextInt(25)}%',
      'savingsToday': '\$${15.0 + random.nextDouble() * 8.0}',
    };
  }

  void _setupDataStream() {
    _simulationAdapter.dataStream.listen((metric) {
      if (mounted) {
        setState(() {
          _dataPoints.add(metric);
          if (_dataPoints.length > _maxDataPoints) {
            _dataPoints.removeAt(0);
          }
        });
      }
    }, onError: (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data stream error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _toggleNightMode() {
    setState(() {
      _isNightMode = !_isNightMode;
    });
  }

  Color _getBackgroundColor() {
    return _isNightMode ? const Color(0xFF121212) : const Color(0xFFf8f9fa);
  }

  Color _getCardColor() {
    return _isNightMode ? const Color(0xFF1E1E1E) : Colors.white;
  }

  Color _getTextColor() {
    return _isNightMode ? Colors.white : Colors.black87;
  }

  Color _getSubtitleColor() {
    return _isNightMode ? Colors.white70 : Colors.grey.shade600;
  }

  Color _getIconColor() {
    return _isNightMode ? Colors.blue.shade300 : Colors.blue.shade700;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _clockTimer.cancel();
    _featuresUpdateTimer.cancel();
    _simulationAdapter.dispose();
    super.dispose();
  }

  List<FlSpot> get _generationSpots {
    return _dataPoints
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.generation))
        .toList();
  }

  List<FlSpot> get _consumptionSpots {
    return _dataPoints
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.consumption))
        .toList();
  }

  List<FlSpot> get _evSpots {
    return _dataPoints
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.evPower.abs()))
        .toList();
  }

  MetricPoint? get _latestData {
    return _dataPoints.isNotEmpty ? _dataPoints.last : null;
  }

  @override
  Widget build(BuildContext context) {
    final latest = _latestData;
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 1200;

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isNightMode 
                        ? [Colors.blue.shade800, Colors.purple.shade600]
                        : [Colors.blue.shade600, Colors.green.shade600],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.eco, 
                  color: Colors.white, 
                  size: 20
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Advanced Hybrid Energy Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _getTextColor(),
                ),
              ),
            ],
          ),
          backgroundColor: _isNightMode ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: _isNightMode ? 4 : 2,
          shadowColor: Colors.black.withOpacity(_isNightMode ? 0.3 : 0.1),
          actions: [
            // Real-time Clock Display
            _buildRealTimeClock(),
            const SizedBox(width: 12),
            
            // Day/Night Mode Toggle Button
            _buildDayNightToggle(),
            const SizedBox(width: 12),
            
            _buildAppBarAction(
              icon: _simulationAdapter.isPaused ? Icons.play_arrow : Icons.pause,
              tooltip: 'Pause/Resume simulation',
              onPressed: () {
                setState(() {
                  _simulationAdapter.togglePause();
                });
              },
              color: _getIconColor(),
            ),
            _buildAppBarAction(
              icon: Icons.emergency,
              tooltip: 'Activate Emergency Response',
              onPressed: () {
                _simulationAdapter.activateEmergencyMode();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('🚨 Emergency Mode Activated'),
                    backgroundColor: Colors.red.shade600,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              color: Colors.red.shade600,
            ),
            _buildAppBarAction(
              icon: Icons.refresh,
              tooltip: 'Refresh Data',
              onPressed: () {
                setState(() {});
              },
              color: Colors.green.shade600,
            ),
          ],
        ),
        backgroundColor: _getBackgroundColor(),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Welcome
                _buildWelcomeHeader(),
                const SizedBox(height: 24),

                // Main KPI Cards - Horizontal Scroll
                _buildKpiSection(latest),
                const SizedBox(height: 28),

                // Charts and Panels Row
                _buildMainContentRow(screenWidth, isLargeScreen),
                const SizedBox(height: 28),

                // Additional Features Grid
                _buildFeaturesGrid(screenWidth, isLargeScreen),
                const SizedBox(height: 28),

                // Recommendations
                _buildRecommendationsSection(latest),
              ],
            ),
          ),
        ),
      );
  }

  // Real-time Clock Widget
  Widget _buildRealTimeClock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isNightMode
              ? [Colors.blue.shade800, Colors.purple.shade700]
              : [Colors.blue.shade50, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isNightMode ? Colors.blue.shade400 : Colors.blue.shade100,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Date
          Text(
            _formatDate(_currentTime),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _isNightMode ? Colors.white : Colors.blue.shade800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // Time with seconds
          Text(
            _formatTime(_currentTime),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _isNightMode ? Colors.blue.shade200 : Colors.purple.shade700,
              fontFamily: 'Monospace',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Day/Night Mode Toggle Button
  Widget _buildDayNightToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: _isNightMode ? Colors.blue.shade800 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isNightMode ? Colors.blue.shade400 : Colors.orange.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _isNightMode 
                ? Colors.blue.shade800.withOpacity(0.5)
                : Colors.orange.shade300.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          _isNightMode ? Icons.nightlight_round : Icons.wb_sunny,
          color: _isNightMode ? Colors.yellow.shade200 : Colors.orange.shade700,
          size: 20,
        ),
        onPressed: _toggleNightMode,
        tooltip: _isNightMode ? 'Switch to Day Mode' : 'Switch to Night Mode',
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${_getWeekday(dateTime.weekday)}, ${dateTime.day} ${_getMonth(dateTime.month)} ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  String _getWeekday(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildAppBarAction({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isNightMode
              ? [Colors.blue.shade900, Colors.purple.shade800]
              : [Colors.blue.shade50, Colors.green.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isNightMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isNightMode ? Colors.blue.shade800 : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isNightMode ? 0.3 : 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.energy_savings_leaf, 
              size: 32, 
              color: _isNightMode ? Colors.green.shade300 : Colors.green.shade600
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Energy Management System',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _isNightMode ? Colors.white : Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Real-time monitoring and optimization of hybrid energy resources',
                  style: TextStyle(
                    fontSize: 14,
                    color: _isNightMode ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiSection(MetricPoint? latest) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            'KEY PERFORMANCE INDICATORS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _getSubtitleColor(),
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            children: [
              KpiCard(
                title: 'SOLAR GENERATION',
                value: latest != null ? '${latest.generation.toStringAsFixed(1)} kW' : '--',
                subtitle: 'Current output',
                icon: Icons.wb_sunny,
                color: Colors.orange.shade600,
                gradient: _isNightMode
                    ? [Colors.orange.shade800, Colors.orange.shade600]
                    : [Colors.orange.shade600, Colors.orange.shade400],
                width: 180,
              ),
              const SizedBox(width: 12),
              KpiCard(
                title: 'ENERGY CONSUMPTION',
                value: latest != null ? '${latest.consumption.toStringAsFixed(1)} kW' : '--',
                subtitle: 'Current load',
                icon: Icons.bolt,
                color: Colors.red.shade600,
                gradient: _isNightMode
                    ? [Colors.red.shade800, Colors.red.shade600]
                    : [Colors.red.shade600, Colors.red.shade400],
                width: 180,
              ),
              const SizedBox(width: 12),
              KpiCard(
                title: 'BATTERY SOC',
                value: latest != null ? '${latest.batteryLevel.toStringAsFixed(0)}%' : '--',
                subtitle: 'State of charge',
                icon: Icons.battery_charging_full,
                color: Colors.green.shade600,
                gradient: _isNightMode
                    ? [Colors.green.shade800, Colors.green.shade600]
                    : [Colors.green.shade600, Colors.green.shade400],
                width: 180,
              ),
              const SizedBox(width: 12),
              KpiCard(
                title: 'GRID IMPORT',
                value: latest != null ? '\$${latest.gridImport.toStringAsFixed(2)}' : '--',
                subtitle: 'Cost/hour',
                icon: Icons.power,
                color: Colors.blue.shade600,
                gradient: _isNightMode
                    ? [Colors.blue.shade800, Colors.blue.shade600]
                    : [Colors.blue.shade600, Colors.blue.shade400],
                width: 180,
              ),
              const SizedBox(width: 12),
              KpiCard(
                title: 'COMFORT SCORE',
                value: latest != null ? '${latest.comfortScore.toStringAsFixed(0)}%' : '--',
                subtitle: 'Occupant comfort',
                icon: Icons.thermostat,
                color: Colors.purple.shade600,
                gradient: _isNightMode
                    ? [Colors.purple.shade800, Colors.purple.shade600]
                    : [Colors.purple.shade600, Colors.purple.shade400],
                width: 180,
              ),
              const SizedBox(width: 12),
              KpiCard(
                title: 'CARBON REDUCTION',
                value: latest != null ? '${latest.carbonReduction.toStringAsFixed(1)} kg' : '--',
                subtitle: 'CO₂ saved/hour',
                icon: Icons.eco,
                color: Colors.teal.shade600,
                gradient: _isNightMode
                    ? [Colors.teal.shade800, Colors.teal.shade600]
                    : [Colors.teal.shade600, Colors.teal.shade400],
                width: 180,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainContentRow(double screenWidth, bool isLargeScreen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Chart
        Expanded(
          flex: 2,
          child: Card(
            elevation: _isNightMode ? 6 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: _isNightMode ? Colors.grey.shade700 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            color: _getCardColor(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isNightMode ? Colors.blue.shade900 : Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _isNightMode ? Colors.blue.shade600 : Colors.blue.shade100,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.analytics,
                          size: 20,
                          color: _isNightMode ? Colors.blue.shade300 : Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Real-time Energy Flow',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _getTextColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Live monitoring of generation, consumption, and V2G power',
                    style: TextStyle(
                      fontSize: 14,
                      color: _getSubtitleColor(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 300,
                    child: _dataPoints.isNotEmpty
                        ? RealtimeChart(
                            generationSpots: _generationSpots,
                            consumptionSpots: _consumptionSpots,
                            evSpots: _evSpots,
                            isDarkMode: _isNightMode,
                          )
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _isNightMode ? Colors.grey.shade700 : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: _isNightMode ? Colors.blue.shade300 : Colors.blue.shade700,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Initializing data stream...',
                                    style: TextStyle(
                                      color: _getTextColor(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  _buildEnhancedChartLegend(),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Side Panels
        Expanded(
          flex: 1,
          child: Column(
            children: [
              EVPanel(evFleet: _simulationAdapter.evFleet, isDarkMode: _isNightMode),
              const SizedBox(height: 20),
              EmergencyPanel(
                onEmergencyActivated: _simulationAdapter.activateEmergencyMode,
                batteryLevel: _latestData?.batteryLevel ?? 0.0,
                availableV2GPower: _simulationAdapter.evFleet.getAvailableV2GPower(),
                isDarkMode: _isNightMode,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesGrid(double screenWidth, bool isLargeScreen) {
    final crossAxisCount = isLargeScreen ? 4 : (screenWidth > 800 ? 3 : 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SYSTEM FEATURES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _getSubtitleColor(),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        // Wrap in error boundary
        Builder(
          builder: (context) {
            try {
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildFeatureCard(
                    '🤖 AI Predictive Maintenance',
                    'System Health Monitoring & Proactive Alerts',
                    Icons.construction,
                    Colors.orange.shade600,
                    _maintenanceData,
                  ),
                  _buildFeatureCard(
                    '🌤️ Ensemble Forecasting',
                    'Weather & Demand Prediction Analytics',
                    Icons.cloud,
                    Colors.blue.shade600,
                    _forecastData,
                  ),
                  _buildFeatureCard(
                    '💸 Market Trading',
                    'Revenue Optimization & Arbitrage',
                    Icons.trending_up,
                    Colors.green.shade600,
                    _marketData,
                  ),
                  _buildFeatureCard(
                    '🌿 Carbon Tracking',
                    'Environmental Impact & Sustainability',
                    Icons.eco,
                    Colors.teal.shade600,
                    _carbonData,
                  ),
                ],
              );
            } catch (e) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Features temporarily unavailable',
                  style: TextStyle(color: _getTextColor()),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection(MetricPoint? latest) {
    return Card(
      elevation: _isNightMode ? 6 : 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: _getCardColor(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _isNightMode ? Colors.purple.shade800 : Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.lightbulb, 
                    size: 20, 
                    color: _isNightMode ? Colors.purple.shade300 : Colors.purple.shade700
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Smart Recommendations',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.w700,
                    color: _getTextColor(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'AI-powered suggestions for optimal energy management',
              style: TextStyle(
                fontSize: 14, 
                color: _getSubtitleColor(),
              ),
            ),
            const SizedBox(height: 16),
            _buildRecommendations(latest),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.green, 'Generation'),
        const SizedBox(width: 20),
        _buildLegendItem(Colors.orange, 'Consumption'),
        const SizedBox(width: 20),
        _buildLegendItem(Colors.blue, 'V2G Power'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedChartLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isNightMode ? Colors.grey.shade800 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _isNightMode ? Colors.grey.shade700 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildEnhancedLegendItem(
            Colors.green.shade600,
            'Generation',
            Icons.energy_savings_leaf,
          ),
          _buildEnhancedLegendItem(
            Colors.orange.shade600,
            'Consumption',
            Icons.bolt,
          ),
          _buildEnhancedLegendItem(
            Colors.blue.shade600,
            'V2G Power',
            Icons.electric_car,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedLegendItem(Color color, String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isNightMode ? 0.2 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, Color color, Map<String, dynamic> data) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()..scale(isHovered ? 1.02 : 1.0),
            child: Card(
              elevation: isHovered ? 8 : (_isNightMode ? 6 : 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isHovered ? color.withOpacity(0.3) : Colors.transparent,
                  width: isHovered ? 2 : 0,
                ),
              ),
              color: _getCardColor(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isHovered 
                        ? [color.withOpacity(_isNightMode ? 0.2 : 0.1), color.withOpacity(_isNightMode ? 0.1 : 0.05)]
                        : [color.withOpacity(_isNightMode ? 0.1 : 0.05), color.withOpacity(_isNightMode ? 0.05 : 0.02)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isHovered ? color.withOpacity(0.2) : color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isHovered ? [
                                BoxShadow(
                                  color: color.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ] : null,
                            ),
                            child: Icon(icon, color: color, size: isHovered ? 22 : 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(
                                fontSize: isHovered ? 17 : 16,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                              child: Text(title),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: _getSubtitleColor(),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Safe data display with error handling
                      ..._getSafeFeatureDataEntries(data).map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getSubtitleColor(),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  // New safe method to get feature data entries
  List<MapEntry<String, String>> _getSafeFeatureDataEntries(Map<String, dynamic> data) {
    try {
      final entries = data.entries.toList();
      final count = entries.length > 5 ? 5 : entries.length;
      return entries.sublist(0, count).map((entry) =>
        MapEntry(entry.key, entry.value?.toString() ?? 'N/A')
      ).toList();
    } catch (e) {
      // Return empty list if there's any error
      return [];
    }
  }

  Widget _buildRecommendations(MetricPoint? latest) {
    if (latest == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _isNightMode ? Colors.grey.shade800 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CircularProgressIndicator(
              color: _isNightMode ? Colors.blue.shade300 : Colors.blue.shade700,
            ),
            const SizedBox(height: 12),
            Text(
              'Analyzing system data...',
              style: TextStyle(
                color: _getTextColor(),
              ),
            ),
          ],
        ),
      );
    }

    final recommendations = <String>[];

    // EV Integration & V2G
    if (latest.generation > latest.consumption * 1.3) {
      recommendations.add('🚗 Charge EV fleet - excess solar available for V2G preparation');
    } else if (latest.consumption > latest.generation * 1.4) {
      recommendations.add('🔌 Activate V2G - discharge EVs to support grid during peak demand');
    }

    // Comfort Optimization
    if (latest.comfortScore < 75) {
      recommendations.add('🏠 Adjust HVAC settings - optimize for occupant comfort and efficiency');
    }

    // Market Participation
    if (latest.marketPrice > 0.25) {
      recommendations.add('💸 Sell battery power - high market prices detected');
    }

    // Environmental KPIs
    recommendations.add('🌱 Carbon reduction: ${latest.carbonReduction.toStringAsFixed(1)} kg/h • Estimated savings: \$${(latest.carbonReduction * 0.05).toStringAsFixed(2)}/h');

    // Emergency Response
    if (latest.batteryLevel > 80) {
      recommendations.add('🛡️ Emergency backup: Battery ready for critical load support');
    }

    // Predictive Maintenance
    final maintenance = _simulationAdapter.getMaintenancePredictions();
    if (maintenance['solarInverter'] == 'Needs inspection') {
      recommendations.add('🔧 Schedule inverter maintenance - predictive alert');
    }

    if (recommendations.isEmpty) {
      recommendations.add('✅ System operating at optimal efficiency');
    }

    return Container(
      decoration: BoxDecoration(
        color: _isNightMode ? Colors.grey.shade800 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: recommendations
            .map((rec) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCardColor(),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(_isNightMode ? 0.1 : 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: _isNightMode ? Colors.blue.shade300 : Colors.blue.shade600,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          rec,
                          style: TextStyle(
                            fontSize: 14,
                            color: _getTextColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}