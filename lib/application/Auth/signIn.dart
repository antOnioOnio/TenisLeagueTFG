import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tenisleague100/application/Auth/register.dart';
import 'package:tenisleague100/application/Auth/sign_in_view_model.dart';
import 'package:tenisleague100/application/Auth/validators.dart';
import 'package:tenisleague100/application/widgets/helpDecorations.dart';
import 'package:tenisleague100/application/widgets/helpWidgets.dart';
import 'package:tenisleague100/application/widgets/showAlertDialog.dart';
import 'package:tenisleague100/services/GlobalValues.dart';

import '../top_providers.dart';

final signInModelProvider = ChangeNotifierProvider<SignInViewModel>(
  (ref) => SignInViewModel(auth: ref.watch(firebaseAuthProvider)),
);

class SignIn extends ConsumerWidget {
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
      },
      child: SignInPage(
        viewModel: signInModel,
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  final SignInViewModel viewModel;
  const SignInPage({Key key, this.viewModel}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
          widget.viewModel.isLoading ? circularLoadingBar() : _signInBlock(),
        ],
      ),
    );
  }

  Widget _signInBlock() {
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
                "Tenis 100",
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
              _buildLoginBtn(),
              SizedBox(
                height: 25.0,
              ),
              _buildRegister(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegister() {
    return FlatButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Register(),
        ),
      ),
      child: Text(
        "Register",
        style: GoogleFonts.raleway(color: Color(GlobalValues.mainTextColorHint), fontWeight: FontWeight.normal, fontSize: 14),
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
          decoration: getDecorationWithSelectedOption(_hasFocusUser),
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
                      maxLines: 1,
                      focusNode: _focusUser,
                      validator: EmailFieldValidator.validate,
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
          decoration: getDecorationWithSelectedOption(_hasFocusPass),
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
                    autovalidateMode: clickedSignInOnce ? AutovalidateMode.onUserInteraction : null,
                    key: formKeyPassword,
                    child: TextFormField(
                      focusNode: _focusPass,
                      validator: PasswordFieldValidator.validate,
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

  Widget _buildLoginBtn() {
    return Container(
      width: 310,
      height: 40,
      child: FlatButton(
        onPressed: () => {signIn()},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Color(GlobalValues.mainGreen),
        child: Text(
          "LOGIN",
          style: GoogleFonts.raleway(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  void signIn() async {
    clickedSignInOnce = true;
    if (formKeyUser.currentState.validate() && formKeyPassword.currentState.validate()) {
      await widget.viewModel.signIn(this.userController.text, this.passwordController.text, context);
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

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _focusUser.dispose();
    _focusPass.dispose();
    super.dispose();
  }
}
