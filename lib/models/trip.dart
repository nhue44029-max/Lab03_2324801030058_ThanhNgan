import 'package:flutter/widgets.dart';

import 'destination.dart';

class Trip {
  const Trip({
    required this.name,
    required this.destination,
    required this.days,
    required this.nights,
    required this.people,
    required this.budget,
    required this.bookingSubtotal,
    required this.serviceFee,
    required this.discount,
  });

  final String name;
  final Destination destination;
  final int days;
  final int nights;
  final int people;
  final int budget;
  final int bookingSubtotal;
  final int serviceFee;
  final int discount;

  int get totalPayment => bookingSubtotal + serviceFee - discount;
}

class ScheduleActivity {
  const ScheduleActivity({
    required this.day,
    required this.time,
    required this.title,
    required this.detail,
    required this.icon,
  });

  final int day;
  final String time;
  final String title;
  final String detail;
  final IconData icon;

  ScheduleActivity copyWith({
    int? day,
    String? time,
    String? title,
    String? detail,
    IconData? icon,
  }) {
    return ScheduleActivity(
      day: day ?? this.day,
      time: time ?? this.time,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      icon: icon ?? this.icon,
    );
  }
}
