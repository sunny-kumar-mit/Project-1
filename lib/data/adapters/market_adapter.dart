class MarketAdapter {
  Map<String, dynamic> getTradingOpportunities() {
    return {'opportunities': []};
  }

  Map<String, dynamic> getRegulatoryOpportunities() {
    return {'regulatory': []};
  }

  List<Map<String, dynamic>> getRecentTrades() {
    return [];
  }

  double getCurrentPrice() {
    return 0.0;
  }

  List<double> getPriceHistory() {
    return [];
  }
}
