import 'package:flutter/material.dart';
import 'package:chuglimessenger/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Reusable_Button extends StatelessWidget {
  final Function onpress;
  final String title;
  var icon;
  Reusable_Button({@required this.onpress, @required this.title, this.icon});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: 300,
      child: ElevatedButton(
          onPressed: onpress,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(k_yellow_color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: icon == true
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              icon == true ? Icon(FontAwesomeIcons.google) : SizedBox.shrink(),
              Text(
                title,
                style: TextStyle(
                    color: Color.fromRGBO(223, 223, 223, 1), fontSize: 23),
              ),
            ],
          )),
    );
  }
}
