import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';
import 'package:tenisleague100/models/ModelPost.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';

import '../ForumViewModel.dart';

class AddPictureDialog extends StatefulWidget {
  final ForumViewModel viewModel;
  final ModelPost post;

  const AddPictureDialog({Key key, @required this.viewModel, this.post}) : super(key: key);
  @override
  _AddPictureDialogState createState() => _AddPictureDialogState();
}

class _AddPictureDialogState extends State<AddPictureDialog> {
  File _image;
  String _base64Image;
  TextEditingController _messageController = new TextEditingController();
  FocusNode _focusMsg = new FocusNode();
  bool _isLoading;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    onClickFromCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      physics: AlwaysScrollableScrollPhysics(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: _isLoading ? circularLoadingBar() : mainContent(context),
      ),
    );
  }

  Widget mainContent(context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: decorationDialogAdd(),
          margin: EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _image != null
                  ? Container(
                      height: 300.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: new FileImage(_image),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.rectangle,
                      ),
                    )
                  : SizedBox.shrink(),
              Row(
                children: [
                  Positioned(
                    left: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: customAvatar(widget.viewModel.imageUser),
                      ),
                    ),
                  ),
                  typingContainer()
                ],
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
                      addPicturePost();
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
      ],
    );
  }

  Widget typingContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        height: 40,
        alignment: Alignment.center,
        decoration: getDecorationWithSelectedOption(true),
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
        ),
      ),
    );
  }

  void onClickFromCamera() async {
    setState(() {
      _isLoading = true;
    });
    File image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (image != null) {
      Uint8List value = await image.readAsBytes();
      String base64Image = base64Encode(value);

      setState(() {
        _image = image;
        _base64Image = base64Image;
        _isLoading = false;
      });
    } else {
      _isLoading = false;
      Navigator.of(context).pop();
    }
  }

  Future<void> addPicturePost() async {
    if (this._messageController.text.isNotEmpty) {
      String contentToPost = _messageController.text;

      ModelPost modelPost = new ModelPost(
          id: generateUuid(),
          idUser: widget.viewModel.user.id,
          nameOfUser: widget.viewModel.user.fullName,
          content: contentToPost,
          imageUser: widget.viewModel.user.image,
          image: this._base64Image,
          postType: ModelPost.typePicture,
          createdAt: DateTime.now());

      await widget.viewModel.sendPost(modelPost);

      Navigator.of(context).pop();
    } else {
      showWriteDialog(context);
    }
  }

  Future<void> showWriteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Escribe algo.."),
        content: Text("Es mejor cuando transmites un mensajes"),
        actions: [
          TextButton(
            child: Text(
              "ok..",
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
        ],
      ),
    );
  }
}
