import 'package:todolist_project/Widgets/main_calendar.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget { // StatefulWidget으로 전환
  const CalendarScreen({Key? key}) : super(key: key);

  @override

  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.utc (
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override

  Widget build(BuildContext context) {
    return Scaffold( // 화면 전체에 틀 잡아줌
      body: SafeArea( // 틀 안에 SafeArea로 구역 지정
        child: Column( // 세로 배치
          children: [
            MainCalendar(
              selectedDate: selectedDate, // 선택된 날짜 전달하기
              onDaySelected: onDaySelected, // 날짜가 선택됐을 때 실행할 함수
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selected, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selected;
    });
  }
}