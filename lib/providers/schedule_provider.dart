import 'dart:async';
import 'package:flutter/material.dart';
import '../models/schedule_data.dart';

class ScheduleProvider extends ChangeNotifier {
  Program? _current;
  Timer? _timer;

  ScheduleProvider() {
    _refresh();
    // Re-check at the start of every minute
    final now = DateTime.now();
    final secsUntilNextMinute = 60 - now.second;
    Future.delayed(Duration(seconds: secsUntilNextMinute), () {
      _refresh();
      _timer = Timer.periodic(const Duration(minutes: 1), (_) => _refresh());
    });
  }

  Program? get current => _current;

  void _refresh() {
    final next = currentProgram();
    if (next?.name != _current?.name) {
      _current = next;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
