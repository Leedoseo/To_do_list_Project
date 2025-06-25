import 'package:todolist_project/Widgets/schedule_card.dart';
import 'package:todolist_project/Widgets/main_calendar.dart';
import 'package:todolist_project/Widgets/today_banner.dart';
import 'package:todolist_project/Widgets/schedule_bottom_sheet.dart';
import 'package:todolist_project/constants/app_colors.dart';
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
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text("유저명"),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text("캘린더"),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.timer),
              title: const Text("집중 타이머"),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: const Text("공부 통계"),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: const Text("과목/카테고리 관리"),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.edit_note),
              title: const Text("목표"),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: const Text("테마 설정"),
              onTap: () {
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text("앱 설정"),
              onTap: () {
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton( // 새 일정 버튼
        backgroundColor: PRIMARY_COLOR,
          onPressed: () {
            showModalBottomSheet( // BottomSheet 열기(모달 창)
              context: context,
              isDismissible: true, // 배경을 탭했을 때 BottomSheet 닫기
              builder: (_) => ScheduleBottomSheet(),
              isScrollControlled: true, // BottomSheeet의 높이를 화면의 최대 높으로 정의하고 스크롤 가능하게 변경
            );
          },
        child: Icon( // + 모양의 버튼으로 설정
          Icons.add,
        ),
      ),
      body: SafeArea( // 틀 안에 SafeArea로 구역 지정
        child: Column( // 세로 배치
          children: [
            MainCalendar(
              selectedDate: selectedDate, // 선택된 날짜 전달하기
              onDaySelected: onDaySelected, // 날짜가 선택됐을 때 실행할 함수
            ),
            SizedBox(height: 8.0),
            TodayBanner(
                selectedDate: selectedDate,
                count: 0,
            ),
            SizedBox(height: 8.0),
            ScheduleCard( // 일정 더미 데이터 삽입
                startTime: 12,
                endTime: 12,
                content: "플러터 공부",
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