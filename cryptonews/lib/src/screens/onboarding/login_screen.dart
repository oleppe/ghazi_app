import 'package:cryptonews/src/config/color_constants.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/main.dart';

class LoginForm extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final AuthenticationState state;
  LoginForm({required this.authenticationBloc, required this.state});
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'البريد الإلكتروني',
              filled: true,
              isDense: true,
            ),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            validator: (value) {
              if (value!.isEmpty) {
                return 'البريد الإلكتروني مطلوب';
              }
              return null;
            },
          ),
          SizedBox(
            height: 12,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'كلمة المرور',
              filled: true,
              isDense: true,
            ),
            obscureText: true,
            controller: _passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'كلمة المرور مطلوبة';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          // ignore: deprecated_member_use
          RaisedButton(
              color: Color(0xff5E92F3),
              textColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(8.0)),
              child: widget.state is AuthenticationLoading
                  ? CircularProgressIndicator(
                      backgroundColor:
                          Theme.of(context).textTheme.bodyText1!.color,
                    )
                  : Text('تسجيل الدخول',
                      style: TextStyle(
                          color: ColorConstants.secondaryDarkAppColor)),
              onPressed: () {
                if (_key.currentState!.validate()) {
                  widget.authenticationBloc.add(UserLogin(
                      email: _emailController.text,
                      password: _passwordController.text));
                } else {}
              })
        ],
      ),
    );
  }
}
