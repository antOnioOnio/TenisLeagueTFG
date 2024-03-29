import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Auth/validators.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/services/GlobalValues.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelPost.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';

import '../top_providers.dart';

class AddResultDialog extends StatefulWidget {
  final ModelMatch match;
  final ModelUserLeague user1;
  final ModelUserLeague user2;
  final bool tournament;
  final Function callback;
  const AddResultDialog({Key key, @required this.match, @required this.user1, @required this.user2, @required this.tournament, this.callback})
      : super(key: key);
  @override
  _AddResultDialogState createState() => _AddResultDialogState();
}

class _AddResultDialogState extends State<AddResultDialog> {
  String _dropdownValueUser1Set1 = "0";
  String _dropdownValueUser1Set2 = "0";
  String _dropdownValueUser1Set3 = "0";
  String _dropdownValueUser2Set1 = "0";
  String _dropdownValueUser2Set2 = "0";
  String _dropdownValueUser2Set3 = "0";

  String idWinnerSet1 = "";
  String idWinnerSet2 = "";
  String idWinnerSet3 = "";

  TextEditingController placeTextController = new TextEditingController();
  List<String> valuesSet = ["0", "1", "2", "3", "4", "5", "6", "7"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: mainContent(context),
    );
  }

  Widget mainContent(context) {
    Uint8List bytesUser1 = base64Decode(widget.user1.image);
    Uint8List bytesUser2 = base64Decode(widget.user2.image);
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            margin: EdgeInsets.only(top: 20),
            decoration: decorationDialogAdd(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(flex: 4, child: customAvatar(bytesUser1)),
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.user1.fullName,
                        style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    VerticalDivider(
                      color: Color(
                        GlobalValues.blackText,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          widget.user2.fullName,
                          style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                    Expanded(flex: 4, child: customAvatar(bytesUser2)),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                columnSet("1", 1, 2),
                columnSet("2", 3, 4),
                columnSet("3", 5, 6),
                buttonsRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buttonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancelar",
            style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        TextButton(
          onPressed: () {
            updateMatch(widget.match);
          },
          child: Text(
            "Guardar",
            style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        )
      ],
    );
  }

  Widget columnSet(String set, int setUser1, int setUser2) {
    return Column(
      children: [
        Text(
          "SET " + set,
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: getOpacity(set, 1),
              duration: Duration(milliseconds: 300),
              child: Icon(
                Icons.check,
                size: 20,
                color: Color(GlobalValues.mainGreen),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            dropDownPlaces(setUser1),
            SizedBox(
              width: 30,
            ),
            dropDownPlaces(setUser2),
            SizedBox(
              width: 20,
            ),
            AnimatedOpacity(
              opacity: getOpacity(set, 2),
              duration: Duration(milliseconds: 300),
              child: Icon(
                Icons.check,
                size: 20,
                color: Color(GlobalValues.mainGreen),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget dropDownPlaces(int set) {
    return new Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.green[400],
      ),
      child: DropdownButton<String>(
        value: getValue(set),
        iconSize: 0,
        elevation: 16,
        style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.bold, fontSize: 14),
        underline: Container(
          height: 0,
        ),
        onChanged: (String newValue) {
          setValueDropDown(newValue, set);
        },
        items: valuesSet.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value.toString(),
              style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
            ),
          );
        }).toList(),
      ),
    );
  }

  void updateMatch(ModelMatch match) async {
    final database = context.read<Database>(databaseProvider);

    String idPlayerWinner = getWinner();
    String nameUserWinner = idPlayerWinner == widget.user1.id ? widget.user1.fullName : widget.user2.fullName;
    String nameUserLoser = idPlayerWinner == widget.user1.id ? widget.user2.fullName : widget.user1.fullName;
    if (idPlayerWinner != "") {
      String resultSet1 = _dropdownValueUser1Set1 + "-" + _dropdownValueUser2Set1;
      String resultSet2 = _dropdownValueUser1Set2 + "-" + _dropdownValueUser2Set2;
      String resultSet3 = _dropdownValueUser1Set3 + "-" + _dropdownValueUser2Set3;
      match = match.copyWith(idPlayerWinner, resultSet1, resultSet2, resultSet3, new DateTime.now());
      if (widget.tournament) {
        await database.sendMatchTournament(match);
        widget.callback(match);
      } else {
        await database.sendMatch(match);
        await updatePlayers(idPlayerWinner);
      }
      Navigator.of(context).pop();

      await database.sendPost(new ModelPost(
          id: generateUuid(),
          idUser: idPlayerWinner,
          nameOfUser: nameUserWinner,
          content: nameUserWinner + " ha ganado a " + nameUserLoser + " por " + resultSet1 + " " + resultSet2 + " " + resultSet3,
          imageUser: null,
          postType: ModelPost.matchResult,
          createdAt: DateTime.now()));

    } else {
      showAlertDialog(
        context: context,
        title: 'Contenido mal rellenado',
        content: "No hay ganador aún, rellena bien los sets..",
        defaultActionText: 'OK',
        requiredCallback: false,
      );
    }
  }

  Future<void> updatePlayers(String idWinner) async {
    final database = context.read<Database>(databaseProvider);
    if (idWinner == widget.user1.id) {
      ModelUserLeague userWinner = widget.user1.copyWithOneMoreMatch(true);
      await database.setUser(userWinner);
      ModelUserLeague userLosser = widget.user2.copyWithOneMoreMatch(false);
      await database.setUser(userLosser);
    } else {
      ModelUserLeague userWinner = widget.user2.copyWithOneMoreMatch(true);
      await database.setUser(userWinner);
      ModelUserLeague userLosser = widget.user1.copyWithOneMoreMatch(false);
      await database.setUser(userLosser);
    }
    return;
  }

  String getWinner() {
    if (idWinnerSet1 == idWinnerSet2 || idWinnerSet1 == idWinnerSet3) {
      return idWinnerSet1;
    }
    if (idWinnerSet2 == idWinnerSet3) {
      return idWinnerSet2;
    } else {
      return "";
    }
  }

  double getOpacity(String set, int user) {
    if (set == "1") {
      if (user == 1) {
        if (this.idWinnerSet1 == widget.user1.id) {
          return 1;
        }
      } else if (user == 2) {
        if (this.idWinnerSet1 == widget.user2.id) {
          return 1;
        }
      }
    }
    if (set == "2") {
      if (user == 1) {
        if (this.idWinnerSet2 == widget.user1.id) {
          return 1;
        }
      } else if (user == 2) {
        if (this.idWinnerSet2 == widget.user2.id) {
          return 1;
        }
      }
    }
    if (set == "3") {
      if (user == 1) {
        if (this.idWinnerSet3 == widget.user1.id) {
          return 1;
        }
      } else if (user == 2) {
        if (this.idWinnerSet3 == widget.user2.id) {
          return 1;
        }
      }
    }
    return 0;
  }

  void setValueDropDown(String newValue, int i) {
    switch (i) {
      case 1:
        setState(() {
          _dropdownValueUser1Set1 = newValue;
        });
        validationScore(_dropdownValueUser1Set1, _dropdownValueUser2Set1, 1);
        break;
      case 2:
        setState(() {
          _dropdownValueUser2Set1 = newValue;
        });
        validationScore(_dropdownValueUser1Set1, _dropdownValueUser2Set1, 1);
        break;
      case 3:
        setState(() {
          _dropdownValueUser1Set2 = newValue;
        });
        validationScore(_dropdownValueUser1Set2, _dropdownValueUser2Set2, 2);
        break;
      case 4:
        setState(() {
          _dropdownValueUser2Set2 = newValue;
        });
        validationScore(_dropdownValueUser1Set2, _dropdownValueUser2Set2, 2);
        break;
      case 5:
        setState(() {
          _dropdownValueUser1Set3 = newValue;
        });
        validationScore(_dropdownValueUser1Set3, _dropdownValueUser2Set3, 3);
        break;
      case 6:
        setState(() {
          _dropdownValueUser2Set3 = newValue;
        });
        validationScore(_dropdownValueUser1Set3, _dropdownValueUser2Set3, 3);
        break;
    }
  }

  void validationScore(String user1Result, String user2Result, int set) {
    print('validationScore');
    String resultToValidate = user1Result + user2Result;
    if (ValidateMatchResult.validateWinUser1(resultToValidate)) {
      setWinner(set, 1);
    } else if (ValidateMatchResult.validateWinUser2(resultToValidate)) {
      setWinner(set, 2);
    } else {
      setWinnerNull(set);
    }
  }

  void setWinnerNull(int set) {
    print("setWinnerNull");
    switch (set) {
      case 1:
        setState(() {
          this.idWinnerSet1 = "";
        });
        break;
      case 2:
        setState(() {
          this.idWinnerSet2 = "";
        });
        break;
      case 3:
        setState(() {
          this.idWinnerSet3 = "";
        });
        break;
    }
  }

  void setWinner(int set, int user) {
    print("set winner called with ");
    switch (set) {
      case 1:
        if (user == 1) {
          setState(() {
            this.idWinnerSet1 = this.widget.user1.id;
          });
        } else if (user == 2) {
          setState(() {
            this.idWinnerSet1 = this.widget.user2.id;
          });
        }
        break;
      case 2:
        if (user == 1) {
          setState(() {
            this.idWinnerSet2 = this.widget.user1.id;
          });
        } else if (user == 2) {
          setState(() {
            this.idWinnerSet2 = this.widget.user2.id;
          });
        }
        break;
      case 3:
        if (user == 1) {
          setState(() {
            this.idWinnerSet3 = this.widget.user1.id;
          });
        } else if (user == 2) {
          setState(() {
            this.idWinnerSet3 = this.widget.user2.id;
          });
        }
        break;
    }
  }

  String getValue(int i) {
    switch (i) {
      case 1:
        return _dropdownValueUser1Set1;
        break;
      case 2:
        return _dropdownValueUser2Set1;
        break;
      case 3:
        return _dropdownValueUser1Set2;
        break;
      case 4:
        return _dropdownValueUser2Set2;
        break;
      case 5:
        return _dropdownValueUser1Set3;
        break;
      case 6:
        return _dropdownValueUser2Set3;
        break;
    }
  }
}
