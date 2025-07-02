import 'dart:async'; // 비동기 타이머 기능을 위한 내장 패키지
import 'dart:ui'; // FontFeature를 사용하기 위해 추가
import 'package:todolist_project/Widgets/common_scaffold.dart'; // CommonScaffold 불러오기
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final TextEditingController timeController = TextEditingController(text: "25:00");

  int totalSeconds = 1500; // 현재 남은 시간 (초 단위)
  int sessionDuration = 0; // 실제 완료된 시간 (통계 저장용)
  int lastInputDuration = 1500; // 세션 전체 시간
  bool isRunning = false;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        isRunning = false;
      });
      timer.cancel();

      sessionDuration = lastInputDuration;
      // sessionDuration 저장 로직 (예: SharedPreferences)
    } else {
      setState(() {
        totalSeconds -= 1;
      });
    }
  }

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

  String formatTime(int seconds) {
    final duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  void onStartPressed() {
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

    if (!isRunning && totalSeconds > 0) {
      setState(() {
        isRunning = true;
      });
      timer = Timer.periodic(const Duration(seconds: 1), onTick);
    }
  }

  void onPausePressed() {
    if (timer.isActive) timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onRestartPressed() {
    if (timer.isActive) timer.cancel();
    setState(() {
      isRunning = false;
      lastInputDuration = parseTime(timeController.text);
      totalSeconds = lastInputDuration;
      timeController.text = formatTime(lastInputDuration);
    });
  }

  @override
  void dispose() {
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "집중 타이머",
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          ],
        ),
      ),
    );
  }
}
