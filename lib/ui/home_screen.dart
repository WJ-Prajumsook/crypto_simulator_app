import 'dart:async';

import 'package:crypto_simulator_app/model/quote.dart';
import 'package:crypto_simulator_app/provider/crypto_provider.dart';
import 'package:crypto_simulator_app/ui/detail_screen.dart';
import 'package:crypto_simulator_app/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    Provider.of<CryptoProvider>(context, listen: false).fetchWatchlist();
    Provider.of<CryptoProvider>(context, listen: false).init();
    reload();
  }

  void reload() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
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
    List<Quote> watchlistQuotes =
        context.watch<CryptoProvider>().watchlistQuotes;
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
              padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
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
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 40,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFDDDEEE),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 15),
                                  Center(
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          coins[index].coinImageUrl ?? ''),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      coins[index].shortName ??
                                          ''.replaceAll('USD', ''),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Center(
                                    child: Text(
                                      '\$${Utils.format(coins[index].change ?? 0)}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: ((coins[index].change ?? 0) >
                                                (coins[index].price ?? 0))
                                            ? const Color(0xFF14836B)
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '${Utils.format(coins[index].numberOfCoin ?? 0)} ${coins[index].symbol}'
                                          .replaceAll('-USD', ''),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        itemCount: portfolioModel.coins.length),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Watchlist ${watchlistQuotes.length}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    flex: 2,
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Utils.createListView(
                              watchlistQuotes[index], context);
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: watchlistQuotes.length),
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
