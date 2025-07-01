import 'dart:async'; // 비동기 타이머 기능을 위한 내장 패키지
import 'package:flutter/material.dart';
import 'dart:ui'; // FontFeature를 사용하기 위해 추가

// 타이머 기능이 포함된 화면 (Stateful)
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  // 사용자 입력을 위한 컨트롤러 (기본값: 25분 → 25:00 형식)
  final TextEditingController timeController = TextEditingController(text: "25:00");

  int totalSeconds = 1500; // 현재 남은 시간 (초 단위)
  int sessionDuration = 0; // 이번 세션에서 실제로 완료된 시간 (초 단위, 통계 저장용)
  int lastInputDuration = 1500; // 사용자가 입력한 세션 전체 시간 (초), UI 초기화용
  bool isRunning = false; // 타이머 실행 중인지 여부
  late Timer timer; // Dart 내장 타이머 객체

  // 타이머가 매 초마다 호출되는 함수
  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      // 시간이 다 되었을 때 처리
      setState(() {
        isRunning = false;
      });
      timer.cancel();

      // 세션 종료 시 총 시간 기록
      sessionDuration = lastInputDuration;
      // sessionDuration을 통계 저장소에 누적 (SharedPreferences 등)
    } else {
      // 아직 시간이 남아 있으면 1초 감소
      setState(() {
        totalSeconds -= 1;
      });
    }
  }

  // "MM:SS" 형식 문자열을 초 단위(int)로 변환
  int parseTime(String input) {
    try {
      final parts = input.split(":");
      final minutes = int.parse(parts[0]);
      final seconds = parts.length > 1 ? int.parse(parts[1]) : 0;
      return minutes * 60 + seconds;
    } catch (e) {
      return -1;
    }
  }

  // 초 단위를 "MM:SS" 형식 문자열로 변환
  String formatTime(int seconds) {
    final duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  // 타이머 시작 버튼
  void onStartPressed() {
    // 처음 시작하는 경우
    if (!isRunning && totalSeconds == lastInputDuration) {
      final seconds = parseTime(timeController.text);
      if (seconds <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("MM:SS 형식으로 입력해주세요.")),
        );
        return;
      }
      setState(() {
        lastInputDuration = seconds;
        totalSeconds = seconds;
        isRunning = true;
      });
      timer = Timer.periodic(const Duration(seconds: 1), onTick);
      return;
    }

    // 일시정지 후 다시 시작
    if (!isRunning && totalSeconds > 0) {
      setState(() {
        isRunning = true;
      });
      timer = Timer.periodic(const Duration(seconds: 1), onTick);
    }
  }

  // 타이머 일시정지 버튼
  void onPausePressed() {
    if (timer.isActive) timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  // 타이머 초기화 버튼
  void onRestartPressed() {
    if (timer.isActive) timer.cancel();
    setState(() {
      isRunning = false;
      lastInputDuration = parseTime(timeController.text); // 입력값을 다시 파싱해 저장
      totalSeconds = lastInputDuration;
      timeController.text = formatTime(lastInputDuration);
    });
  }

  // 위젯 해제 시 컨트롤러도 메모리에서 정리
  @override
  void dispose() {
    timeController.dispose();
    super.dispose();
  }

  // 전체 UI 구성
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 입력창 또는 디지털 시계
            if (!isRunning && totalSeconds == lastInputDuration)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: timeController,
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'MM:SS',
                  ),
                ),
              )
            else
              Text(
                formatTime(totalSeconds),
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  fontFeatures: [FontFeature.tabularFigures()],
                  letterSpacing: 2,
                ),
              ),
            // 버튼 영역
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: isRunning ? onPausePressed : onStartPressed,
                  iconSize: 80,
                  icon: Icon(isRunning ? Icons.pause_circle : Icons.play_circle),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: onRestartPressed,
                  iconSize: 60,
                  icon: const Icon(Icons.restart_alt),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
