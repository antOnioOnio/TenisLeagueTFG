import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Messages/Chat/MessageList.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:tenisleague100/services/shared_preferences_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../top_providers.dart';

class MainChat extends StatefulWidget {
  final ModelUserLeague modelUserLeague;
  const MainChat({Key key, @required this.modelUserLeague}) : super(key: key);

  @override
  _MainChatState createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {
  TextEditingController _messageController = new TextEditingController();
  String currentUserId;
  FocusNode _focusMsg = new FocusNode();
  bool _hasFocus = false;
  @override
  void initState() {
    super.initState();
    final sp = context.read<SharedPreferencesService>(sharedPreferencesServiceProvider);
    currentUserId = sp.getCurrentUSerId();
    _focusMsg.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusMsg.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          basicScreenColorChatBg(),
          SafeArea(
            child: Column(
              children: [
                customHeader(),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    decoration: chatBgDecoration(0.5),
                    child: MessageList(currentUserId: currentUserId, userChat: widget.modelUserLeague),
                  ),
                ),
                typingContainer()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget customHeader() {
    Uint8List bytes = base64Decode(widget.modelUserLeague.image);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(color: Colors.green[800]),
              customAvatar(bytes),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text(
                  widget.modelUserLeague.fullName,
                  style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 12),
                ],
              ),
              SizedBox(width: 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget typingContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      width: 350,
      height: 40,
      alignment: Alignment.center,
      decoration: getDecorationWithSelectedOption(_hasFocus),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: _focusMsg,
                controller: _messageController,
                keyboardType: TextInputType.text,
                style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
                decoration: inputDecoration("Escribe algo"),
              ),
            ),
          ],
        ),
        trailing: GestureDetector(
          onTap: sendMessage,
          child: Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Icon(
              Icons.send,
              color: Color(GlobalValues.mainGreen),
              size: 25,
            ),
          ),
        ),
      ),
    );
  }

  void sendMessage() async {
    if (this._messageController.text.isNotEmpty) {
      final database = context.read<Database>(databaseProvider);
      FocusScope.of(context).unfocus();
      database.sendMessage(widget.modelUserLeague.id, this._messageController.text);
      this._messageController.clear();
    } else {
      showAlertDialog(
        context: context,
        title: "¿Qué pretendes enviar?",
        content: "Esto funciona mejor cuando escribes algo",
        defaultActionText: 'OK',
        requiredCallback: false,
      );
    }
  }
}
