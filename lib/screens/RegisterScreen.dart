import 'package:chuglimessenger/Components/Reusable_Button.dart';
import 'package:chuglimessenger/Components/Reusable_Txt_Field.dart';
import 'package:chuglimessenger/constants.dart';
import 'package:chuglimessenger/screens/HomeScreen.dart';
import 'package:chuglimessenger/screens/Splashscreen2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chuglimessenger/screens/LoginScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chuglimessenger/services/auth.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);
  static final screenname = '/Register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name, email, password;
  bool isLoading = false;
  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: k_app_backgroundcolor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 20,),

                      Image.asset(
                        'images/registerLogo.png',
                        width: 350,
                      ),
                      SizedBox(height: 20,),

                      Divider(
                        color: k_cement_color,
                        thickness: 1.5,
                        indent: 15,
                        endIndent: 15,
                      ),
                      SizedBox(height: 20,),

                      Text(
                        k_Signup,
                        style: ktxt_headingstyle.copyWith(fontSize: 45),
                      ),
                      SizedBox(height: 20,),

                      Resusable_txt_field(
                        hinttext: k_Name,
                        validate: (value) => (value == null || value.isEmpty)
                            ? "Enter name we're sure it's not that much funny"
                            : null,
                        onchange: (value) {
                          name = value;
                        },
                        issecure: false,
                        prefixicon: Icon(
                          FontAwesomeIcons.user,
                          color: k_cement_color,
                        ),
                      ),
                      SizedBox(height: 20,),

                      Resusable_txt_field(
                        hinttext: k_Email,
                        validate: (value) => EmailValidator.validate(value)
                            ? null
                            : 'we respect your thinking but provide us a valid email',
                        onchange: (value) {
                          email = value;
                        },
                        issecure: false,
                        prefixicon: Icon(
                          FontAwesomeIcons.envelope,
                          color: k_cement_color,
                        ),
                      ),
                      SizedBox(height: 20,),

                      Resusable_txt_field(
                        hinttext: k_Password,
                        validate: (value) => (value == null || value.isEmpty)
                            ? 'Enter Password else you can see your chats on memes'
                            : null,
                        onchange: (value) {
                          password = value;
                        },
                        issecure: true,
                        suffixicon: Icon(
                          FontAwesomeIcons.eye,
                          color: k_cement_color,
                        ),
                      ),
                      SizedBox(height: 20,),

                      Reusable_Button(
                        onpress: () async {
                          if (_formKey.currentState.validate()) {
                            //do your code here
                            Auth auth = Auth();
                            setState(() {
                              isLoading = true;
                            });
                            var user = await auth.signUp(name, email, password);
                            if (user == null) {
                              Navigator.pushReplacementNamed(
                                  context, SplashScreen2.screenname);
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                              });
                              AlertDialog alert = AlertDialog(
                                title: Text('ERROR'),
                                content: Text(user),
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
                            // Navigator.pushNamed(context, ChatScreen.screenname);

                          }
                        },
                        title: k_Signup,
                      ),
                      //below row is for making --------------OR------------
                      SizedBox(height: 20,),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: k_cement_color,
                              thickness: 1.5,
                              indent: 18,
                              endIndent: 18,
                            ),
                          ),
                          SizedBox(height: 20,),

                          Text(
                            k_Or,
                            style: ktxt_headingstyle.copyWith(fontSize: 25),
                          ),
                          SizedBox(height: 20,),

                          Expanded(
                            child: Divider(
                              color: k_cement_color,
                              thickness: 1.5,
                              indent: 18,
                              endIndent: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),

                      isLoading
                          ? SpinKitWave(
                              color: k_cement_color,
                            )
                          : SizedBox(
                              height: 45,
                              width: 150,
                              child: OutlineButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, LoginScreen.screenname);
                                },
                                shape: StadiumBorder(),
                                borderSide: BorderSide(color: k_yellow_color),
                                child: Text(
                                  k_login,
                                  style: ktxt_headingstyle.copyWith(fontSize: 23),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
