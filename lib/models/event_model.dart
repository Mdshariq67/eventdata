import 'package:intl/intl.dart';

class Event {
  final String title;
  final DateTime date;
  final String description;

  Event({required this.title, required this.date, required this.description});

  factory Event.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat('yyyy-M-d');
    return Event(
      title: json['title'],
      date: dateFormat.parse(json['date']),
      description: json['description'],
    );
  }
}
