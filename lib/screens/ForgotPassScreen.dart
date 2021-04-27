import 'package:chuglimessenger/Components/Reusable_Button.dart';
import 'package:chuglimessenger/Components/Reusable_Txt_Field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:chuglimessenger/constants.dart';
import 'package:chuglimessenger/services/auth.dart';

class ForgotPassScreen extends StatefulWidget {
  static final screenname = 'ForgotPassScreen';
  ForgotPassScreen({Key key}) : super(key: key);

  @override
  _ForgotPassScreenState createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  var email;
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: k_app_backgroundcolor,
      body: SafeArea(
        child: Container(
          child: Center(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Text(
                        k_forgotPasswordheading,
                        style: ktxt_headingstyle.copyWith(fontSize: 45),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 50,),

                    Resusable_txt_field(
                        hinttext: 'Provide Registered Email',
                        onchange: (value) {
                          email = value;
                        },
                        validate: (value) => EmailValidator.validate(value)
                            ? null
                            : 'Did you Forgot your email as well?',
                        issecure: false),
                    SizedBox(height: 50,),

                    Reusable_Button(
                        onpress: () async {
                          if (_formKey.currentState.validate()) {
                            Auth auth = Auth();
                            var result = await auth.resetPass(email);
                            if (result == true) {
                              AlertDialog alert = AlertDialog(
                                title: Text('Success'),
                                content: Text(
                                    'Check your email for password reset link'),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Close'),
                                  )
                                ],
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            } else {
                              AlertDialog alert = AlertDialog(
                                title: Text('Not So Success'),
                                content: Text(result),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Close'),
                                  )
                                ],
                              );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            }
                          }
                        },
                        title: k_Send),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
