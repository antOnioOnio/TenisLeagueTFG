import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Forum/TypesPostWidgets/commomWidgets.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/models/ModelPost.dart';

import '../ForumViewModel.dart';

class AddEventDialog extends StatefulWidget {
  final ForumViewModel viewModel;
  final ModelPost post;

  const AddEventDialog({Key key, @required this.viewModel, this.post}) : super(key: key);
  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  TextEditingController _mainTextController = new TextEditingController();

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

  Widget textArea() {
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _mainTextController,
                maxLines: 8,
                decoration: InputDecoration.collapsed(hintText: "Publica tu evento"),
              ),
            ),
          )
        ],
      ),
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
                textArea(),
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
                        addEvent();
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

  Row textContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: TextField(
            controller: _mainTextController,
            decoration: InputDecoration(
              hintText: 'Escribe el nombre del sitio',
              suffixIcon: IconButton(
                onPressed: () => {/*sendPlace()*/},
                icon: Icon(Icons.check),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> addEvent() async {
    if (this._mainTextController.text.isNotEmpty) {
      await widget.viewModel.addEvent(_mainTextController.text);
      Navigator.of(context).pop();
    } else {
      showWriteDialog(context);
    }
  }
}
