import 'dart:typed_data';

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
          Colors.white24,
          Colors.white24,
          Colors.white24,
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

Widget customAvatar(Uint8List bytes) {
  return CircleAvatar(
    backgroundColor: Color(GlobalValues.mainGreen),
    radius: 20,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: new Image.memory(
        bytes,
        fit: BoxFit.fill,
        height: 35.0,
        width: 35.0,
      ),
    ),
  );
}
