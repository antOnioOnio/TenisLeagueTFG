import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Auth/signIn.dart';
import 'package:tenisleague100/application/Auth/sign_in_view_model.dart';
import 'package:tenisleague100/application/Auth/validators.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/constants/GlobalValues.dart';

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
  bool hidePassword;
  FocusNode _focusPass = new FocusNode();
  FocusNode _focusEmail = new FocusNode();
  FocusNode _focusUserName = new FocusNode();
  bool _hasFocusPass = false;
  bool _hasFocusUserEmail = false;
  bool _hasFocusUserName = false;
  final formKeyEmail = GlobalKey<FormState>();
  final formKeyPassword = GlobalKey<FormState>();
  final formKeyUserName = GlobalKey<FormState>();
  bool clickedSignInOnce = false;

  static const int FIELD_NAME = 0;
  static const int FIELD_EMAIL = 1;
  static const int FIELD_PASSWORD = 2;

  @override
  void initState() {
    super.initState();
    hidePassword = true;
    _focusPass.addListener(_onFocusChange);
    _focusEmail.addListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          basicScreenColor(),
          widget.viewModel.isLoading ? circularLoadingBar() : _registerBlock(),
        ],
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
              SizedBox(height: 50.0),
              Text(
                "Register",
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 50.0,
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
                    child: TextFormField(
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
                        }
                        return "";
                      },
                      obscureText: valueForValidation == FIELD_PASSWORD ? hidePassword : false,
                      controller: controller,
                      keyboardType: valueForValidation == FIELD_EMAIL ? TextInputType.emailAddress : TextInputType.text,
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
        onPressed: () => {register()},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(GlobalValues.redTextbg),
        child: Text(
          "Register",
          style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  void register() {
    clickedSignInOnce = true;
    if (formKeyPassword.currentState.validate() && formKeyEmail.currentState.validate()) {
      widget.viewModel.register(this.mailFieldController.text, this.passwordController.text);
    }
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
    });
  }
}
