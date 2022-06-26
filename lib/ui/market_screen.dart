import 'dart:async';

import 'package:crypto_simulator_app/model/quote.dart';
import 'package:crypto_simulator_app/provider/crypto_provider.dart';
import 'package:crypto_simulator_app/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  MarketScreenState createState() => MarketScreenState();
}

class MarketScreenState extends State<MarketScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    Provider.of<CryptoProvider>(context, listen: false).fetchQuotes(50);
    reload();
  }

  void reload() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Provider.of<CryptoProvider>(context, listen: false).fetchQuotes(50);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Quote> quotes = context.watch<CryptoProvider>().marketQuotes;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Market'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Utils.createListView(quotes[index], context);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: quotes.length),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
