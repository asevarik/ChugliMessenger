import 'package:chuglimessenger/Components/Reusable_Button.dart';
import 'package:chuglimessenger/Components/Reusable_Txt_Field.dart';
import 'package:chuglimessenger/constants.dart';
import 'package:chuglimessenger/helper/GlobalContants.dart';
import 'package:chuglimessenger/helper/helperfunctions.dart';
import 'package:chuglimessenger/services/database.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static final screenname = "ProfileScreen";
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String newname = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: k_app_backgroundcolor,
        title: Center(
          child: Text(
            k_Profile,
            style: ktxt_headingstyle.copyWith(fontSize: 30),
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset(
                'images/mainLogo.png',
                height: 200,
                width: 300,
              ),
              SizedBox(
                height: 50,
              ),
              Resusable_txt_field(
                  hinttext: "Name:  ${GlobalContants.username}",
                  onchange: (value) {
                    newname = value;
                  },
                  issecure: false),
              SizedBox(
                height: 50,
              ),
              Reusable_Button(
                  onpress: () async {
                    if (newname != "") {
                      //!Updates username to everywhere in the app
                      await DataBase()
                          .updateUserInfo(GlobalContants.uid, newname);
                      await HelperFunctions().setuserName(newname);
                      GlobalContants.username = newname;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(k_Success),
                          content: Text(k_namechangedmsssg),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(k_ok),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  title: "change")
            ],
          ),
        ),
      ),
    );
  }
}
