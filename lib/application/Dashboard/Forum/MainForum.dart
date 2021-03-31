import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../top_providers.dart';

class MainForum extends StatefulWidget {
  @override
  _MainForumState createState() => _MainForumState();
}

class _MainForumState extends State<MainForum> {
  ModelUserLeague _currentUser;
  Uint8List _bytesImage;
  bool _isLoading;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    setState(() {
      _isLoading = true;
    });
    final database = context.read<Database>(databaseProvider);
    _currentUser = await database.getCurrentUser();
    _bytesImage = base64Decode(_currentUser.image);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          basicScreenColorChatBg(),
          SafeArea(
            child: _isLoading
                ? circularLoadingBar()
                : Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "TENIS 100",
                          style: GoogleFonts.sairaExtraCondensed(color: Color(GlobalValues.mainGreen), fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: chatBgDecoration(0.5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                CircleAvatar(
                                  backgroundColor: Color(GlobalValues.mainGreen),
                                  radius: 20,
                                  child: customAvatar(_bytesImage),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "¿Qué quieres publicar?",
                                  style:
                                      GoogleFonts.raleway(color: Color(GlobalValues.mainTextColorHint), fontWeight: FontWeight.normal, fontSize: 15),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: decorationModule8(),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
