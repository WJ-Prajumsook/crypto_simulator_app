import 'dart:async';

import 'package:crypto_simulator_app/model/quote.dart';
import 'package:crypto_simulator_app/provider/crypto_provider.dart';
import 'package:crypto_simulator_app/ui/detail_screen.dart';
import 'package:crypto_simulator_app/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PorfolioScreen extends StatefulWidget {
  const PorfolioScreen({Key? key}) : super(key: key);

  @override
  PorfolioScreenState createState() => PorfolioScreenState();
}

class PorfolioScreenState extends State<PorfolioScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    Provider.of<CryptoProvider>(context, listen: false).fetchPortfolioQuotes();
    Provider.of<CryptoProvider>(context, listen: false).init();
    reload();
  }

  void reload() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Provider.of<CryptoProvider>(context, listen: false)
          .fetchPortfolioQuotes();
      Provider.of<CryptoProvider>(context, listen: false).init();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Quote> quotes = context.watch<CryptoProvider>().portfolioQuotes;
    PortfolioModel portfolioModel =
        context.watch<CryptoProvider>().portfolioModel;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Utils.createTotalBalance(
                portfolioModel.totalBalance, portfolioModel.totalChangePercent),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Portfolio',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          List<Coin> coins = portfolioModel.coins;
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      symbol: coins[index].symbol!),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(18),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                quotes[index].coinImageUrl ??
                                                    ''),
                                          ),
                                          title: Text(
                                            '${quotes[index].shortName}'
                                                .replaceAll('USD', ''),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            quotes[index]
                                                .symbol!
                                                .replaceAll('-USD', ''),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            '\$${Utils.format(quotes[index].regularMarketPrice ?? 0)}',
                                            textAlign: TextAlign.end,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${Utils.format(quotes[index].regularMarketChangePercent ?? 0)}%',
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: (quotes[index]
                                                      .regularMarketChangePercent!
                                                      .isNegative)
                                                  ? Colors.red
                                                  : const Color(0xFF14836B),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    color: Color(0xFF14836B),
                                    height: 1,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            Utils.format(
                                                coins[index].numberOfCoin!),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            coins[index]
                                                .symbol!
                                                .replaceAll('-USD', ''),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: Text(
                                            '\$${Utils.format(coins[index].change ?? 0)}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: (coins[index].change! >
                                                      coins[index].price!)
                                                  ? const Color(0xFF14836B)
                                                  : Colors.red,
                                            ),
                                          ),
                                          subtitle: const Text(
                                            'Value',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: quotes.length),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
