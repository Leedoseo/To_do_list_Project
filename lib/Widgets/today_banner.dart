import 'package:todolist_project/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDate;
  final int count;

  const TodayBanner({
    required this.selectedDate, // 선택된 날짜
    required this.count, // 일정 개수
    Key? key,
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    final textStyle = TextStyle( // 기본 글꼴 설정
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text( // 년 월 일 형태로 표시
              "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일",
              style: textStyle,
            ),
            Text( // 일정 개수 표시
              "$count개",
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}