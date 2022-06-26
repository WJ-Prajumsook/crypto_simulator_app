import 'package:flutter/material.dart';

class Quote {
  String? currency;
  String? shortName;
  String? coinImageUrl;
  String? symbol;
  int? marketCap;
  int? firstTradeDateMilliseconds;
  int? startDate;
  double? regularMarketChange;
  double? regularMarketPrice;
  int? regularMarketValue;
  double? regularMarketPreviousClose;
  double? regularMarketOpen;
  double? regularMarketChangePercent;

  Quote({
    this.currency,
    this.shortName,
    this.coinImageUrl,
    this.symbol,
    this.marketCap,
    this.firstTradeDateMilliseconds,
    this.startDate,
    this.regularMarketChange,
    this.regularMarketPrice,
    this.regularMarketValue,
    this.regularMarketPreviousClose,
    this.regularMarketOpen,
    this.regularMarketChangePercent,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      currency: json['currency'],
      shortName: json['shortName'],
      coinImageUrl: json['coinImageUrl'],
      symbol: json['symbol'],
      marketCap: json['marketCap'],
      firstTradeDateMilliseconds: json['firstTradeDateMilliseconds'],
      startDate: json['startDate'],
      regularMarketOpen: json['regularMarketOpen'],
      regularMarketPrice: json['regularMarketPrice'],
      regularMarketValue: json['regularMarketValue'],
      regularMarketChange: json['regularMarketChange'],
      regularMarketPreviousClose: json['regularMarketPreviousClose'],
      regularMarketChangePercent: json['regularMarketChangePercent'],
    );
  }
}
