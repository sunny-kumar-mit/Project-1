import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Color> gradient;
  final double width;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    this.color = Colors.blue,
    this.gradient = const [Colors.blueAccent, Colors.lightBlueAccent],
    this.width = 180,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 140, // Fixed height to prevent overflow
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header with icon and menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: Colors.white, size: 18),
                    ),
                    _buildMenuButton(context),
                  ],
                ),
                
                // Content area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main value
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      
                      // Subtitle
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert, 
        size: 18, 
        color: Colors.white.withOpacity(0.8)
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) => _handleMenuSelection(value, context),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'details',
          child: SizedBox(
            width: 150, // Fixed width for menu items
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.analytics, size: 16, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'View Details',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Detailed analysis of $title',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'history',
          child: SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.history, size: 16, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      'View History',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Historical trends for $title',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'export',
          child: SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.download, size: 16, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      'Export Data',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Download $title data as CSV',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'settings',
          child: SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.settings, size: 16, color: Colors.purple),
                    SizedBox(width: 8),
                    Text(
                      'Settings',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Configure $title preferences',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleMenuSelection(String value, BuildContext context) {
    switch (value) {
      case 'details':
        _showDetailedDialog(context);
        break;
      case 'history':
        _showHistorySnackbar(context);
        break;
      case 'export':
        _showExportDialog(context);
        break;
      case 'settings':
        _showSettingsSnackbar(context);
        break;
    }
  }

  void _showDetailedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$title Details'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Value: $value'),
              const SizedBox(height: 12),
              Text('Description: $subtitle'),
              const SizedBox(height: 12),
              const Text(
                'This shows the current performance metric with detailed analysis and recommendations for optimization.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Would you like to export this data as CSV file?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title data exported successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showHistorySnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening historical data for $title'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to history page
          },
        ),
      ),
    );
  }

  void _showSettingsSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening settings for $title'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}