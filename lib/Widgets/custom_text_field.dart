import 'package:todolist_project/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;

  const CustomTextField({
    required this.label,
    Key? key,
  }) : super(key: key);

  @override

  Widget build(BuildContext context) {
    return Column( // 세로로 텍스트와 텍스트 필드 배치
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextFormField(), // 폼 안에서 텍스트 필드를 쓸 때 사용
      ],
    );
  }
}