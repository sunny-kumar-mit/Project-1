import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

class HybridDashboardApp extends StatelessWidget {
  const HybridDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Hybrid Energy Dashboard',
      theme: ThemeData(
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
      ),
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}