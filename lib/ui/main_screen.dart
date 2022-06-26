import 'package:crypto_simulator_app/provider/crypto_provider.dart';
import 'package:crypto_simulator_app/ui/account_screen.dart';
import 'package:crypto_simulator_app/ui/home_screen.dart';
import 'package:crypto_simulator_app/ui/market_screen.dart';
import 'package:crypto_simulator_app/ui/portfolio_screen.dart';
import 'package:crypto_simulator_app/ui/watchlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screens = [
      HomeScreen(key: key),
      PorfolioScreen(key: key),
      WatchlistScreen(key: key),
      MarketScreen(key: key),
      AccountScreen(key: key),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF14836B),
      body: screens[context.watch<CryptoProvider>().currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        selectedItemColor: const Color(0xFF14836B),
        unselectedItemColor: Colors.black.withOpacity(0.6),
        currentIndex: context.watch<CryptoProvider>().currentIndex,
        onTap: (index) {
          Provider.of<CryptoProvider>(context, listen: false)
              .setCurrentIndex(index);
        },
        items: [
          createItem('Home', Icons.home_outlined),
          createItem('Portfolio', Icons.home_repair_service),
          createItem('Watchlist', Icons.list),
          createItem('Market', Icons.bar_chart),
          createItem('Account', Icons.account_circle_outlined),
        ],
      ),
    );
  }

  BottomNavigationBarItem createItem(String label, IconData icon) {
    return BottomNavigationBarItem(
      label: label.toUpperCase(),
      icon: Icon(icon),
    );
  }
}
