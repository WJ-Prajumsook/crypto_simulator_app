import 'package:crypto_simulator_app/model/quote.dart';
import 'package:crypto_simulator_app/ui/detail_screen.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class Utils {
  static format(double value) {
    final currencyFormater = NumberFormat('#,##0.0000', 'en_US');
    return currencyFormater.format(value);
  }

  static createTotalBalance(double balance, double percent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        const Text(
          'total balance',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          '\$${Utils.format(balance)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 35,
          ),
        ),
        Text(
          '${Utils.format(percent)}%',
          style: TextStyle(
            color: (percent.isNegative) ? Colors.red : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static createListView(Quote quote, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailScreen(symbol: quote.symbol!)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(quote.coinImageUrl ?? ''),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quote.shortName!.replaceAll('USD', ''),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      quote.symbol!.replaceAll('-USD', ''),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${Utils.format(quote.regularMarketPrice ?? 0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${Utils.format(quote.regularMarketChangePercent ?? 0)}%',
                  style: TextStyle(
                    color: (quote.regularMarketChangePercent! > 0)
                        ? const Color(0xFF14836B)
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
