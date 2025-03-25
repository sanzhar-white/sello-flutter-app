import 'package:flutter/cupertino.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';
import 'package:sello/features/kokpar_screen.dart/presentation/ui/components/event_detail_screen.dart/presentation/ui/event_detail_screen.dart';

class EventDetailScreenFeature extends StatelessWidget {
  final KokparEventDto kokparEventDto;
  const EventDetailScreenFeature({super.key, required this.kokparEventDto});

  @override
  Widget build(BuildContext context) {
    return EventDetailScreen(kokparEventDto: kokparEventDto);
  }
}
