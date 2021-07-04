import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tenisleague100/application/Auth/signIn.dart';
import 'package:tenisleague100/application/Auth/sign_in_view_model.dart';
import 'package:tenisleague100/application/Auth/validators.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/models/ModelUserLeague.dart';
import 'package:tenisleague100/services/Database/Database.dart';
import 'package:tenisleague100/services/GlobalValues.dart';

import '../top_providers.dart';

class Register extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final signInModel = watch(signInModelProvider);
    return ProviderListener<SignInViewModel>(
      provider: signInModelProvider,
      onChange: (context, model) async {
        if (model.error != null) {
          showAlertDialog(
            context: context,
            title: 'Error',
            content: model.error,
            defaultActionText: 'OK',
            requiredCallback: false,
          );
        }
        if (model.auth.currentUser != null) {
          Navigator.of(context).pop();
        }
      },
      child: RegisterPage(
        viewModel: signInModel,
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  final SignInViewModel viewModel;
  const RegisterPage({Key key, this.viewModel}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  TextEditingController mailFieldController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController levelController = new TextEditingController();
  TextEditingController tlfController = new TextEditingController();
  bool hidePassword;
  FocusNode _focusPass = new FocusNode();
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusUserName = new FocusNode();
  FocusNode _focusLevel = new FocusNode();
  FocusNode _focustlf = new FocusNode();
  bool _hasFocusPass = false;
  bool _hasFocusUserEmail = false;
  bool _hasFocusUserName = false;
  bool _hasFocusUserLevel = false;
  bool _hasFocusUsertlf = false;
  final formKeyEmail = GlobalKey<FormState>();
  final formKeyPassword = GlobalKey<FormState>();
  final formKeyUserName = GlobalKey<FormState>();
  final formKeyUserLevel = GlobalKey<FormState>();
  final formKeytlf = GlobalKey<FormState>();
  bool clickedSignInOnce = false;
  String dropdownValue = GlobalValues.levelPrincipiante;
  List<String> _options = [GlobalValues.levelPrincipiante, GlobalValues.leveMedio, GlobalValues.levelAvanzado];
  File _image;
  String _base64Image;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            basicScreenColor(),
            widget.viewModel.isLoading ? circularLoadingBar() : _registerBlock(),
          ],
        ),
      ),
    );
  }

  Widget _registerBlock() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                "Register",
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(height: 15.0),
              Container(
                margin: EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundColor: Color(GlobalValues.mainTextColorHint),
                  radius: 30,
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _image,
                            width: 300,
                            height: 170,
                            fit: BoxFit.fill,
                          ),
                        )
                      : GestureDetector(
                          onTap: () => onClickFromCamera(),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[200],
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 30.0,
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
                height: 20.0,
              ),
              _customField("Email", Icon(Icons.attach_email), SizedBox.shrink(), formKeyEmail, _focusEmail, FIELD_EMAIL, mailFieldController, "Email",
                  _hasFocusUserEmail),
              SizedBox(
                height: 20.0,
              ),
              _customField("Teléfono", Icon(Icons.mobile_friendly), SizedBox.shrink(), formKeytlf, _focustlf, FIELD_TLF, tlfController, "Teléfono",
                  _hasFocusUsertlf),
              SizedBox(
                height: 20.0,
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
                height: 25.0,
              ),
              _customDropDown(),
              SizedBox(
                height: 25.0,
              ),
              _buildRegisterBtn(),
              SizedBox(
                height: 25.0,
              ),
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

  Widget _buildRegisterBtn() {
    return Container(
      width: 310,
      height: 40,
      child: FlatButton(
        onPressed: () => {
          register(),
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(GlobalValues.redTextbg),
        child: Text(
          "Registro",
          style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
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

  void register() async {
    clickedSignInOnce = true;
    if (validateForms()) {
      if (_base64Image != null) {
        await widget.viewModel.register(this.mailFieldController.text, this.passwordController.text, context);
        final database = context.read<Database>(databaseProvider);
        String userId = widget.viewModel.currentId;
        await database.setUser(
          new ModelUserLeague(
              fullName: this.nameController.text,
              tlf: this.tlfController.text,
              email: this.mailFieldController.text,
              level: dropdownValue,
              currentScore: 0,
              matchWins: 0,
              matchPlayed: 0,
              matchLosses: 0,
              image: this._base64Image,
              id: userId),
        );
      } else {
        showAlertDialog(
          context: context,
          title: 'Foto sin rellenar',
          content: "Hazte un selfie..",
          defaultActionText: 'OK',
          requiredCallback: false,
        );
      }
    }
  }

  bool validateForms() {
    return formKeyUserName.currentState.validate() &&
        formKeyEmail.currentState.validate() &&
        formKeytlf.currentState.validate() &&
        formKeyPassword.currentState.validate();
  }

  void showHidePassword() {
    setState(() {
      this.hidePassword = !this.hidePassword;
    });
  }

  void _onFocusChange() {
    setState(() {
      _hasFocusPass = _focusPass.hasFocus;
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
    });
  }
}
