import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tenisleague100/application/Dashboard/Forum/ForumViewModel.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';

class AddProPartidoDialog extends StatefulWidget {
  final ForumViewModel viewModel;

  const AddProPartidoDialog({Key key, @required this.viewModel}) : super(key: key);
  @override
  _AddProPartidoDialogState createState() => _AddProPartidoDialogState();
}

class _AddProPartidoDialogState extends State<AddProPartidoDialog> {
  String dropdownValue = "Garros";
  List<String> _options = ["Garros", "Pts", "Albolote", "Serrallo", "Chana"];
  DateTime _selectedDateIndate, _completeDate;
  TimeOfDay _selectedTime;
  DateFormat dateFormatTime = DateFormat("HH:mm");
  String _time;
  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _selectedDateIndate = DateTime(now.year, now.month, now.day);
    _selectedTime = TimeOfDay(hour: now.hour, minute: now.minute);
    _time = "00:00";
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
    return Stack(
      children: <Widget>[
        Container(
          /*height: 350,*/
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
              dropDownPlaces(),
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
                      Navigator.of(context).pop();
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
            child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(20)), child: customAvatar(widget.viewModel.imageUser)),
          ),
        ),
      ],
    );
  }

  Widget dropDownPlaces() {
    return new Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(GlobalValues.mainGreen),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        iconSize: 25,
        elevation: 16,
        style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
        underline: Container(
          height: 0,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: _options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
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
        _time = dateFormatTime.format(_completeDate);
      });
    }
  }
}
