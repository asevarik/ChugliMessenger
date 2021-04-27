import 'package:chuglimessenger/helper/GlobalContants.dart';
import 'package:chuglimessenger/screens/ChatMssgScreen.dart';
import 'package:chuglimessenger/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chuglimessenger/constants.dart';

class UserScreen extends StatefulWidget {
  final Stream userstream;
  UserScreen({this.userstream});
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  DataBase db = new DataBase();
  createChatroomAndStartConversation(String usrname) async {
    //!users=[usrname,myname]

    List<String> users = [
      usrname,
      GlobalContants.username
    ]; //shared preference is used for my name
    String chatroomid = await getChatRoomId(usrname, GlobalContants.username);
    print(chatroomid);
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomid": chatroomid,
      "${GlobalContants.username}mssglen": 0,
      "${usrname}mssglen": 0,
      "${GlobalContants.username}istyping": false,
      "${usrname}istyping": false,
    };
    await db.createChatRoom(chatroomid, chatRoomMap);
    //*go to ChatMessge Screen ASAP With chat replacement
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatMssgScreen(
          chatroomId: chatroomid,
          sendername: usrname,
        ),
      ),
    );
  }

//   getUserRealTimedb() async {
// //    print(fridgesDs.runtimeType);
//     return data;
//   }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: widget.userstream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      String timeminago(int time) {
                        DateTime currentDateTime = DateTime.now();

                        Duration differenceDuration =
                            currentDateTime.difference(
                                DateTime.fromMicrosecondsSinceEpoch(time));
                        String durationString = differenceDuration.inSeconds >
                                59
                            ? differenceDuration.inMinutes > 59
                                ? differenceDuration.inHours > 23
                                    ? '${differenceDuration.inDays} ${differenceDuration.inDays == 1 ? 'day ago' : 'days ago'}'
                                    : '${differenceDuration.inHours} ${differenceDuration.inHours == 1 ? 'hour ago' : 'hours ago'}'
                                : '${differenceDuration.inMinutes} ${differenceDuration.inMinutes == 1 ? 'minute ago' : 'minutes ago'}'
                            : 'few moments ago';
                        return durationString;
                      }

                      return GlobalContants.useremail !=
                              snapshot.data.documents[index].data["email"]
                          ? AllUserSection(
                              time: timeminago(snapshot
                                  .data.documents[index].data["last_seen"]),
                              isonline: snapshot
                                      .data.documents[index].data["isonline"]
                                  ? true
                                  : false,
                              name: snapshot.data.documents[index].data["name"],
                              email:
                                  snapshot.data.documents[index].data["email"],
                              onpress: () {
                                //*make it work here
                                createChatroomAndStartConversation(snapshot
                                    .data.documents[index].data["name"]);
                                print(snapshot
                                    .data.documents[index].data["name"]);
                              },
                            )
                          : Container();
                    })
                : Container();
          }),
    );
  }
}

class AllUserSection extends StatelessWidget {
  final Function onpress;
  final String name;
  final String email;
  final String time;
  final bool isonline;
  AllUserSection(
      {@required this.onpress,
      @required this.name,
      @required this.email,
      @required this.isonline,
      @required this.time});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 13, right: 13, top: 10),
      child: GestureDetector(
        onTap: onpress,
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: ktxt_chatNameStyle,
                  ),
                  isonline
                      ? Icon(
                          FontAwesomeIcons.solidCircle,
                          color: Colors.green,
                          size: 16,
                        )
                      : Text(time)
                ],
              ),
              Text(email)
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> getChatRoomId(String a, String b) async {
  DocumentSnapshot result = await DataBase().getChatRoomsifalreadyexsist(b, a);
  if (result != null) {
    print("sent from db");
    return result.data["chatroomid"];
  }
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
