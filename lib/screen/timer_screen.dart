import 'package:todolist_project/Widgets/common_scaffold.dart';
import 'package:flutter/material.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override

  Widget build(BuildContext context) {
    return CommonScaffold(
      title: '공부 통계',
      body: Center(
        child: Text('공부 통계 화면'),
      ),
    );
  }
}