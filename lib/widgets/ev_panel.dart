import 'package:flutter/material.dart';
import '../models/ev_model.dart';

class EVPanel extends StatefulWidget {
  final EVFleet evFleet;
  final bool isDarkMode;

  const EVPanel({super.key, required this.evFleet, this.isDarkMode = false});

  @override
  State<EVPanel> createState() => _EVPanelState();
}

class _EVPanelState extends State<EVPanel> {
  String? _hoveredVehicleId;

  Color _getBackgroundColor() {
    return widget.isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
  }

  Color _getCardColor() {
    return widget.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white;
  }

  Color _getTextColor() {
    return widget.isDarkMode ? Colors.white : Colors.black87;
  }

  Color _getSubtitleColor() {
    return widget.isDarkMode ? Colors.white70 : Colors.grey.shade600;
  }

  Color _getHoverColor() {
    return widget.isDarkMode ? Colors.blue.shade800 : Colors.blue.shade50;
  }

  Color _getInactiveColor() {
    return widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade50;
  }

  Color _getBorderColor(bool isGridConnected, bool isHovered) {
    if (!isGridConnected) {
      return widget.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300;
    }
    return isHovered 
        ? (widget.isDarkMode ? Colors.blue.shade400 : Colors.blue.shade300)
        : (widget.isDarkMode ? Colors.green.shade400 : Colors.green.shade200);
  }

  @override
  Widget build(BuildContext context) {
    final availableV2GPower = widget.evFleet.getAvailableV2GPower();

    return Card(
      elevation: widget.isDarkMode ? 6 : 4,
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
                    color: widget.isDarkMode ? Colors.green.shade800 : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.electric_car, 
                    size: 20, 
                    color: widget.isDarkMode ? Colors.green.shade300 : Colors.green.shade700
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'EV Fleet & V2G Integration',
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
              'Vehicle-to-Grid power management',
              style: TextStyle(
                fontSize: 14, 
                color: _getSubtitleColor(),
              ),
            ),
            const SizedBox(height: 20),
            
            // EV Cards
            ...widget.evFleet.vehicles.map((vehicle) => _buildEVCard(vehicle)),
            
            // Description Box that appears when hovering - Placed above V2G Power
            if (_hoveredVehicleId != null) ...[
              const SizedBox(height: 16),
              _buildDescriptionBox(_hoveredVehicleId!),
            ],
            
            const SizedBox(height: 16),
            
            // V2G Power Available Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isDarkMode
                      ? [Colors.blue.shade900, Colors.green.shade900]
                      : [Colors.blue.shade50, Colors.green.shade50],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isDarkMode ? Colors.blue.shade700 : Colors.blue.shade100
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(widget.isDarkMode ? 0.3 : 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.eco, 
                    color: widget.isDarkMode ? Colors.green.shade300 : Colors.green.shade600, 
                    size: 24
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'V2G Power Available',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: widget.isDarkMode ? Colors.green.shade200 : Colors.green.shade800,
                          ),
                        ),
                        Text(
                          '${availableV2GPower.toStringAsFixed(1)} kW',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _getTextColor(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getV2GStatusText(availableV2GPower),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getSubtitleColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Real-time indicator
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: availableV2GPower > 0 
                          ? (widget.isDarkMode ? Colors.green.shade400 : Colors.green)
                          : (widget.isDarkMode ? Colors.grey.shade500 : Colors.grey),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (availableV2GPower > 0 
                              ? (widget.isDarkMode ? Colors.green.shade400 : Colors.green)
                              : (widget.isDarkMode ? Colors.grey.shade500 : Colors.grey))
                              .withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEVCard(EVModel vehicle) {
    final isCharging = vehicle.isCharging;
    final isGridConnected = vehicle.isGridConnected;
    final isHovered = _hoveredVehicleId == vehicle.id;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredVehicleId = vehicle.id),
      onExit: (_) => setState(() => _hoveredVehicleId = null),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isHovered ? _getHoverColor() : _getInactiveColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(isGridConnected, isHovered),
            width: isHovered ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(widget.isDarkMode ? 0.2 : 0.05),
              blurRadius: isHovered ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Battery Icon with real-time status
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isGridConnected 
                        ? (isCharging 
                            ? (widget.isDarkMode ? Colors.orange.shade800 : Colors.orange.shade100)
                            : (widget.isDarkMode ? Colors.green.shade800 : Colors.green.shade100))
                        : (widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(widget.isDarkMode ? 0.3 : 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isCharging ? Icons.battery_charging_full : Icons.electric_car,
                    color: isGridConnected 
                        ? (isCharging 
                            ? (widget.isDarkMode ? Colors.orange.shade300 : Colors.orange.shade600)
                            : (widget.isDarkMode ? Colors.green.shade300 : Colors.green.shade600))
                        : (widget.isDarkMode ? Colors.grey.shade400 : Colors.grey),
                    size: 20,
                  ),
                ),
                // Real-time power flow indicator
                if (vehicle.currentPower != 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: vehicle.currentPower > 0 
                            ? (widget.isDarkMode ? Colors.green.shade400 : Colors.green)
                            : (widget.isDarkMode ? Colors.orange.shade400 : Colors.orange),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white, 
                          width: 1
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.model,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isHovered 
                          ? (widget.isDarkMode ? Colors.blue.shade300 : Colors.blue.shade800)
                          : _getTextColor(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildStatusChip('${vehicle.batteryLevel.toStringAsFixed(0)}%', 
                          _getBatteryColor(vehicle.batteryLevel)),
                      const SizedBox(width: 8),
                      _buildStatusChip(
                        '${vehicle.currentPower.toStringAsFixed(1)} kW', 
                        vehicle.currentPower > 0 
                            ? (widget.isDarkMode ? Colors.green.shade400 : Colors.green)
                            : (widget.isDarkMode ? Colors.orange.shade400 : Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isGridConnected 
                    ? (isHovered 
                        ? (widget.isDarkMode ? Colors.blue.shade800 : Colors.blue.shade100)
                        : (widget.isDarkMode ? Colors.green.shade800 : Colors.green.shade100))
                    : (widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(widget.isDarkMode ? 0.2 : 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                isGridConnected ? 'V2G Ready' : 'Offline',
                style: TextStyle(
                  color: isGridConnected 
                      ? (isHovered 
                          ? (widget.isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700)
                          : (widget.isDarkMode ? Colors.green.shade300 : Colors.green.shade700))
                      : (widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionBox(String vehicleId) {
    final vehicle = widget.evFleet.vehicles.firstWhere((v) => v.id == vehicleId);
    final description = _getVehicleDescription(vehicle);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.blue.shade900 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDarkMode ? Colors.blue.shade600 : Colors.blue.shade200, 
          width: 1.5
        ),
        boxShadow: [
          BoxShadow(
            color: (widget.isDarkMode ? Colors.blue.shade800 : Colors.blue.shade100)
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: widget.isDarkMode ? Colors.blue.shade300 : Colors.blue.shade600,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehicle.model} Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: widget.isDarkMode ? Colors.blue.shade200 : Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.isDarkMode ? Colors.white70 : Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildVehicleStats(vehicle),
        ],
      ),
    );
  }

  Widget _buildVehicleStats(EVModel vehicle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.isDarkMode ? Colors.blue.shade700 : Colors.blue.shade100
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(widget.isDarkMode ? 0.2 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Battery', '${vehicle.batteryLevel.toStringAsFixed(0)}%', 
              _getBatteryColor(vehicle.batteryLevel)),
          _buildStatItem('Capacity', '${vehicle.capacity.toStringAsFixed(0)} kWh', 
              widget.isDarkMode ? Colors.blue.shade300 : Colors.blue),
          _buildStatItem('Status', 
              vehicle.isCharging ? 'Charging' : (vehicle.currentPower > 0 ? 'Supplying' : 'Ready'),
              vehicle.isCharging 
                  ? (widget.isDarkMode ? Colors.orange.shade400 : Colors.orange)
                  : (vehicle.currentPower > 0 
                      ? (widget.isDarkMode ? Colors.green.shade400 : Colors.green)
                      : (widget.isDarkMode ? Colors.blue.shade300 : Colors.blue))),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: _getSubtitleColor(),
          ),
        ),
      ],
    );
  }

  String _getVehicleDescription(EVModel vehicle) {
    final descriptions = {
      'Tesla Model 3': 'Premium electric sedan with ${vehicle.capacity.toStringAsFixed(0)} kWh battery capacity. '
          'Supports bidirectional charging for V2G applications. '
          'Current status: ${vehicle.isCharging ? 'Charging from grid' : 'Available for V2G discharge'}. '
          '${vehicle.currentPower > 0 ? 'Currently supplying ${vehicle.currentPower.toStringAsFixed(1)} kW to grid.' : 'Ready for V2G operations.'}',
      
      'Nissan Leaf': 'Compact electric hatchback with ${vehicle.capacity.toStringAsFixed(0)} kWh battery. '
          'Equipped with CHAdeMO V2G capability. '
          'Current status: ${vehicle.isCharging ? 'Charging from grid' : 'Available for V2G discharge'}. '
          '${vehicle.currentPower > 0 ? 'Currently supplying ${vehicle.currentPower.toStringAsFixed(1)} kW to grid.' : 'Ready for V2G operations.'}',
    };

    return descriptions[vehicle.model] ?? 
        '${vehicle.model} - ${vehicle.isCharging ? 'Currently charging' : 'Grid connected'}. '
        'Battery level: ${vehicle.batteryLevel.toStringAsFixed(0)}%. '
        'Power flow: ${vehicle.currentPower.toStringAsFixed(1)} kW.';
  }

  Color _getBatteryColor(double batteryLevel) {
    if (batteryLevel > 70) return widget.isDarkMode ? Colors.green.shade400 : Colors.green;
    if (batteryLevel > 30) return widget.isDarkMode ? Colors.orange.shade400 : Colors.orange;
    return widget.isDarkMode ? Colors.red.shade400 : Colors.red;
  }

  String _getV2GStatusText(double availablePower) {
    if (availablePower > 10) return 'High V2G capacity available';
    if (availablePower > 5) return 'Moderate V2G capacity';
    if (availablePower > 0) return 'Limited V2G capacity';
    return 'No V2G power available';
  }

  Widget _buildStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(widget.isDarkMode ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(widget.isDarkMode ? 0.4 : 0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}