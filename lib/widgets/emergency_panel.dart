import 'package:flutter/material.dart';

class EmergencyPanel extends StatefulWidget {
  final VoidCallback onEmergencyActivated;
  final double batteryLevel;
  final double availableV2GPower;
  final bool isDarkMode;

  const EmergencyPanel({
    super.key,
    required this.onEmergencyActivated,
    required this.batteryLevel,
    required this.availableV2GPower,
    this.isDarkMode = false,
  });

  @override
  State<EmergencyPanel> createState() => _EmergencyPanelState();
}

class _EmergencyPanelState extends State<EmergencyPanel> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

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

  Color _getEmergencyColor(bool canSupportEmergency, bool isReady) {
    if (!canSupportEmergency) {
      return widget.isDarkMode ? Colors.orange.shade400 : Colors.orange.shade600;
    }
    return isReady 
        ? (widget.isDarkMode ? Colors.red.shade400 : Colors.red.shade600)
        : (widget.isDarkMode ? Colors.red.shade500 : Colors.red.shade700);
  }

  Color _getEmergencyBackgroundColor(bool canSupportEmergency, bool isReady) {
    if (!canSupportEmergency) {
      return widget.isDarkMode ? Colors.orange.shade900 : Colors.orange.shade50;
    }
    return isReady 
        ? (widget.isDarkMode ? Colors.red.shade900 : Colors.red.shade100)
        : (widget.isDarkMode ? Colors.red.shade800 : Colors.red.shade50);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSupportEmergency = widget.batteryLevel > 30 && widget.availableV2GPower > 5;
    final isReady = canSupportEmergency && _isHovered;
    final emergencyColor = _getEmergencyColor(canSupportEmergency, isReady);
    final emergencyBackgroundColor = _getEmergencyBackgroundColor(canSupportEmergency, isReady);
    
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: widget.isDarkMode ? 8 : (_isHovered ? 8 : 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: _getCardColor(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      emergencyBackgroundColor,
                      _getCardColor(),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: _isHovered 
                      ? Border.all(
                          color: emergencyColor,
                          width: 2,
                        )
                      : Border.all(
                          color: widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                          width: 1,
                        ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with animated icon
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: emergencyColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: _isHovered
                                  ? [
                                      BoxShadow(
                                        color: emergencyColor.withOpacity(0.3),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                Icons.emergency,
                                size: 20,
                                color: emergencyColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: emergencyColor,
                            ),
                            child: Text('Emergency Response'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Grid failure backup system',
                        style: TextStyle(
                          fontSize: 14, 
                          color: _getSubtitleColor(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Emergency metrics with hover effects
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: emergencyColor.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(widget.isDarkMode ? 0.3 : 0.05),
                              blurRadius: _isHovered ? 12 : 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Battery and V2G metrics
                            Row(
                              children: [
                                _buildEmergencyMetric(
                                  'Battery', 
                                  '${widget.batteryLevel.toStringAsFixed(0)}%', 
                                  _getBatteryColor(widget.batteryLevel),
                                  Icons.battery_full,
                                ),
                                const SizedBox(width: 16),
                                _buildEmergencyMetric(
                                  'V2G Power', 
                                  '${widget.availableV2GPower.toStringAsFixed(1)} kW',
                                  _getV2GPowerColor(widget.availableV2GPower),
                                  Icons.bolt,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            
                            // Emergency button with pulse effect
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    emergencyColor,
                                    emergencyColor.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: emergencyColor.withOpacity(_isHovered ? 0.5 : 0.3),
                                    blurRadius: _isHovered ? 15 : 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: canSupportEmergency ? widget.onEmergencyActivated : null,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          child: Icon(
                                            Icons.emergency,
                                            color: Colors.white,
                                            size: _isHovered && canSupportEmergency ? 24 : 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 300),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: _isHovered && canSupportEmergency ? 15 : 14,
                                          ),
                                          child: Text(
                                            canSupportEmergency 
                                                ? 'ACTIVATE EMERGENCY MODE'
                                                : 'INSUFFICIENT BACKUP POWER',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Warning message
                            if (!canSupportEmergency) ...[
                              const SizedBox(height: 12),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: widget.isDarkMode ? Colors.orange.shade900 : Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: widget.isDarkMode ? Colors.orange.shade600 : Colors.orange.shade200
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber,
                                      size: 16,
                                      color: widget.isDarkMode ? Colors.orange.shade300 : Colors.orange.shade700,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Minimum 30% battery and 5 kW V2G required',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: widget.isDarkMode ? Colors.orange.shade300 : Colors.orange.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            
                            // Ready status indicator
                            if (canSupportEmergency && _isHovered) ...[
                              const SizedBox(height: 12),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: widget.isDarkMode ? Colors.green.shade900 : Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: widget.isDarkMode ? Colors.green.shade600 : Colors.green.shade200
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 16,
                                      color: widget.isDarkMode ? Colors.green.shade300 : Colors.green.shade700,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'System ready for emergency activation',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: widget.isDarkMode ? Colors.green.shade300 : Colors.green.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmergencyMetric(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(widget.isDarkMode ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(widget.isDarkMode ? 0.4 : 0.2)
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: _isHovered ? 18 : 16,
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
                child: Text(value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBatteryColor(double batteryLevel) {
    if (batteryLevel > 70) return widget.isDarkMode ? Colors.green.shade400 : Colors.green;
    if (batteryLevel > 30) return widget.isDarkMode ? Colors.orange.shade400 : Colors.orange;
    return widget.isDarkMode ? Colors.red.shade400 : Colors.red;
  }

  Color _getV2GPowerColor(double v2gPower) {
    if (v2gPower > 10) return widget.isDarkMode ? Colors.green.shade400 : Colors.green;
    if (v2gPower > 5) return widget.isDarkMode ? Colors.orange.shade400 : Colors.orange;
    return widget.isDarkMode ? Colors.red.shade400 : Colors.red;
  }
}