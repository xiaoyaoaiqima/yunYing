
import 'dart:collection';

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}


LinkedHashMap<DateTime, List<String>> createEventsMap(
    bool Function(DateTime, DateTime) equals,
    int Function(DateTime) hashCode,
    Map<DateTime, List<String>> source) {
  return LinkedHashMap<DateTime, List<String>>(
    equals: equals,
    hashCode: hashCode,
  )..addAll(source);
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);