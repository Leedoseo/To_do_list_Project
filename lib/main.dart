import 'package:todolist_project/screen/calendar_screen.dart';
import 'package:todolist_project/screen/timer_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 플러터 프레임워크가 준비될 때까지 대기

  await initializeDateFormatting(); // intl 패키지 초기화(다국어화)

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/calendar",
      routes: {
        "/calendar" : (context) => const CalendarScreen(),
        "/timer" : (context) => const TimerScreen(),
      },
    )
  );
}