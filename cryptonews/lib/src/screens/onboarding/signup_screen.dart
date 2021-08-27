import 'package:cryptonews/src/config/color_constants.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared/main.dart';

class SignUpForm extends StatefulWidget {
  final AuthenticationBloc authenticationBloc;
  final AuthenticationState state;
  SignUpForm({required this.authenticationBloc, required this.state});
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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
                  : Text(
                      'تسجيل',
                      style: TextStyle(
                          color: ColorConstants.secondaryDarkAppColor),
                    ),
              onPressed: () {
                if (_key.currentState!.validate()) {
                  widget.authenticationBloc.add(UserSignUp(
                      email: _emailController.text,
                      password: _passwordController.text));
                } else {
                  print('Form not validated');
                }
              })
        ],
      ),
    );
  }
}
