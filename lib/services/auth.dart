import 'package:chuglimessenger/helper/helperfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chuglimessenger/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Auth {
  var signInUser;
  final _auth = FirebaseAuth.instance;
  Future<String> signIN(String email, String password) async {
    try {
      DataBase db = DataBase();
      QuerySnapshot data;
      signInUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (signInUser != null) {
        data = await db.getUserByEmail(email);

        await HelperFunctions().setuserCredentials(
            data.documents[0].data["name"],
            email,
            data.documents[0].data["uid"]);
        return null;
      }
    } catch (e) {
      return e.message;
    }
  }

  Stream<FirebaseUser> get user {
    return _auth.onAuthStateChanged;
  }

  Future<String> signUp(String name, String email, String password) async {
    try {
      DataBase db = DataBase();
      signInUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (signInUser != null) {
        //saves data to local db and on firestore
        Map<String, dynamic> userdetails = {
          "name": name,
          "email": email,
          "last_seen": DateTime.now().microsecondsSinceEpoch,
          "isonline": true,
          "uid": signInUser.uid,
        };
        await HelperFunctions().setuserCredentials(name, email, signInUser.uid);
        await db.uploadUserInfo(signInUser.uid, userdetails);
        await db.uploadUserInfo_realDb(signInUser.uid, userdetails);
        return null;
      }
    } catch (e) {
      return e.message;
    }
  }

  Future Signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print(e.message);
      return e.message;
    }
  }
}
