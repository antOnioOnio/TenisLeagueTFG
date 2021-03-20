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
  TextEditingController userController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool hidePassword;
  FocusNode _focusPass = new FocusNode();
  FocusNode _focusUser = new FocusNode();
  bool _hasFocusPass = false;
  bool _hasFocusUser = false;
  final formKeyUser = GlobalKey<FormState>();
  final formKeyPassword = GlobalKey<FormState>();
  bool clickedSignInOnce = false;

  @override
  void initState() {
    super.initState();
    hidePassword = true;
    _focusPass.addListener(_onFocusChange);
    _focusUser.addListener(_onFocusChange);
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
              SizedBox(
                height: 100.0,
              ),
              Text(
                "Register",
                style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 50.0,
              ),
              _buildUserWidget(),
              SizedBox(
                height: 20.0,
              ),
              _buildPasswordWidget(),
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

  Widget _buildUserWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Usuario",
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 310,
          height: 40,
          alignment: Alignment.center,
          decoration: getDecorationWithSelectedOption(false),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: ImageIcon(
                AssetImage("assets/images/ic_person.png"),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Form(
                    autovalidateMode: clickedSignInOnce ? AutovalidateMode.onUserInteraction : null,
                    key: formKeyUser,
                    child: TextFormField(
                      focusNode: _focusUser,
                      validator: (val) {
                        return val.isEmpty || !validateEmailAddress(val) ? "Provide a valid email" : null;
                      },
                      controller: userController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
                      decoration: inputDecoration("Email"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildPasswordWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Password",
          style: GoogleFonts.raleway(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 310,
          height: 40,
          alignment: Alignment.center,
          decoration: getDecorationWithSelectedOption(false),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: ImageIcon(
                AssetImage("assets/images/ic_key.png"),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Form(
                    key: formKeyPassword,
                    child: TextFormField(
                      focusNode: _focusPass,
                      validator: (val) {
                        return val.isEmpty || val.length < 3 ? "Provide a valid password" : null;
                      },
                      obscureText: hidePassword,
                      controller: passwordController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.raleway(color: Color(GlobalValues.blackText), fontWeight: FontWeight.normal, fontSize: 14),
                      decoration: inputDecoration("Password"),
                    ),
                  ),
                ),
              ],
            ),
            trailing: GestureDetector(
              onTap: showHidePassword,
              child: Container(
                padding: EdgeInsets.only(bottom: 20),
                child: ImageIcon(
                  AssetImage("assets/images/ic_eye.png"),
                ),
              ),
            ),
          ),
        )
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
    if (formKeyPassword.currentState.validate() && formKeyUser.currentState.validate()) {
      widget.viewModel.register(this.userController.text, this.passwordController.text);
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
      _hasFocusUser = _focusUser.hasFocus;
    });
  }
}
