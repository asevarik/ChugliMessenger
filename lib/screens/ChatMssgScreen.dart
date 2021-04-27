import 'package:chuglimessenger/constants.dart';
import 'package:chuglimessenger/helper/GlobalContants.dart';
import 'package:chuglimessenger/screens/HomeScreen.dart';
import 'package:chuglimessenger/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';

class ChatMssgScreen extends StatefulWidget {
  static final screenname = "ChatMssgScreen";
  final sendername;
  final String chatroomId;
  ChatMssgScreen({this.chatroomId, this.sendername});
  @override
  _ChatMssgScreenState createState() => _ChatMssgScreenState();
}

class _ChatMssgScreenState extends State<ChatMssgScreen> {
  TextEditingController messagecontroller = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  DataBase db;
  Stream mssgStream, chatroomStream;
  double containerheight;
  int numberofmessgs = 0;
  @override
  void initState() {
    DataBase().isTypingchecker(widget.chatroomId).then((value) {
      setState(() {
        chatroomStream = value;
      });
    });
    DataBase().conversationMessages(widget.chatroomId).then((value) {
      setState(() {
        print(value);
        mssgStream = value;
      });
    });
    Timer(
        Duration(milliseconds: 300),
        () => _scrollController
            .jumpTo(_scrollController.position.minScrollExtent));

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // DataBase().updateMssgLen(GlobalContants.username, widget.chatroomId, 0);
    print("Disposed called");
    super.dispose();
  }

  void sendMessage() {
    if (messagecontroller.text.isNotEmpty) {
      numberofmessgs += 1;
      Map<String, dynamic> messageMap = {
        "message": messagecontroller.text,
        "sendBy": GlobalContants.username,
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      DataBase().addConversationMessages(
          GlobalContants.uid, widget.chatroomId, messageMap);
      messagecontroller.clear();
      DataBase().updateMssgLen(
          GlobalContants.username, widget.chatroomId, numberofmessgs);
    }
  }

  double keyboarddetector() {
    if (MediaQuery.of(context).viewInsets.bottom == 0) {
      print("keyboard closed");
      updateTyping(GlobalContants.username, false);

      return containerheight = MediaQuery.of(context).size.height - 168;
    } else {
      print("keyboard opened");
      updateTyping(GlobalContants.username, true);
      return MediaQuery.of(context).size.height - 520;
    }
  }

  void updateTyping(String name, bool istyping) {
    DataBase().isTypingPresence(name, widget.chatroomId, istyping);
  }

  Widget chatMessageList() {
    String time12hour(int time) {
      return DateFormat('hh:mm a')
          .format(DateTime.fromMicrosecondsSinceEpoch(time));
    }

    return StreamBuilder(
        stream: chatroomStream,
        builder: (context, snap) {
          //document access ese krna he
          if (snap.hasData) {
            return StreamBuilder(
                stream: mssgStream,
                builder: (context, snapshot) {
                  var dpIndex;
                  var name = snap.data['users'][0] == GlobalContants.username
                      ? snap.data['users'][1]
                      : snap.data['users'][0];
                  Timer(
                      Duration(milliseconds: 300),
                      () => _scrollController
                          .jumpTo(_scrollController.position.minScrollExtent));

                  return snapshot.hasData
                      ? Container(
                          height: keyboarddetector(),
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: snap.data['${name}istyping']
                                  ? snapshot.data.documents.length + 1
                                  : snapshot.data.documents.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                if (snap.data["${name}istyping"]) {
                                  dpIndex = index - 1;
                                  if (index == 0) {
                                    return IstypingmssgBubble(name: name);
                                  }
                                } else {
                                  dpIndex = index;
                                }
                                return MessageBubble(
                                  chatroomId: widget.chatroomId,
                                  documentID: snapshot.data.documents[dpIndex]
                                      .reference.documentID,
                                  text: snapshot
                                      .data.documents[dpIndex].data["message"],
                                  isMe: snapshot.data.documents[dpIndex]
                                          .data["sendBy"] ==
                                      GlobalContants.username,
                                  sender: snapshot
                                      .data.documents[dpIndex].data["sendBy"],
                                  time: time12hour(snapshot
                                      .data.documents[dpIndex].data["time"]),
                                  iseen: snap.data["${widget.sendername}iseen"],
                                );
                              }),
                        )
                      : Container();
                });
          } else {
            return Container();
          }
        });
  }

  Future<bool> handleBack() async {
    await Navigator.pushReplacementNamed(context, HomeScreen.screenname);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: handleBack,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: k_cement_color,
              size: 35,
            ),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, HomeScreen.screenname),
          ),
          title: Text(
            widget.sendername,
            style: ktxt_headingstyle.copyWith(fontSize: 30),
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Stack(
              children: [
                chatMessageList(),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: k_cement_color,
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 2,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextField(
                          controller: messagecontroller,
                          style: TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: "$k_messg....",
                            border: InputBorder.none,
                          ),
                        )),
                        GestureDetector(
                          onTap: () {
                            sendMessage();
                            Timer(
                                Duration(milliseconds: 500),
                                () => _scrollController.jumpTo(_scrollController
                                    .position.minScrollExtent));
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFF)
                                ]),
                                borderRadius: BorderRadius.circular(40)),
                            child: Icon(
                              FontAwesomeIcons.telegram,
                              color: k_yellow_color,
                              size: 28,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text, sender;
  final bool isMe;
  final String time;
  final String documentID, chatroomId;
  final bool iseen;
  MessageBubble({
    this.text,
    this.sender,
    this.isMe,
    this.time,
    this.iseen,
    @required this.documentID,
    @required this.chatroomId,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        isMe && text != "this message is deleted"
            ? showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(k_lbl_DeleteMessg),
                  content: Text(k_content_DeleteMessg),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(k_No)),
                    FlatButton(
                        onPressed: () async {
                          await DataBase()
                              .deleteChatMessages(chatroomId, documentID);
                          Navigator.pop(context);
                        },
                        child: Text(k_Yes))
                  ],
                ),
              )
            : null;
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Material(
                borderRadius: isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0))
                    : BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0)),
                elevation: 5.0,
                color: isMe ? k_yellow_color : k_cement_color,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: isMe ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        time,
                        style: ktxt_chatNameStyle.copyWith(
                            fontSize: 10, color: Colors.black54),
                      ),
                      // isMe
                      //     ? Text(
                      //         "seen",
                      //         style: TextStyle(
                      //           fontSize: 15.0,
                      //           color: isMe ? Colors.white : Colors.black87,
                      //         ),
                      //       )
                      //     : SizedBox(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IstypingmssgBubble extends StatelessWidget {
  final String name;
  IstypingmssgBubble({this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0)),
              elevation: 5.0,
              color: k_cement_color,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TyperAnimatedTextKit(duration: Duration(seconds: 2), text: [
                      '$name is Typing...',
                    ])
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
