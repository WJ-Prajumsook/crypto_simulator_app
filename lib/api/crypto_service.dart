import 'dart:convert';

import 'package:crypto_simulator_app/model/quote.dart';
import 'package:crypto_simulator_app/model/quote_detail.dart';
import 'package:http/http.dart' as http;

class CryptoService {
  static Future<List<Quote>> fetchQuotesBySymbol(String symbols) async {
    final String url =
        'https://query1.finance.yahoo.com/v7/finance/quote?symbols=$symbols';
    List<Quote> quotes = [];
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['quoteResponse']['result'] as List;
        quotes = data.map((q) => Quote.fromJson(q)).toList();
      }
    } catch (error) {
      throw Exception(error);
    }

    return quotes;
  }

  static Future<List<Quote>> fetchQuotes(int count) async {
    final String url =
        'https://query2.finance.yahoo.com/v1/finance/screener/predefined/saved?formatted=false&scrIds=all_cryptocurrencies_us&start=0&count=$count';
    List<Quote> quotes = [];
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['finance']['result'][0]['quotes'] as List;
        quotes = data.map((q) => Quote.fromJson(q)).toList();
      }
    } catch (error) {
      throw Exception(error);
    }

    return quotes;
  }

  static Future<QuoteDetail> fetchDetail(
      String symbol, String range, String interval) async {
    final String url =
        'https://query2.finance.yahoo.com/v7/finance/spark?symbols=$symbol&range=$range&interval=$interval';
    QuoteDetail quoteDetail = QuoteDetail();

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['spark']['result'][0]['response'][0];
        quoteDetail = QuoteDetail.fromJson(data['meta']);

        List<int> timestamp = data['timestamp'].cast<int>();
        List<QuoteData> quoteData = [];
        for (var i = 0; i < timestamp.length; i++) {
          double close = data['indicators']['quote'][0]['close'][i] ??
              data['indicators']['quote'][0]['close'][i - 1];
          DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(timestamp[i] * 1000);
          final qd = QuoteData(
            dateTime: dateTime,
            close: close,
          );
          quoteData.add(qd);
        }

        quoteDetail.quoteData = quoteData;
        quoteDetail.last = quoteData[quoteData.length - 1].dateTime;
      }
    } catch (error) {
      throw Exception(error);
    }
    //print(quoteDetail.quoteData!.length.toString());

    return quoteDetail;
  }

  static Future<Quote> fetchQuote(String symbol) async {
    final String url =
        'https://query1.finance.yahoo.com/v7/finance/quote?symbols=$symbol';
    Quote quote = Quote();

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['quoteResponse']['result'][0];
        quote = Quote.fromJson(data);
      }
    } catch (error) {
      throw Exception(error);
    }

    return quote;
  }
}
