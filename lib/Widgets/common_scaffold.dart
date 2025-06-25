import 'package:flutter/material.dart';

class CommonScaffold extends StatelessWidget {
  final Widget body;
  final String? title;

  const CommonScaffold({
    super.key,
    required this.body,
    this.title,
  });

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title != null ? Text(title!) : null,
      ),
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
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != "/category") {
                  Navigator.pushReplacementNamed(context, "/category");
                }
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
      body: body,
    );
  }
}