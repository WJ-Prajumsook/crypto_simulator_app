import 'dart:ui';

import 'package:crypto_simulator_app/model/quote.dart';
import 'package:crypto_simulator_app/model/quote_detail.dart';
import 'package:crypto_simulator_app/provider/crypto_provider.dart';
import 'package:crypto_simulator_app/ui/buy_screen.dart';
import 'package:crypto_simulator_app/ui/sell_screen.dart';
import 'package:crypto_simulator_app/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key, required this.symbol}) : super(key: key);
  final String symbol;

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  String granularity = '1D';

  @override
  void initState() {
    super.initState();
    Provider.of<CryptoProvider>(context, listen: false)
        .fetchDetail(widget.symbol, '1d', '15m');
  }

  @override
  Widget build(BuildContext context) {
    QuoteDetail detail = context.watch<CryptoProvider>().quoteDetail;
    Quote quote = context.watch<CryptoProvider>().currentQuote;
    Quote currentQuote = context.watch<CryptoProvider>().currentQuote;
    bool isHolding = context.watch<CryptoProvider>().isHolding(widget.symbol);
    Coin coin = context
        .watch<CryptoProvider>()
        .getCurrentCoin(widget.symbol, quote.regularMarketPrice!);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(35),
                    ),
                    color: Color(0xFF14836B),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              Column(
                children: [
                  Align(
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(quote.coinImageUrl ?? ''),
                    ),
                  ),
                  Align(
                    child: Text(
                      '\$${Utils.format(quote.regularMarketPrice ?? 0)}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Align(
                    child: Text(
                      'Change ${Utils.format(quote.regularMarketChangePercent ?? 0)}%',
                      style: TextStyle(
                        fontSize: 18,
                        color: (quote.regularMarketChangePercent!.isNegative)
                            ? Colors.red
                            : const Color(0xFF14836B),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildGranularity('1D', '15M'),
                    buildGranularity('5D', '30M'),
                    buildGranularity('1MO', '1D'),
                    buildGranularity('3MO', '1D'),
                    buildGranularity('1Y', '1D'),
                    buildGranularity('5Y', '1WK'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  visibleMinimum: detail.quoteData?[0].dateTime,
                  visibleMaximum: detail.last,
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  intervalType: DateTimeIntervalType.auto,
                ),
                series: <ChartSeries<QuoteData, DateTime>>[
                  SplineSeries(
                    dataSource: detail.quoteData ?? [],
                    xValueMapper: (QuoteData d, _) => d.dateTime,
                    yValueMapper: (QuoteData d, _) => d.close,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'Holding'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                child: (!isHolding)
                    ? const Text(
                        'You don\'t have any holding yet.',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '\$${Utils.format(coin.change ?? 0)}',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: (coin.change! > coin.price!)
                                      ? Colors.black.withOpacity(0.6)
                                      : Colors.red.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                'Value',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${Utils.format(coin.changePercent ?? 0)}%',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: (coin.changePercent!.isNegative)
                                      ? Colors.red.withOpacity(0.8)
                                      : Colors.black.withOpacity(0.6),
                                ),
                              ),
                              Text(
                                'Change',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              const Spacer(),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: (isHolding)
                        ? ElevatedButton(
                            onPressed: () {
                              showCupertinoModalBottomSheet(
                                expand: true,
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Scaffold(
                                  backgroundColor: Colors.white,
                                  body: Builder(
                                    builder: (context) => SellScreen(
                                      quote: quote,
                                      coin: coin,
                                    ),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'Sell ${quote.symbol!}'.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          )
                        : const Text(''),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          expand: true,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Scaffold(
                            backgroundColor: Colors.white,
                            body: Builder(
                              builder: (context) => BuyScreen(quote: quote),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF14836B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        'Buy ${quote.symbol!}'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGranularity(String title, String interval) {
    return InkWell(
      onTap: () {
        setState(() {
          granularity = title;
          Provider.of<CryptoProvider>(context, listen: false).fetchDetail(
              widget.symbol, title.toLowerCase(), interval.toLowerCase());
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color:
              (title == granularity) ? const Color(0xFF14836B) : Colors.white,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: (title == granularity) ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
