import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/database.dart';

import '../../top_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat.dart';

// https://github.com/JohannesMilke/firebase_chat_example
class Chats extends StatefulWidget {
  //const ChatsPage({Key key, this.users}) : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  TextEditingController searchFieldController = new TextEditingController();
  List<ModelUserLeague> _filteredUsers, _everyUser;
  bool _isLoading;
  Stream stream;
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    final database = context.read<Database>(databaseProvider);
    setState(() {
      _isLoading = true;
    });
    _everyUser = await database.getUserCollection();
    _filteredUsers = _everyUser;
    setState(() {
      _isLoading = false;
    });
    print("filteredUsers size===> " + _filteredUsers.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    final database = context.read<Database>(databaseProvider);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
            )),
          )
        ],
      ),
    );
  }

  Widget mainListUsers() {
    return _isLoading
        ? circularLoadingBar()
        : Container(
            constraints: BoxConstraints(maxHeight: 400),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return Container(
                  height: 75,
                  width: 100,
                  color: Color(GlobalValues.mainGreen),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Chat(modelUserLeague: user),
                        ),
                      );
                    },
                    /*       leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(user.urlAvatar),
              ),*/
                    title: Text(user.fullName),
                  ),
                );
              },
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
}
