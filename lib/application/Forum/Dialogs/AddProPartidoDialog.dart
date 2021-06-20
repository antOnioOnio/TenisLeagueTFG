import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'file:///C:/Projects/FlutterProjects/tenisleague100/lib/services/GlobalValues.dart';
import 'package:tenisleague100/models/ModelPlace.dart';
import 'package:tenisleague100/models/ModelPost.dart';

import '../ForumViewModel.dart';

class AddProPartidoDialog extends StatefulWidget {
  final ForumViewModel viewModel;
  final ModelPost post;

  const AddProPartidoDialog({Key key, @required this.viewModel, this.post}) : super(key: key);
  @override
  _AddProPartidoDialogState createState() => _AddProPartidoDialogState();
}

class _AddProPartidoDialogState extends State<AddProPartidoDialog> {
  String _dropdownValue = "";
  TextEditingController placeTextController = new TextEditingController();
  DateTime _selectedDateIndate, _completeDate;
  TimeOfDay _selectedTime;
  DateFormat _dateFormatTime = DateFormat("HH:mm");
  String _time;
  bool _showAddPlace = false;
  bool _isLoading;
  List<ModelPlace> _places = [];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _selectedDateIndate = DateTime(now.year, now.month, now.day);
    _selectedTime = TimeOfDay(hour: now.hour, minute: now.minute);
    _time = "00:00";
    getPlaces();
  }

  Future<void> getPlaces() async {
    setState(() {
      _isLoading = true;
    });
    _places = await widget.viewModel.getPlacesCollection();
    if (_places.isEmpty) {
      ModelPlace tempPlace = new ModelPlace(id: "", name: "AÑADE UN SITIO");
      _places.add(tempPlace);
    }
    _dropdownValue = _places[0].name;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _isLoading ? circularLoadingBar() : mainContent(context),
    );
  }

  Widget mainContent(context) {
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
                  height: 30,
                ),
                Text(
                  "¿Dónde quieres jugar?",
                  style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    dropDownPlaces(),
                    IconButton(
                      onPressed: () => {
                        setState(() {
                          _showAddPlace = true;
                        })
                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: Color(GlobalValues.mainGreen),
                      ),
                    )
                  ],
                ),
                _showAddPlace ? rowAddPlace() : SizedBox.shrink(),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "¿Qué día quieres jugar?",
                  style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
                buildDatePicker(),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "¿A qué hora?",
                  style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: 15,
                ),
                buildTimePicker(),
                SizedBox(
                  height: 30,
                ),
                Row(
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
                        addMatch();
                      },
                      child: Text(
                        "Guardar",
                        style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  child: customAvatar(widget.viewModel.imageUser)),
            ),
          ),
        ],
      ),
    );
  }

  Row rowAddPlace() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          child: TextField(
            controller: placeTextController,
            decoration: InputDecoration(
              hintText: 'Escribe el nombre del sitio',
              suffixIcon: IconButton(
                onPressed: () => {sendPlace()},
                icon: Icon(Icons.check),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> sendPlace() async {
    setState(() {
      _isLoading = true;
    });

    if (placeTextController.text != null && placeTextController.text.isNotEmpty) {
      if (listContainsPlaceName(placeTextController.text)) {
        Fluttertoast.showToast(
            msg: "Sitio ya añadido",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Color(GlobalValues.mainGreen),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        await widget.viewModel.sendNewPlace(placeTextController.text);
        setState(() {
          _showAddPlace = false;
          placeTextController.clear();
        });
        await getPlaces();
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  bool listContainsPlaceName(String name) {
    for (var place in _places) {
      if (place.name == name) return true;
    }
    return false;
  }

  Widget dropDownPlaces() {
    return new Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(GlobalValues.mainGreen),
      ),
      child: DropdownButton<String>(
        value: _dropdownValue,
        iconSize: 25,
        elevation: 16,
        style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
        underline: Container(
          height: 0,
        ),
        onChanged: (String newValue) {
          setState(() {
            _dropdownValue = newValue;
          });
        },
        items: _places.map<DropdownMenuItem<String>>((ModelPlace value) {
          return DropdownMenuItem<String>(
            value: value.name,
            child: Text(
              value.name,
              style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildDatePicker() {
    return Container(
      child: GestureDetector(
        onTap: () => {
          selectDate(context),
        },
        child: Center(
          child: Text(
            DateFormat("dd.MM.yyyy").format(_selectedDateIndate),
            style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget buildTimePicker() {
    return Container(
      child: GestureDetector(
        onTap: () => {
          _selectTime(context),
        },
        child: Center(
          child: Text(
            _time,
            style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime initialDate;
    initialDate = _selectedDateIndate;
    final DateTime picked = await showDatePicker(context: context, initialDate: initialDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != initialDate) if (mounted) {
      setState(() {
        _selectedDateIndate = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _completeDate =
            DateTime(_selectedDateIndate.year, _selectedDateIndate.month, _selectedDateIndate.day, _selectedTime.hour, _selectedTime.minute);
        _time = _dateFormatTime.format(_completeDate);
      });
    }
  }

  Future<void> addMatch() async {
    String contentToPost = "Partido abierto el " + DateFormat("dd.MM.yyyy").format(_selectedDateIndate);
    contentToPost += " a las  " + _time + " en " + this._dropdownValue;
    await widget.viewModel.addMatch(contentToPost);
    Navigator.of(context).pop();
  }
}
