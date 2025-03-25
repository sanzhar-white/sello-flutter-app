import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sello/features/home_screen/data/models/kokpar_event_dto.dart';

class KokparEventsList {
  final List<KokparEventDto> kokparEventsList;

  KokparEventsList({required this.kokparEventsList});

  KokparEventsList copyWith({List<KokparEventDto>? kokparEventsList}) {
    return KokparEventsList(
      kokparEventsList: kokparEventsList ?? this.kokparEventsList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'kokparEventsList': kokparEventsList.map((x) => x.toMap()).toList(),
    };
  }

  factory KokparEventsList.fromMap(Map<String, dynamic> map) {
    return KokparEventsList(
      kokparEventsList: List<KokparEventDto>.from(
        (map['kokparEventsList'] as List<dynamic>).map<KokparEventDto>(
          (x) => KokparEventDto.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory KokparEventsList.fromJson(String source) =>
      KokparEventsList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'KokparEventsList(kokparEventsList: $kokparEventsList)';

  @override
  bool operator ==(covariant KokparEventsList other) {
    if (identical(this, other)) return true;

    return listEquals(other.kokparEventsList, kokparEventsList);
  }

  @override
  int get hashCode => kokparEventsList.hashCode;
}
