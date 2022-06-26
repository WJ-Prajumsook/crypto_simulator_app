import 'package:crypto_simulator_app/ui/main_screen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/coin.jpg'),
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          Column(
            children: [
              const Expanded(
                flex: 7,
                child: Text(''),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: const Text(
                        'Track your cryptocurrency portfolio in realtime',
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      height: 50,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainScreen(key: key)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF14836B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Create Portfolio',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
