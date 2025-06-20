import 'package:todolist_project/Widgets/custom_text_field.dart';
import 'package:todolist_project/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({Key? key}) : super(key: key);

  @override

  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {

  @override

  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        color: Colors.white,
        child: Padding( //
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Column( // 시간 관련 텍스트 필드와 내용 관련 텍스트 필드 세로로 배치
            children: [
              Row( // 시작 시간 종료 시간 가로로 배치
                children: [
                  Expanded(
                    child: CustomTextField( // 시작 시간 입력 필드
                        label: "시작 시간",
                        isTime: true, // 시간을 입력 받음 -> custom_text_field에서 required this.isTime으로 선언 했기 때문에 isTime에 대한 true or false를 적어줘야함
                    ),
                  ),
                  const SizedBox(width: 16.0), 
                  Expanded(
                    child: CustomTextField( // 종료 시간 입력 필드
                        label: "종료 시간",
                        isTime: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: CustomTextField( // 내용 입력 필드
                    label: "내용", 
                    isTime: false, // 시간을 입력 받지 않음
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton( // 저장 버튼
                  onPressed: onSavePressed,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: PRIMARY_COLOR,
                  ),
                  child: Text("저장"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSavePressed(){

  }
}