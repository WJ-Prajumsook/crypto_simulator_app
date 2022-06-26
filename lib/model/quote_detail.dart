class QuoteDetail {
  String? symbol;
  int? firstTradeDate;
  double? previousClose;
  double? regularMarketPrice;
  List<QuoteData>? quoteData;
  DateTime? last;

  QuoteDetail({
    this.symbol,
    this.firstTradeDate,
    this.previousClose,
    this.regularMarketPrice,
  });

  factory QuoteDetail.fromJson(Map<String, dynamic> json) {
    return QuoteDetail(
      symbol: json['symbol'],
      firstTradeDate: json['firstTradeDate'],
      previousClose: json['previousClose'],
      regularMarketPrice: json['regularMarketPrice'],
    );
  }
}

class QuoteData {
  final DateTime dateTime;
  final double close;

  QuoteData({
    required this.dateTime,
    required this.close,
  });
}
