import 'package:chuglimessenger/Components/ThemeProvider.dart';
import 'package:chuglimessenger/constants.dart';
import 'package:chuglimessenger/helper/GlobalContants.dart';
import 'package:chuglimessenger/helper/helperfunctions.dart';
import 'package:chuglimessenger/screens/ChatRoomScreen.dart';
import 'package:chuglimessenger/screens/ProfileScreen.dart';
import 'package:chuglimessenger/screens/Welcomescreen.dart';
import 'package:chuglimessenger/screens/nointernetscreen.dart';
import 'package:chuglimessenger/services/auth.dart';
import 'package:chuglimessenger/services/database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'UserScreen.dart';
import 'package:connectivity/connectivity.dart';

class HomeScreen extends StatefulWidget {
  static final screenname = '/Chat';
  var namedata;
  HomeScreen({this.namedata});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isConnectedToInternet = true;
  final Auth _auth = Auth();
  Stream chatroomStream;
  Stream onlineUsersStream;
  DataBase db = new DataBase();

  @override
  void initState() {
    super.initState();
    initalNetworkcheck();
    checkNetowrkStatus();
    getinfo();
  }

  void initalNetworkcheck() async {
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        setState(() {
          isConnectedToInternet = false;
        });
      }
    });
  }

  void checkNetowrkStatus() async {
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile) {
        changeStatus(true);
      } else {
        changeStatus(false);
      }
    });
  }

  void changeStatus(bool isconnected) {
    setState(() {
      isConnectedToInternet = isconnected;
    });
  }

//sets the local db data to the global constants
  void getinfo() async {
    GlobalContants.username = await HelperFunctions().getUsername();
    GlobalContants.useremail = await HelperFunctions().getUseremail();
    GlobalContants.uid = await HelperFunctions().getuserid();
    getstream();
  }

  void getstream() async {
    await db.getChatRooms(GlobalContants.username).then((value) {
      setState(() {
        chatroomStream = value;
      });
    });
    await db.getOnlineUsers().then((value) {
      setState(() {
        onlineUsersStream = value;
      });
    });
    await db.updateUserpresence(GlobalContants.uid, true);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          // backgroundColor: ,

          appBar: AppBar(
            automaticallyImplyLeading: false,
            // backgroundColor: k_app_backgroundcolor,
            title: Text(
              k_ChugliChat,
              style: ktxt_headingstyle.copyWith(fontSize: 30),
            ),
            actions: [
              Switch(
                  value: themeProvider.isDarkMode,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    print(value);
                    final provider =
                        Provider.of<ThemeProvider>(context, listen: false);
                    provider.toggleTheme(value);
                  }),
              PopupMenuButton(onSelected: (index) {
                if (index == 0) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(k_Logout),
                            content: Text(k_AreyouSure),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(k_No)),
                              FlatButton(
                                  onPressed: () async {
                                    if (isConnectedToInternet) {
                                      await _auth.Signout();
                                      await DataBase().updateUserpresence(
                                          GlobalContants.uid, false);
                                      await HelperFunctions()
                                          .clearsharedPrefs();
                                      Navigator.pushReplacementNamed(
                                          context, WelcomeScreen.screenname);
                                    }
                                  },
                                  child: Text(k_Yes))
                            ],
                          ));
                }
              }, itemBuilder: (context) {
                return List.generate(1, (index) {
                  return PopupMenuItem(
                      value: index, child: Text(k_popMenuItems[index]));
                });
              })
              // IconButton(
              //     icon: Icon(
              //       FontAwesomeIcons.signOutAlt,
              //       color: k_cement_color,
              //     ),
              //     onPressed: () async {
              //       if (isConnectedToInternet) {
              //         await _auth.Signout();
              //         await HelperFunctions().clearsharedPrefs();
              //         Navigator.pushReplacementNamed(
              //             context, WelcomeScreen.screenname);
              //       }
              //     })
            ],
            bottom: TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: k_cement_color, width: 5.0),
                insets: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              tabs: [
                Container(
                  height: 35,
                  child: Text(
                    k_Chats,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  height: 35,
                  child: Text(
                    k_Users,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          body: isConnectedToInternet
              ? TabBarView(
                  children: [
                    ChatRoomScreen(
                      chatroomStream: chatroomStream,
                    ),
                    UserScreen(
                      userstream: onlineUsersStream,
                    ),
                  ],
                )
              : NoInternetScreen()),
    );
  }
}
