import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';

Widget basicScreenColorChatBg() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.grey[100],
          Colors.grey[100],
          Colors.grey[100],
        ],
        stops: [0.3, 0.6, 0.9],
      ),
    ),
  );
}

BoxDecoration getDecorationWithSelectedOption(bool selected) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      width: 1,
      color: selected ? Colors.redAccent[400] : Color(GlobalValues.mainTextColorHint),
    ),
  );
}

InputDecoration inputDecoration(String hint) {
  return InputDecoration(
      errorStyle: TextStyle(height: 0),
      border: InputBorder.none,
      contentPadding: EdgeInsets.only(bottom: 25),
      hintStyle: GoogleFonts.raleway(color: Color(GlobalValues.mainTextColorHint), fontWeight: FontWeight.normal, fontSize: 14),
      hintText: hint);
}

BoxDecoration containerChatSelection() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      width: 1,
      color: Color(GlobalValues.mainTextColorHint),
    ),
  );
}

BoxDecoration messageDecoration(bool isMe) {
  return BoxDecoration(
    color: isMe ? Colors.grey[100] : Color(GlobalValues.mainGreen),
    borderRadius: isMe
        ? BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10), topRight: Radius.circular(10))
        : BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(10), topRight: Radius.circular(10)),
/*      border: Border.all(
        width: 1,
        color: Color(GlobalValues.mainTextColorHint),
      )*/
  );
}

BoxDecoration chatBgDecoration() {
  return BoxDecoration(
    color: Colors.white,
    border: Border.all(
      width: 2,
      color: Color(GlobalValues.mainGreen),
    ),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ),
  );
}
