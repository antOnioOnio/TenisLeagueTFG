import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/top_providers.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:tenisleague100/services/GlobalValues.dart';
import 'package:tenisleague100/services/shared_preferences_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Chat/MainChat.dart';

// https://github.com/JohannesMilke/firebase_chat_example
class Chats extends StatefulWidget {
  //const ChatsPage({Key key, this.users}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  TextEditingController searchFieldController = new TextEditingController();
  List<ModelUserLeague> _filteredUsers, _everyUser;
  String _currentUserId;
  bool _isLoading;
  Stream stream;
  @override
  void initState() {
    super.initState();
    getCurrentUserId();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          basicScreenColor(),
          SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  customSearchField(),
                  mainListUsers(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget mainListUsers() {
    return _isLoading
        ? circularLoadingBar()
        : Container(
            padding: EdgeInsets.all(10),
            constraints: BoxConstraints(maxHeight: 400),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return userRow(user);
              },
            ),
          );
  }

  Widget userRow(ModelUserLeague user) {
    Uint8List bytes = base64Decode(user.image);
    return Visibility(
      visible: user.id == _currentUserId ? false : true,
      child: Container(
        height: 60,
        decoration: containerChatSelection(),
        margin: EdgeInsets.only(bottom: 5),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MainChat(
                  modelUserLeague: user,
                  currentUserid: _currentUserId,
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: Color(GlobalValues.mainGreen),
            radius: 20,
            child: customAvatar(bytes),
          ),
          title: Text(user.fullName),
        ),
      ),
    );
  }

  Widget customSearchField() {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: getDecorationWithSelectedOption(false),
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Icon(Icons.search),
              ),
              title: TextFormField(
                obscureText: false,
                controller: this.searchFieldController,
                keyboardType: TextInputType.text,
                style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
                decoration: inputDecoration("Buscar.."),
                onChanged: (string) {
                  if (string.isNotEmpty) {
                    setState(() {
                      _filteredUsers = _filteredUsers.where((element) {
                        if (element.fullName != null) {
                          return element.fullName.toLowerCase().contains(string);
                        }
                        return true;
                      }).toList();
                    });
                  } else {
                    setState(() {
                      _filteredUsers = _everyUser;
                    });
                  }
                },
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }

  void getCurrentUserId() async {
    final sp = context.read<SharedPreferencesService>(sharedPreferencesServiceProvider);
    _currentUserId = await sp.getCurrentUSerId();
  }

  void getUsers() async {
    print("geUsers called");
    final database = context.read<Database>(databaseProvider);
    setState(() {
      _isLoading = true;
    });
    _everyUser = await database.getUserCollection();
    _filteredUsers = _everyUser;
    setState(() {
      _isLoading = false;
    });
  }
}
