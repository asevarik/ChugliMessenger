import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chuglimessenger/helper/GlobalContants.dart';
import 'package:chuglimessenger/screens/ChatMssgScreen.dart';
import 'package:chuglimessenger/screens/SearchScreen.dart';
import 'package:chuglimessenger/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chuglimessenger/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatRoomScreen extends StatefulWidget {
  final Stream chatroomStream;
  ChatRoomScreen({this.chatroomStream});
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  Widget chatroomMaker() {
    return StreamBuilder(
        stream: widget.chatroomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    print("name of other user");
                    return PressableChatNames(
                      document: snapshot.data.documents[index],
                    );
                  },
                )
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.only(bottom: 30),
        margin: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            chatroomMaker(),
            Container(
              padding: EdgeInsets.only(right: 30),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, SearchScreen.screenname);
                },
                child: Icon(
                  FontAwesomeIcons.search,
                  color: Theme.of(context).primaryColor,
                ),
                backgroundColor: Theme.of(context).appBarTheme.color,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PressableChatNames extends StatelessWidget {
  final DocumentSnapshot document;
  bool istyping;
  PressableChatNames({this.document});
  String nam;
  int mssglength;
  @override
  Widget build(BuildContext context) {
    nam = GlobalContants.username != document.data["users"][0]
        ? document.data["users"][0]
        : document.data["users"][1];
    print(document.data);
    istyping = document.data['${nam}${k_istyping}'];
    mssglength = document.data["${nam}mssglen"];
    return GestureDetector(
      onTap: () {
        DataBase().updateMssgLen(nam, document.data["chatroomid"], 0);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatMssgScreen(
                      chatroomId: document.data["chatroomid"],
                      sendername: nam,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        // color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nam, style: ktxt_chatNameStyle),
                istyping
                    ? TyperAnimatedTextKit(
                        text: ["$k_istyping..."],
                        duration: Duration(seconds: 1),
                        textStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      )
                    : SizedBox(
                        height: 13,
                      ),
              ],
            ),
            //*this shows us the new arrival of mssg to the user
            mssglength != 0
                ? Container(
                    height: 20,
                    width: 20,
                    child: Center(child: Text("$mssglength")),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: k_yellow_color),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
