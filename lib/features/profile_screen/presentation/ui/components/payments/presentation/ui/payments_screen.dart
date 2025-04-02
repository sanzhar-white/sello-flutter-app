import 'package:flutter/material.dart';
import 'package:selo/core/theme/theme_provider.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Оплата')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const PaymentsCard();
        },
      ),
    );
  }
}

class PaymentsCard extends StatelessWidget {
  const PaymentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return Container(
      height: 90,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colors.colorText3.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '12.06.2024 / 14:00',
                style: TextStyle(
                  color: theme.colors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Omnivision.kz',
                style: TextStyle(
                  color: theme.colors.colorText3,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            '900 tg',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: theme.colors.colorText2,
            ),
          ),
        ],
      ),
    );
  }
}
