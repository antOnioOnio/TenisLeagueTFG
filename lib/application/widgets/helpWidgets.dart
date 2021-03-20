
import 'package:flutter/material.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';

Widget basicScreenColor() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFFFFFFF),
          Color(0xFFFFFFFF),
        ],
        stops: [0.3, 0.6, 0.9],
      ),
    ),
  );
}

Widget circularLoadingBar() {
  return Container(
    child: Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(
          Color(GlobalValues.mainTextColor),
        ),
      ),
    ),
  );
}
