import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Dashboard/Messages/Chat/MessageList.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/database.dart';
import 'package:tenisleague100/services/shared_preferences_service.dart';

import '../../../top_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainChat extends StatefulWidget {
  final ModelUserLeague modelUserLeague;
  const MainChat({Key key, @required this.modelUserLeague}) : super(key: key);

  @override
  _MainChatState createState() => _MainChatState();
}

class _MainChatState extends State<MainChat> {
  TextEditingController _messageController = new TextEditingController();
  String currentUserId;

  @override
  void initState() {
    super.initState();
    final sp = context.read<SharedPreferencesService>(sharedPreferencesServiceProvider);
    currentUserId = sp.getCurrentUSerId();
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
                    decoration: chatBgDecoration(),
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
      /*color: Colors.white,*/
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Escribe algo..',
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, color: Colors.redAccent),
                  gapPadding: 10,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: sendMessage,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(GlobalValues.mainGreen),
              ),
              child: Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
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
