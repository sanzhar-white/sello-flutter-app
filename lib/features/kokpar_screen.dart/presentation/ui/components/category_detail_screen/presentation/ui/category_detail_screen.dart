import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';
import 'package:sello/features/home_screen/presentation/ui/components/kokpar_event_card.dart';

class CategoryDetailScreen extends StatelessWidget {
  const CategoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Жақында')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return KokparEventCard(
            kokparEventDto: KokparEventDto(
              id: '',
              title: 'Боз бала 12',
              authorPhoneNumber: '',
              subTitle: 'Атақты батыр, Наурызбай жарысы',
              city: '2024-07-20 19:34:00.000',
              date: '2024-07-20 19:34:00.000',
              region: 'Зертас ауылы',
              prizeFund: 1500000,
              description:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation.',
              isFavorite: false,
              category: '',
              images: [],
            ),
          );
        },
      ),
    );
  }
}
