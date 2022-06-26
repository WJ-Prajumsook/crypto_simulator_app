import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.account_circle_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 28,
                            ),
                          ),
                          Text(
                            'View Profile',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF14836B),
                  ),
                ],
              ),
              const Divider(height: 25),
              createRowContent('Settings', Icons.settings_rounded),
              const Divider(height: 25),
              createRowContent('Help Centre', Icons.help_center_outlined),
              const Divider(height: 25),
              createRowContent('Information', Icons.info_outline_rounded),
              const Divider(height: 25),
              createRowContent('Sign up', Icons.app_registration),
            ],
          ),
        ),
      ),
    );
  }

  Widget createRowContent(String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
            ),
            const SizedBox(width: 15),
            Text(text),
          ],
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF14836B),
        ),
      ],
    );
  }
}
