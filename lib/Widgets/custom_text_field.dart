import 'package:todolist_project/constants/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label; // 텍스트 필드 제목
  final bool isTime; // 시간 선택하는 텍스트 필드인지 여부 파악

  const CustomTextField({
    required this.label,
    required this.isTime,
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
        Expanded(
          flex: isTime ? 0 : 1,
          child: TextFormField(
            cursorColor: Colors.grey, // 커서 색상 변경
            maxLines: isTime ? 1 : null, // 시간 관련 텍스트 필드가 아니면 한 줄 이상 작성 가능
            expands: !isTime, // 시간 관련 텍스트 필드는 공간 최대 차지
            keyboardType: isTime ? TextInputType.number : TextInputType.multiline, // 시간 관련 텍스트 필드는 기본 숫자 키보드 아니면 일반 글자 키보드 보여주기
            inputFormatters: isTime ? [
              FilteringTextInputFormatter.digitsOnly,
            ] : [], // 시간 관련 텍스트 필드는 숫자만 입력하도록 제한
            decoration: InputDecoration(
              border: InputBorder.none, // 테두리 삭제
              filled: true, // 배경색을 지정하겠다는 선언
              fillColor: Colors.grey[300], // 배경색
              suffixText: isTime ? "시" : null, // 시간 관련 텍스트 필드는 "시" 접미사 추가
            ),
          ),
        ),
      ],
    );
  }
}