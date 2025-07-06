import 'dart:async'; // 비동기 타이머 기능을 위한 내장 패키지
import 'dart:ui'; // FontFeature를 사용하기 위해 추가
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Local알림 패키지
import 'package:todolist_project/Widgets/common_scaffold.dart'; // CommonScaffold 불러오기

// 알림 객체 전역 선언
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final TextEditingController timeController =
  TextEditingController(text: "25:00");

  int totalSeconds = 1500; // 현재 남은 시간 (초 단위)
  int sessionDuration = 0; // 실제 완료된 시간 (통계 저장용)
  int lastInputDuration = 1500; // 세션 전체 시간
  bool isRunning = false;
  late Timer timer;

  // 알림 초기화 (앱 실행시 최초 1회 실행)
  @override
  void initState() {
    super.initState();

    // 안드로이드 초기화 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("@mipmap/ic_launcher");

    // iOS 초기화 설정(권한 요청 포함)
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 플랫폼별 초기화 설정
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // 초기화 실행
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // 알림 띄우는 함수
  Future<void> showNotification() async {
    // 안드로이드 알림 style
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      "timer_channel_id",
      "타이머 알림",
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    // iOS 알림 style
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // 통합 알림 설정
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    // 알림 호출
    await flutterLocalNotificationsPlugin.show(
      0,
      "타이머 종료",
      "설정한 시간이 모두 지났습니다!",
      platformDetails,
    );
  }

  // 1초마다 호출되는 타이머 로직
  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        isRunning = false;
      });
      timer.cancel();
      sessionDuration = lastInputDuration;
      showNotification(); // 알림 호출
    } else {
      setState(() {
        totalSeconds -= 1;
      });
    }
  }

  // MM:SS 문자열 → 초 단위 정수로 변환
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

  // 초 단위 정수 → MM:SS 문자열로 변환
  String formatTime(int seconds) {
    final duration = Duration(seconds: seconds);
    return duration.toString().split(".").first.substring(2, 7);
  }

  // ▶️ 시작 버튼
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

  // ⏸ 일시정지 버튼
  void onPausePressed() {
    if (timer.isActive) timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  // 🔄 리셋 버튼
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

  // 전체 UI
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "집중 타이머",
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 입력창 (타이머 시작 전)
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
            // 원형 타이머 + 시간 표시
              SizedBox(
                width: 350,
                height: 350,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 500,
                      height: 500,
                      child: CircularProgressIndicator(
                        value: totalSeconds / lastInputDuration,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Text(
                      formatTime(totalSeconds),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // 버튼 영역
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
