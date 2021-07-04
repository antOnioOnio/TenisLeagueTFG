import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tenisleague100/application/Auth/validators.dart';
import 'package:tenisleague100/application/top_providers.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/services/GlobalValues.dart';
import 'package:tenisleague100/models/ModelLeague.dart';
import 'package:tenisleague100/models/ModelMatch.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:tenisleague100/services/GlobalMethods.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ModelUserLeague _currentUserModel;
  File _image;
  String _base64Image;
  bool _isLoading;
  TextEditingController mailFieldController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController levelController = new TextEditingController();
  TextEditingController tlfController = new TextEditingController();
  bool hidePassword;
  bool hideNewPassword;
  FocusNode _focusPass = new FocusNode();
  FocusNode _focusNewPass = new FocusNode();
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusUserName = new FocusNode();
  FocusNode _focusLevel = new FocusNode();
  FocusNode _focustlf = new FocusNode();
  bool _hasFocusPass = false;
  bool _hasFocusNewPass = false;
  bool _hasFocusUserEmail = false;
  bool _hasFocusUserName = false;
  bool _hasFocusUserLevel = false;
  bool _hasFocusUsertlf = false;
  final formKeyEmail = GlobalKey<FormState>();
  final formKeyPassword = GlobalKey<FormState>();
  final formKeyNewPassword = GlobalKey<FormState>();
  final formKeyUserName = GlobalKey<FormState>();
  final formKeyUserLevel = GlobalKey<FormState>();
  final formKeytlf = GlobalKey<FormState>();
  bool clickedSignInOnce = false;
  String dropdownValue = GlobalValues.levelPrincipiante;
  List<String> _options = [GlobalValues.levelPrincipiante, GlobalValues.leveMedio, GlobalValues.levelAvanzado];
  Uint8List bytes;
  static const int FIELD_NAME = 0;
  static const int FIELD_EMAIL = 1;
  static const int FIELD_PASSWORD = 2;
  static const int FIELD_LEVEL = 3;
  static const int FIELD_TLF = 4;

  @override
  void initState() {
    super.initState();
    hidePassword = true;
    _focusPass.addListener(_onFocusChange);
    _focusEmail.addListener(_onFocusChange);
    _focusLevel.addListener(_onFocusChange);
    _focusNewPass.addListener(_onFocusChange);
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          basicScreenColor(),
          _isLoading ? circularLoadingBar() : _registerBlock(firebaseAuth),
        ],
      ),
    );
  }

  Widget _registerBlock(FirebaseAuth user) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: () => onClickFromCamera(),
                child: customAvatarBigger(bytes),
              ),
              SizedBox(
                height: 20.0,
              ),
              _customField(
                  "Nombre completo",
                  ImageIcon(
                    AssetImage("assets/images/ic_person.png"),
                  ),
                  SizedBox.shrink(),
                  formKeyUserName,
                  _focusUserName,
                  FIELD_NAME,
                  nameController,
                  "Nombre completo",
                  _hasFocusUserName),
              SizedBox(
                height: 15.0,
              ),
              _customField("Email", Icon(Icons.attach_email), SizedBox.shrink(), formKeyEmail, _focusEmail, FIELD_EMAIL, mailFieldController, "Email",
                  _hasFocusUserEmail),
              SizedBox(
                height: 15.0,
              ),
              _customField("Teléfono", Icon(Icons.mobile_friendly), SizedBox.shrink(), formKeytlf, _focustlf, FIELD_TLF, tlfController, "Teléfono",
                  _hasFocusUsertlf),
              SizedBox(
                height: 15.0,
              ),
              _customDropDown(),
              SizedBox(
                height: 15.0,
              ),
              _customField(
                  "Contraseña",
                  ImageIcon(
                    AssetImage("assets/images/ic_key.png"),
                  ),
                  ImageIcon(
                    AssetImage("assets/images/ic_eye.png"),
                  ),
                  formKeyPassword,
                  _focusPass,
                  FIELD_PASSWORD,
                  passwordController,
                  "Contraseña",
                  _hasFocusPass),
              SizedBox(
                height: 15.0,
              ),
              _customField(
                  "Nueva Contraseña",
                  ImageIcon(
                    AssetImage("assets/images/ic_key.png"),
                  ),
                  ImageIcon(
                    AssetImage("assets/images/ic_eye.png"),
                  ),
                  formKeyNewPassword,
                  _focusNewPass,
                  FIELD_PASSWORD,
                  newPasswordController,
                  "Nueva Contraseña",
                  _hasFocusNewPass),
              SizedBox(
                height: 15.0,
              ),
              SizedBox(
                height: 15.0,
              ),
              RowButtonsCreate(),
              SizedBox(
                height: 20.0,
              ),
              RowButtons(user),
            ],
          )
        ],
      ),
    );
  }

  Widget _customDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Nivel",
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 310,
          height: 40,
          alignment: Alignment.center,
          decoration: getDecorationWithSelectedOption(_hasFocusUserLevel),
          child: ListTile(
            leading: SizedBox(
              width: 30,
            ),
            title: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: dropDown(),
            ),
          ),
        ),
      ],
    );
  }

  Widget dropDown() {
    return new Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(GlobalValues.mainGreen),
      ),
      child: DropdownButton<String>(
        focusNode: _focusLevel,
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
            _focusLevel.requestFocus();
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

  Widget _customField(String header, Widget leftIcon, Widget rightIcon, Key formKey, FocusNode focus, int valueForValidation,
      TextEditingController controller, String hint, bool hasFocusBool) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          header,
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 310,
          height: 40,
          alignment: Alignment.center,
          decoration: getDecorationWithSelectedOption(hasFocusBool),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: leftIcon,
            ),
            title: Row(
              children: [
                Expanded(
                  child: Form(
                    key: formKey,
                    child: valueForValidation == FIELD_LEVEL
                        ? SizedBox.shrink()
                        : TextFormField(
                            focusNode: focus,
                            validator: (val) {
                              switch (valueForValidation) {
                                case FIELD_NAME:
                                  return val.isEmpty || val.length < 3 ? "Escribe una nombre completo" : null;
                                  break;
                                case FIELD_EMAIL:
                                  return val.isEmpty || !validateEmailAddress(val) ? "Por favor escribe un correo válido" : null;
                                  break;
                                case FIELD_PASSWORD:
                                  return val.isEmpty || val.length < 3 ? "Escribe una contraseña válida" : null;
                                  break;
                                case FIELD_TLF:
                                  return val.isEmpty || val.length != 9 ? "Telefono debe tener 9 digitos" : null;
                                  break;
                              }
                              return "";
                            },
                            obscureText: valueForValidation == FIELD_PASSWORD ? hidePassword : false,
                            controller: controller,
                            keyboardType: textInputType(valueForValidation),
                            style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
                            decoration: inputDecoration(hint),
                          ),
                  ),
                ),
              ],
            ),
            trailing: GestureDetector(
              onTap: showHidePassword,
              child: Container(
                padding: EdgeInsets.only(bottom: 20),
                child: rightIcon,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget RowButtons(FirebaseAuth firebaseAuth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 150,
          child: FlatButton(
            onPressed: () => {
              _signOut(context, firebaseAuth),
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Color(GlobalValues.redTextbg),
            child: Text(
              "Sign out",
              style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 150,
          child: FlatButton(
            onPressed: () => {
              saveChanges(firebaseAuth),
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Colors.blueAccent,
            child: Text(
              "Guardar",
              style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget RowButtonsCreate() {
    return Visibility(
      visible: _currentUserModel.role == "admin",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 200,
            child: FlatButton(
              onPressed: () => {createLeaguesAndTournament()},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Color(GlobalValues.mainGreen),
              child: Text(
                "Crear ligas y fase final",
                style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void createLeaguesAndTournament() async {
    final database = context.read<Database>(databaseProvider);
    ModelLeague leagueB = new ModelLeague(id: generateUuid(), level: GlobalValues.levelPrincipiante, dateLeague: DateTime.now());
    ModelLeague leagueP = new ModelLeague(id: generateUuid(), level: GlobalValues.leveMedio, dateLeague: DateTime.now());
    ModelLeague leagueA = new ModelLeague(id: generateUuid(), level: GlobalValues.levelAvanzado, dateLeague: DateTime.now());

    await database.sendLeague(leagueB);
    await database.sendLeague(leagueP);
    await database.sendLeague(leagueA);

    ModelLeague tournamentB = new ModelLeague(id: generateUuid(), level: GlobalValues.levelPrincipiante, dateLeague: DateTime.now());
    ModelLeague tournamentP = new ModelLeague(id: generateUuid(), level: GlobalValues.leveMedio, dateLeague: DateTime.now());
    ModelLeague tournamentA = new ModelLeague(id: generateUuid(), level: GlobalValues.levelAvanzado, dateLeague: DateTime.now());

    await database.sendTournament(tournamentB);
    await database.sendTournament(tournamentP);
    await database.sendTournament(tournamentA);
  }

  void saveChanges(FirebaseAuth firebaseAuth) async {
    if (validateForms()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Confirma por favor"),
          content: Text("¿Guardamos los cambios entonces?"),
          actions: [
            TextButton(
              child: Text(
                "Si",
              ),
              onPressed: () => {
                updateUser(firebaseAuth),
                updatePassword(firebaseAuth),
                Navigator.pop(context),
              },
            ),
            TextButton(
              child: Text(
                "No",
              ),
              onPressed: () => {
                Navigator.pop(context),
              },
            )
          ],
        ),
      );
    } else {
      showAlertDialog(
        context: context,
        title: 'Información incorrecta',
        content: "Revisa los datos",
        defaultActionText: 'OK',
        requiredCallback: false,
      );
    }
  }

  bool validateForms() {
    return formKeyUserName.currentState.validate() &&
        formKeyEmail.currentState.validate() &&
        formKeytlf.currentState.validate() &&
        (passwordController.text == newPasswordController.text);
  }

  void updatePassword(FirebaseAuth firebaseAuth) async {
    if (passwordController.text.length > 3 && newPasswordController.text.length > 3) {
      User user = firebaseAuth.currentUser;
      user.updatePassword(passwordController.text).then((_) {
        print("Your password changed Succesfully ");
      }).catchError((err) {
        print("You can't change the Password" + err.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    }
  }

  void updateUser(FirebaseAuth firebaseAuth) async {
    final database = context.read<Database>(databaseProvider);
    User user = firebaseAuth.currentUser;
    user.updateEmail(mailFieldController.text);
    await database.setUser(
      new ModelUserLeague(
          fullName: this.nameController.text,
          tlf: this.tlfController.text,
          email: this.mailFieldController.text,
          level: dropdownValue,
          currentScore: _currentUserModel.currentScore,
          matchWins: _currentUserModel.matchWins,
          matchPlayed: _currentUserModel.matchPlayed,
          matchLosses: _currentUserModel.matchLosses,
          image: this._base64Image,
          id: _currentUserModel.id),
    );
  }

  void getCurrentUser() async {
    final database = context.read<Database>(databaseProvider);
    setState(() {
      _isLoading = true;
    });
    _currentUserModel = await database.getCurrentUser();
    _base64Image = _currentUserModel.image;
    bytes = base64Decode(_base64Image);
    this.nameController.text = _currentUserModel.fullName;
    this.mailFieldController.text = _currentUserModel.email;
    this.tlfController.text = _currentUserModel.tlf;
    dropdownValue = _currentUserModel.level;
    setState(() {
      _isLoading = false;
    });
  }

  void showHidePassword() {
    setState(() {
      this.hidePassword = !this.hidePassword;
    });
  }

  void _onFocusChange() {
    setState(() {
      _hasFocusPass = _focusPass.hasFocus;
      _hasFocusNewPass = _focusNewPass.hasFocus;
      _hasFocusUserEmail = _focusEmail.hasFocus;
      _hasFocusUserName = _focusUserName.hasFocus;
      _hasFocusUserLevel = _focusLevel.hasFocus;
      _hasFocusUsertlf = _focustlf.hasFocus;
    });
  }

  void onClickFromCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (image != null) print('Picture saved to ${image.path}');
    Uint8List value = await image.readAsBytes();
    String base64Image = base64Encode(value);

    setState(() {
      _image = image;
      _base64Image = base64Image;
      bytes = base64Decode(_base64Image);
    });
  }

  TextInputType textInputType(int field) {
    if (field == FIELD_EMAIL) {
      return TextInputType.emailAddress;
    } else if (field == FIELD_TLF) {
      return TextInputType.number;
    } else {
      return TextInputType.text;
    }
  }

  Future<void> _signOut(BuildContext context, FirebaseAuth firebaseAuth) async {
    try {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Confirma por favor"),
          content: Text("¿Quieres salir de la aplicación?"),
          actions: [
            TextButton(
              child: Text(
                "Si",
              ),
              onPressed: () => {
                firebaseAuth.signOut(),
                Navigator.pop(context),
              },
            ),
            TextButton(
              child: Text(
                "No",
              ),
              onPressed: () => {
                Navigator.pop(context),
              },
            )
          ],
        ),
      );
    } catch (e) {
      showAlertDialog(
        context: context,
        title: 'Error',
        content: "Error signing out",
        defaultActionText: 'OK',
        requiredCallback: false,
      );
    }
  }
}
