import 'package:chuglimessenger/constants.dart';
import 'package:flutter/material.dart';

class Resusable_txt_field extends StatelessWidget {
  final String hinttext;
  final Function onchange;
  final Icon prefixicon, suffixicon;
  final TextInputType keyboardtype;
  final Function validate;
  bool issecure = false;
  //set the value else give it a null
  Resusable_txt_field({
    @required this.hinttext,
    @required this.onchange,
    @required this.issecure,
    this.validate, //if you don't intial it with required the code will crash by some unknown error
    this.prefixicon,
    this.suffixicon,
    this.keyboardtype,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      // height: 20,
      child: TextFormField(
        validator: validate,
        obscureText: issecure,
        style: TextStyle(color: k_cement_color, fontSize: 20),
        decoration: InputDecoration(
          prefixIcon: prefixicon,
          suffixIcon: suffixicon,
          hintStyle: TextStyle(color: k_cement_color, fontSize: 20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: k_yellow_color),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: k_yellow_color),
          ),
          hintText: (hinttext != null) ? hinttext : null,
          labelStyle: TextStyle(color: k_cement_color, fontSize: 13),
        ),
        keyboardType: keyboardtype,
        onChanged: onchange,
      ),
    );
  }
}
