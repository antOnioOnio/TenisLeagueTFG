import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';

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
