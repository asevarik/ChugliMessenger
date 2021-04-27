import 'package:chuglimessenger/helper/GlobalContants.dart';
import 'package:chuglimessenger/helper/helperfunctions.dart';
import 'package:chuglimessenger/screens/ChatMssgScreen.dart';
import 'package:chuglimessenger/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chuglimessenger/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chuglimessenger/services/auth.dart';
import 'Welcomescreen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);
  static final screenname = "SearchScreen";
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DataBase db = new DataBase();
  Auth _auth = new Auth();
  TextEditingController searchController = new TextEditingController();
  QuerySnapshot searchSnapShot;
  initiateSearch() {
    db.getUserByName(searchController.text).then((value) => {
          setState(() {
            print("setted value to this ");
            searchSnapShot = value;
          })
        });
    print("yaha aaya ");
  }

  Widget searchList() {
    return (searchSnapShot != null)
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapShot.documents.length, //dynamic
            itemBuilder: (context, index) {
              print("idar aaya");
              return SearchResult(
                  name: searchSnapShot.documents[index].data["name"],
                  email: searchSnapShot.documents[index].data["email"],
                  onpress: () {
                    createChatroomAndStartConversation(
                        searchSnapShot.documents[index].data["name"]);
                    print("create chatroom and send user to chatroom");
                  });
            },
          )
        : Container();
  }

  createChatroomAndStartConversation(String usrname) async {
    //!users=[usrname,myname]
    List<String> users = [
      usrname,
      GlobalContants.username
    ]; //shared preference is used for my name
    String chatroomid = await getChatRoomId(usrname, GlobalContants.username);
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomid": chatroomid,
      //main sender name
      "${GlobalContants.username}mssglen": 0,
      //*jisko send kiya uska name
      "${usrname}mssglen": 0,
      "${GlobalContants.username}istyping": false,
      "${usrname}istyping": false,
    };
    print(chatroomid);
    await db.createChatRoom(chatroomid, chatRoomMap);
    //*go to ChatMessge Screen ASAP With chat replacement
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChatMssgScreen(
          chatroomId: chatroomid,
          sendername: usrname,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: ,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            k_ChugliChat,
            style: ktxt_headingstyle.copyWith(fontSize: 30),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  FontAwesomeIcons.signOutAlt,
                  color: k_cement_color,
                ),
                onPressed: () async {
                  //TODO signout then go to login Screen
                  await DataBase()
                      .updateUserpresence(GlobalContants.uid, false);
                  await HelperFunctions().clearsharedPrefs();

                  await _auth.Signout();
                  Navigator.pushReplacementNamed(
                      context, WelcomeScreen.screenname);
                })
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (searchController.text == "" ||
                          searchController.text == GlobalContants.username) {
                        AlertDialog alert = AlertDialog(
                          title: Text('Error'),
                          content: Text(searchController.text !=
                                  GlobalContants.username
                              ? 'TextField is Empty'
                              : 'we know you are lonely but talking to yourself won\'t solve your problems'),
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
                      } else {
                        await initiateSearch();
                      }
                    },
                    icon: Icon(
                      FontAwesomeIcons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              searchList(),
            ],
          ),
        ));
  }
}

class SearchResult extends StatelessWidget {
  final String name;
  final String email;
  final Function onpress;
  SearchResult(
      {@required this.name, @required this.email, @required this.onpress});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: ktxt_chatNameStyle.copyWith(fontSize: 20),
              ),
              Text(
                email,
              ),
            ],
          ),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(k_yellow_color),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              onPressed: onpress,
              child: Text(
                k_messg,
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}

//creates chatroom id
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
