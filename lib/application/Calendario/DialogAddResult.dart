import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelPlace.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';

class AddResultDialog extends StatefulWidget {
  final ModelMatch match;
  final ModelUserLeague user1;
  final ModelUserLeague user2;
  const AddResultDialog({Key key, @required this.match, @required this.user1, @required this.user2}) : super(key: key);

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
/*    DateTime now = DateTime.now();
    _selectedDateIndate = DateTime(now.year, now.month, now.day);
    _selectedTime = TimeOfDay(hour: now.hour, minute: now.minute);
    _time = "00:00";*/
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: /*_isLoading ? circularLoadingBar() :*/ mainContent(context),
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
                  /* mainAxisAlignment: MainAxisAlignment.spaceEvenly,*/
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
            /*  addMatch();*/
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

  Widget dropDownPlaces(int set) {
    return new Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(GlobalValues.mainGreen),
      ),
      child: DropdownButton<String>(
        value: getValue(set),
        iconSize: 0,
        elevation: 16,
        style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
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
    print("validation called");

    if (user1Result == "6") {
      if (user2Result == "0" || user2Result == "1" || user2Result == "2" || user2Result == "3" || user2Result == "4") {
        //0 1 2 3 4 5 ==> gana 1
        setWinner(set, 1);
      } else if (user2Result == "7") {
        // 7          ==> gana 2
        setWinner(set, 2);
      } else if (user2Result == "5" || user2Result == "6") {
        // 6          ==> invalido
        setWinnerNull(set);
      }
    } else if (user2Result == "6") {
      if (user1Result == "0" || user1Result == "1" || user1Result == "2" || user1Result == "3" || user1Result == "4") {
        //0 1 2 3 4 5 ==> gana 2
        setWinner(set, 2);
      } else if (user1Result == "7") {
        // 7          ==> gana 1
        setWinner(set, 1);
      } else if (user1Result == "5" || user1Result == "6") {
        // 6          ==> invalido
        setWinnerNull(set);
      }
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
