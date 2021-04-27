import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DataBase {
  static final realDB = FirebaseDatabase.instance.reference().child('users');
  Future<void> uploadUserInfo(String uid, Map<String, dynamic> userMap) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .setData(userMap)
        .catchError((onError) => {
              print("from Uploadin Userinfo"),
              print(onError.toString()),
            });
  }

  updateUserInfo(String uid, String newname) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({"name": newname}).catchError((error) {
      print("from Updateinfo Userinfo");
      print(error.toString());
    });
  }

  Future<void> uploadUserInfo_realDb(
      String uid, Map<String, dynamic> usermap) async {
    await realDB.child(uid).set(usermap);
  }
//!in Future is happening
  // updateUserPresence_realTime_db(String uid, bool isonline) async {
  //   await realDB.child(uid).update({"isonline": isonline});
  // }

  getUsers_realdb() async {
    realDB.once().then((res) {
      Map<dynamic, dynamic> data = res.value;
      return data;
    });
  }

  //!below it is not used
  Future<QuerySnapshot> getUserByName(String name) async {
    return await Firestore.instance
        .collection('users')
        .where("name", isEqualTo: name)
        .getDocuments();
  }

  Future<QuerySnapshot> getUserByEmail(String email) async {
    return await Firestore.instance
        .collection('users')
        .where("email", isEqualTo: email)
        .getDocuments();
  }

  Future<void> createChatRoom(String chatroomId, chatRoomMap) async {
    await Firestore.instance
        .collection('chatrooms')
        .document(chatroomId)
        .setData(chatRoomMap)
        .catchError((e) => {
              print(e.toString()),
            });
  }

  //!change this to realtime database
  updateUserpresence(String uid, bool isonline) async {
    Firestore.instance.collection("users").document(uid).updateData({
      "isonline": isonline,
      "last_seen": DateTime.now().microsecondsSinceEpoch,
    });
  }

//!type is doesn't defined because i have faced some error unsual
  addConversationMessages(String uid, String chatroomId, mssgMap) async {
    return await Firestore.instance
        .collection("chatrooms")
        .document(chatroomId)
        .collection("chats")
        .add(mssgMap)
        .catchError((e) {
      print("error from the firestroe while saving data");
      print(e.toString());
    });
  }

  updateMssgLen(String name, String chatroomId, int mssglen) async {
    return await Firestore.instance
        .collection("chatrooms")
        .document(chatroomId)
        .updateData({"${name}mssglen": mssglen});
  }

  deleteChatMessages(String chatroomId, String documentId) async {
    return await Firestore.instance
        .collection("chatrooms")
        .document(chatroomId)
        .collection("chats")
        .document(documentId)
        .updateData({"message": "this message is deleted"});
  }

  isTypingchecker(String chatroomId) async {
    return await Firestore.instance
        .collection("chatrooms")
        .document(chatroomId)
        .snapshots();
  }

  isTypingPresence(String name, String chatroomId, bool state) async {
    Firestore.instance.collection("chatrooms").document(chatroomId).updateData({
      "${name}istyping": state,
    });
  }

  conversationMessages(String chatroomId) async {
    return await Firestore.instance
        .collection("chatrooms")
        .document(chatroomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  getChatRooms(String username) async {
    return await Firestore.instance
        .collection("chatrooms")
        .where("users", arrayContains: username)
        .snapshots();
  }

  Future<DocumentSnapshot> getChatRoomsifalreadyexsist(
      String username, String sendername) async {
    QuerySnapshot result = await Firestore.instance
        .collection("chatrooms")
        .where("users", arrayContains: username)
        .getDocuments();
    for (var element in result.documents) {
      if (element.data['users'][0] == sendername ||
          element.data['users'][1] == sendername) {
        print("returning element");
        return element;
      }
    }
  }

  getOnlineUsers() async {
    return await Firestore.instance.collection("users").snapshots();
  }
}
