import 'package:flutter/material.dart';

class MarketPanel extends StatelessWidget {
  final double currentPrice;
  final double profitToday;
  final double carbonCredits;

  const MarketPanel({
    super.key,
    required this.currentPrice,
    required this.profitToday,
    required this.carbonCredits,
  });

  @override
  Widget build(BuildContext context) {
    final isHighPrice = currentPrice > 0.25;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade50, Colors.teal.shade50],
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
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.attach_money, size: 20, color: Colors.green.shade700),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Market Trading',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Energy arbitrage & carbon trading',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              _buildMarketMetric(
                'Current Price',
                '\$${currentPrice.toStringAsFixed(2)}/kWh',
                isHighPrice ? Colors.green : Colors.orange,
                isHighPrice ? 'High profit opportunity' : 'Normal market conditions',
              ),
              const SizedBox(height: 12),
              _buildMarketMetric(
                'Today\'s Profit',
                '\$${profitToday.toStringAsFixed(2)}',
                Colors.green,
                'From energy trading',
              ),
              const SizedBox(height: 12),
              _buildMarketMetric(
                'Carbon Credits',
                '${carbonCredits.toStringAsFixed(1)} tCO₂',
                Colors.teal,
                'Available for trading',
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade600, Colors.teal.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Handle market participation
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.trending_up, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          const Text(
                            'OPTIMIZE TRADING STRATEGY',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarketMetric(String label, String value, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}