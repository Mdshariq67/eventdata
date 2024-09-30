import 'package:easemydealtask/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventViewModel extends ChangeNotifier {
  List<Event> _allEvents = [];
  List<Event> _events = [];
  bool _isLoading = false;
  String _error = '';
  String _selectedFilter = 'Select Filter';
  String _selectedMonth = 'Select Month';
  String _selectedWeekFilter = 'Select Week';
  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedFilter => _selectedFilter;
  String get selectedMonth => _selectedMonth;
  String get selectedWeekFilter => _selectedWeekFilter;

  Future<void> fetchEvents() async {
    updateFilter('Select Filter');
    _isLoading = true;
    _error = '';
    notifyListeners();

    final url = Uri.parse('https://ixifly.in/flutter/task1');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          final List<dynamic> data = responseData['data'];
          _allEvents = data.map((json) => Event.fromJson(json)).toList();
          _events = List.from(_allEvents);
        } else {
          _error = responseData['message'] ?? 'Unknown error occurred';
        }
      } else {
        _error = 'Failed to fetch data';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void filterBySelectedWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));

    if (_selectedWeekFilter == 'This Week') {
      _events = _allEvents.where((event) {
        DateTime eventDate = DateTime.parse(event.date.toString());
        return eventDate
                .isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            eventDate.isBefore(startOfWeek.add(const Duration(days: 7)));
      }).toList();
    } else if (_selectedWeekFilter == 'Last Week') {
      _events = _allEvents.where((event) {
        DateTime eventDate = DateTime.parse(event.date.toString());
        return eventDate
                .isAfter(startOfLastWeek.subtract(const Duration(days: 1))) &&
            eventDate.isBefore(startOfWeek);
      }).toList();
    } else {
      _events = List.from(_allEvents);
    }

    notifyListeners();
  }

  void updateSelectedWeekFilter(String weekFilter) {
    _selectedWeekFilter = weekFilter;
    filterBySelectedWeek();
    notifyListeners();
  }

  void updateSelectedMonth(String month) {
    _selectedMonth = month;
    filterBySelectedMonth();
    notifyListeners();
  }

  void filterBySelectedMonth() {
    int selectedMonthNumber = _monthToNumber(_selectedMonth);

    _events = _allEvents.where((event) {
      return event.date.month == selectedMonthNumber;
    }).toList();

    notifyListeners();
  }

  int _monthToNumber(String month) {
    const months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };

    return months[month] ?? 1;
  }

  void filterByWeek() {
    DateTime startOfWeek(DateTime date) {
      return date.subtract(Duration(days: date.weekday - 1));
    }

    _events = List.from(_allEvents);
    _events.sort((a, b) {
      final startOfWeekA = startOfWeek(a.date);
      final startOfWeekB = startOfWeek(b.date);
      return startOfWeekA.compareTo(startOfWeekB);
    });

    notifyListeners();
  }

  void filterByDate() {
    _events = List.from(_allEvents);
    _events.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }
}
