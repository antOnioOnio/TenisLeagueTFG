import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';

import 'helpDecorations.dart';

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

Widget customAvatarBigger(Uint8List bytes) {
  return CircleAvatar(
    backgroundColor: Color(GlobalValues.mainGreen),
    radius: 43,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: new Image.memory(
        bytes,
        fit: BoxFit.fill,
        height: 80,
        width: 80,
      ),
    ),
  );
}

Widget customAvatar(Uint8List bytes) {
  return CircleAvatar(
    backgroundColor: Color(GlobalValues.mainGreen),
    radius: 20,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(33),
      child: new Image.memory(
        bytes,
        fit: BoxFit.fill,
        height: 37.0,
        width: 37.0,
      ),
    ),
  );
}

Widget headerTabBar(BuildContext context) {
  return Container(
    decoration: containerChatSelection(),
    height: 40,
    width: MediaQuery.of(context).size.width,
    child: TabBar(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: Color(GlobalValues.mainGreen)),
        insets: EdgeInsets.symmetric(horizontal: 16.0),
      ),
      labelColor: Color(GlobalValues.mainGreen),
      unselectedLabelColor: Colors.grey,
      tabs: [
        Tab(
          text: "Principiante",
        ),
        Tab(
          text: "Medio",
        ),
        Tab(
          text: "Avanzado",
        ),
      ],
    ),
  );
}

