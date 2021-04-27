import 'package:chuglimessenger/Components/Reusable_Txt_Field.dart';
import 'package:chuglimessenger/constants.dart';
import 'package:chuglimessenger/screens/ForgotPassScreen.dart';
import 'package:chuglimessenger/screens/RegisterScreen.dart';
import 'package:chuglimessenger/screens/Splashscreen2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chuglimessenger/Components/Reusable_Button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chuglimessenger/services/auth.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);
  static final screenname = '/Login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _formKey = GlobalKey<FormState>();
  String email, password;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: k_app_backgroundcolor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 30,),

                    Image.asset(
                      'images/loginLogo.png',
                      width: 325,
                    ),
                    SizedBox(height: 30,),
                    Text(
                      k_login,
                      style: ktxt_headingstyle,
                    ),
                    SizedBox(height: 30,),

                    Resusable_txt_field(
                        keyboardtype: TextInputType.emailAddress,
                        validate: (value) => EmailValidator.validate(value)
                            ? null
                            : 'Please enter your Email,no one\'s gonna send you mail',
                        hinttext: k_Email,
                        prefixicon: Icon(
                          FontAwesomeIcons.envelope,
                          color: k_cement_color,
                        ),
                        issecure: false,
                        onchange: (value) {
                          email = value;
                        }),
                    SizedBox(height: 30,),

                    Resusable_txt_field(
                        hinttext: k_Password,
                        validate: (value) => (value == null || value.isEmpty)
                            ? 'Enter Password else you can see your chats on memes'
                            : null,
                        suffixicon: Icon(
                          FontAwesomeIcons.eye,
                          color: k_cement_color,
                        ),
                        issecure: true,
                        onchange: (value) {
                          password = value;
                        }),
                    SizedBox(height: 30,),

                    Container(
                      padding: EdgeInsets.only(left: 150),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, ForgotPassScreen.screenname);
                        },
                        child: Text(
                          'Forgot Password?',
                          style: ktxt_headingstyle.copyWith(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),

                    Reusable_Button(
                      title: k_login,
                      onpress: () async {
                        if (_formKey.currentState.validate()) {
                          // print('all values are correct');
                          // print('$email $password');
                          // print('now go to Chat screen after that');
                          setState(() {
                            isLoading = true;
                          });
                          Auth auth = Auth();
                          var uid = await auth.signIN(email, password);
                          if (uid == null) {
                            setState(() {
                              isLoading = false;
                            });

                            Navigator.pushReplacementNamed(
                                context, SplashScreen2.screenname);
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            AlertDialog alert = AlertDialog(
                              title: Text('ERROR'),
                              content: Text(uid),
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

                        // Navigator.pushNamed(context, ChatScreen.screenname);
                      },
                    ),
                    SizedBox(height: 30,),

                    isLoading
                        ? SpinKitWave(
                            color: k_cement_color,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have a an account?",
                                style: ktxt_headingstyle.copyWith(fontSize: 18),
                              ),
                              FlatButton(
                                padding: EdgeInsets.only(right: 15),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RegisterScreen.screenname);
                                },
                                child: Text('SignUp',
                                    style: TextStyle(
                                        color: k_yellow_color, fontSize: 18)),
                              )
                            ],
                          )
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
