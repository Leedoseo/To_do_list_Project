import 'dart:async'; // 비동기 타이머 기능을 위한 내장 패키지
import 'package:flutter/material.dart';

// 타이머 기능이 포함된 화면 (Stateful)
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // 사용자 입력을 위한 컨트롤러 (초기값: 25분)
  final TextEditingController timeController = TextEditingController(text: "25");

  int totalSeconds = 1500; // 현재 남은 시간 (초 단위)
  bool isRunning = false; // 타이머 실행 중인지 여부
  int sessionDuration = 0; // 이번 세션의 총 시간 (초)
  late Timer timer; // Dart 내장 타이머 객체

  // 타이머가 매 초마다 호출되는 함수
  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      // 시간이 다 되었을 때 처리
      setState(() {
        isRunning = false;
      });
      timer.cancel();

      // 이 곳에 알림 또는 통계 저장 코드 추가 예정
    } else {
      // 아직 시간이 남아 있으면 1초 감소
      setState(() {
        totalSeconds -= 1;
      });
    }
  }

  // 타이머 시작
  void onStartPressed() {
    final enteredMinutes = int.tryParse(timeController.text);

    if (enteredMinutes == null || enteredMinutes <= 0) {
      // 입력 오류 시 안내 메시지
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("유효한 분 단위 시간을 입력해주세요.")),
      );
      return;
    }

    setState(() {
      sessionDuration = enteredMinutes * 60;
      totalSeconds = sessionDuration;
      isRunning = true;
    });

    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
  }

  // 타이머 일시정지
  void onPausePressed() {
    timer.cancel();

    final enteredMinutes = int.tryParse(timeController.text) ?? 25;

    setState(() {
      isRunning = false;
      sessionDuration = enteredMinutes * 60;
      totalSeconds = sessionDuration;
    });
  }

  // 타이머 초기화
  void onReStartPressed() {
    if (timer.isActive) timer.cancel();

    final enteredMinutes = int.tryParse(timeController.text) ?? 25;

    setState(() {
      isRunning = false;
      sessionDuration = enteredMinutes * 60;
      totalSeconds = sessionDuration;
    });
  }

  // 초 단위를 MM:SS 형식으로 포맷
  String format(int seconds) {
    final duration = Duration(seconds: seconds);
    return duration
        .toString()
        .split(".")
        .first
        .substring(2, 7); // "25:00" 형식
  }

  // 컨트롤러 해제
  @override
  void dispose() {
    timeController.dispose();
    super.dispose();
  }

  // 화면 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Text('DEBUG: isRunning = $isRunning, seconds = $totalSeconds'), // 디버그용
            // 입력 필드 (실행 중이 아닐 때만 표시)
            if (!isRunning)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextField(
                  controller: timeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: "집중 시간(분)",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

            // 타이머 텍스트 (남은 시간 표시)
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  format(totalSeconds),
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // 시작 / 일시정지 / 초기화 버튼
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: isRunning ? onPausePressed : onStartPressed,
                    iconSize: 120,
                    color: Colors.black,
                    icon: Icon(
                      isRunning
                          ? Icons.pause_circle_outline
                          : Icons.play_circle_outline,
                    ),
                  ),
                  IconButton(
                    onPressed: onReStartPressed,
                    iconSize: 50,
                    color: Colors.black,
                    icon: const Icon(Icons.restart_alt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
