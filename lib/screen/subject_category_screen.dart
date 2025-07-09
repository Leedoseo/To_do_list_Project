import 'package:todolist_project/Widgets/common_scaffold.dart';
import 'package:flutter/material.dart';

class SubjectCategoryScreen extends StatefulWidget {
  const SubjectCategoryScreen({super.key});
  
  @override
  
  State<SubjectCategoryScreen> createState() => _SubjectCategoryScreenState();
}

class _SubjectCategoryScreenState extends State<SubjectCategoryScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _subjects = [];
  
  void _addSubject() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !_subjects.contains(text)) {
      setState(() {
        _subjects.add(text);
        _controller.clear();
      });
    }
  }
  
  void _deleteSubject(String subject) {
    setState(() {
      _subjects.remove(subject);
    });
  }
  
  @override
  
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: "과목 / 카테고리 관리",
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 입력 필드
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
            
            // 리스트 표시
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
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteSubject(subject),
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}