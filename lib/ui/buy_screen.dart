import 'package:crypto_simulator_app/model/quote.dart';
import 'package:crypto_simulator_app/provider/crypto_provider.dart';
import 'package:crypto_simulator_app/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyScreen extends StatefulWidget {
  const BuyScreen({Key? key, required this.quote}) : super(key: key);
  final Quote quote;

  @override
  BuyScreenState createState() => BuyScreenState();
}

class BuyScreenState extends State<BuyScreen> {
  int amount = 100;
  double unit = 0.0;
  final amountController = TextEditingController();
  final unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    unit = amount / widget.quote.regularMarketPrice!;
    unitController.text = unit.toString();
    amountController.text = amount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage(widget.quote.coinImageUrl!),
          ),
          Text(
            'Buy ${widget.quote.symbol!}'.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You pay',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: amountController,
                onChanged: (text) {
                  setState(() {
                    amount = int.parse(text);
                    unit = amount / widget.quote.regularMarketPrice!;
                    unitController.text = unit.toString();
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'You receive approzimately',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                controller: unitController,
              ),
              const SizedBox(height: 30),
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
                Provider.of<CryptoProvider>(context, listen: false)
                    .buyQuote(widget.quote.symbol!, amount);
                context.read<CryptoProvider>().init();
                final snackBar = SnackBar(
                  content: Text(
                    'You have successfully bought ${widget.quote.symbol}',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF14836B),
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
