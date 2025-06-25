import 'package:flutter/material.dart';
import 'package:todolist_project/Widgets/common_scaffold.dart';
import 'package:todolist_project/widgets/main_calendar.dart';
import 'package:todolist_project/widgets/schedule_card.dart';
import 'package:todolist_project/widgets/schedule_bottom_sheet.dart';
import 'package:todolist_project/widgets/today_banner.dart';
import 'package:todolist_project/constants/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: '캘린더',
      body: SafeArea(
        child: Column(
          children: [
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: onDaySelected,
            ),
            const SizedBox(height: 8),
            TodayBanner(
              selectedDate: selectedDate,
              count: 0,
            ),
            const SizedBox(height: 8),
            const ScheduleCard(
              startTime: 12,
              endTime: 12,
              content: '플러터 공부',
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selected, DateTime _) {
    setState(() => selectedDate = selected);
  }
}