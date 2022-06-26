import 'package:crypto_simulator_app/model/quote.dart';
import 'package:crypto_simulator_app/provider/crypto_provider.dart';
import 'package:crypto_simulator_app/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key, required this.quote, required this.coin})
      : super(key: key);
  final Quote quote;
  final Coin coin;

  @override
  SellScreenState createState() => SellScreenState();
}

class SellScreenState extends State<SellScreen> {
  double amount = 0;
  double unit = 0;
  final amountController = TextEditingController();
  final unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amount = widget.coin.numberOfCoin!;
    amountController.text =
        (amount * widget.quote.regularMarketPrice!).toString();
    unitController.text = widget.coin.numberOfCoin!.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(widget.quote.coinImageUrl ?? ''),
          ),
          Text(
            'Sell ${widget.quote.symbol}'.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You sell (100%)',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: unitController,
                onChanged: (text) {},
              ),
              const SizedBox(height: 20),
              const Text(
                'You receive approzimately',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: amountController,
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  '1 ${widget.quote.symbol} = \$${Utils.format(widget.quote.regularMarketPrice!)}'
                      .replaceAll('-USD', ''),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                //context.read<CryptoProvider>().sellQuote(widget.coin.symbol!);
                Provider.of<CryptoProvider>(context, listen: false)
                    .sellQuote(widget.coin.symbol!);
                context.read<CryptoProvider>().init();
                context.read<CryptoProvider>().fetchPortfolioQuotes();

                final snackBar = SnackBar(
                  content: Text(
                    'You have successfully sold ${widget.quote.symbol}',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Continue'.toUpperCase(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
