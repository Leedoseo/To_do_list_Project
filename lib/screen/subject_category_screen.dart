import 'package:todolist_project/Widgets/common_scaffold.dart'; // 햄버거 포함된 공통 스캐폴드
import 'package:shared_preferences/shared_preferences.dart';   // 로컬 저장
import 'package:flutter/material.dart';

class SubjectCategoryScreen extends StatefulWidget {
  const SubjectCategoryScreen({super.key});

  @override
  State<SubjectCategoryScreen> createState() => _SubjectCategoryScreenState();
}

class _SubjectCategoryScreenState extends State<SubjectCategoryScreen> {
  final TextEditingController _controller = TextEditingController(); // 텍스트 입력용
  final List<String> _subjects = []; // 과목 목록

  @override
  void initState() {
    super.initState();
    print("initState 호출 됨!"); // 과목이 저장이 안되서 로그 체크용
    _loadSubjects(); // 앱 실행 시 저장된 과목 불러오기
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies 호출됨!"); // 과목이 저장이 안되서 로그 체크용
    _loadSubjects(); // 화면에 다시 진입할 때마다 SharedPreferences에서 불러옴
  }

  // SharedPreferences에서 과목 목록 불러오기
  Future<void> _loadSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    final loaded = prefs.getStringList("subjects") ?? [];
    print("SharedPreferences에서 불러온 과목들 : $loaded"); // 과목이 저장이 안되서 로그 체크용
    setState(() {
      _subjects.clear();
      _subjects.addAll(prefs.getStringList("subjects") ?? []);
    });
  }

  // SharedPreferences에 과목 목록 저장
  Future<void> _saveSubjects() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("subjects", _subjects);
  }

  // 과목 추가
  void _addSubject() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !_subjects.contains(text)) {
      setState(() {
        _subjects.add(text);
        _controller.clear();
      });
      await _saveSubjects();

      final prefs = await SharedPreferences.getInstance(); // 과목이 저장이 안되서 로그 체크용
      print("💾 저장된 과목 목록: ${prefs.getStringList("subjects")}");
    }
  }

  // 과목 삭제
  void _deleteSubject(String subject) {
    setState(() {
      _subjects.remove(subject);
    });
    _saveSubjects(); // 삭제 후 저장
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "과목 / 카테고리 관리",
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 입력 필드 + 추가 버튼
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "과목 입력",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addSubject(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addSubject,
                  child: const Text("추가"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 과목 리스트
            Expanded(
              child: _subjects.isEmpty
                  ? const Center(child: Text("추가된 과목이 없습니다."))
                  : ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  final subject = _subjects[index];
                  return ListTile(
                    title: Text(subject),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteSubject(subject),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
