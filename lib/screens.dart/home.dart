import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat/screens.dart/chatpage.dart';
import 'package:my_chat/screens.dart/signin.dart';
import 'package:my_chat/services/auth.dart';
import 'package:my_chat/services/database.dart';
import 'package:my_chat/services/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => __HomeScreenState();
}

class __HomeScreenState extends State<HomeScreen> {
  bool search = false;
  String? myName, myPic, myEmail, myUsername;
  Stream? chatroomstream;
  getthesharedpref() async {
    myName = await SharedPReferenceData().getUSerName();
    myEmail = await SharedPReferenceData().getUSerEmail();
    myPic = await SharedPReferenceData().getUSerPic();
    myUsername = await SharedPReferenceData().getUSerName();
    setState(() {});
  }

  Widget chatroomlist() {
    return StreamBuilder(
        stream: chatroomstream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return ChatroomListTile(
                        myUsername: myUsername!,
                        lastmessage: ds["lastmessage"],
                        time: ds["lastmessagets"],
                        chatroomId: ds.id);
                  })
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  getIdbyusername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$a\_$b";
    } else {
      return "$b\_$a";
    }
  }

  onload() async {
    await getthesharedpref();
    chatroomstream = await DatabaseOperations().getChatRooms();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onload();
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    var capitalizedvalue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseOperations().Search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; i++) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element["UserName"].startsWith(capitalizedvalue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  Future<void> _showSignOutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Do you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await AuthMethods().signout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) =>  const SignIn()),
                );
              },
              child: const Text('Sign Out'),
            ),
            
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 57, 1, 66),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  search
                      ? SizedBox(
                          width: size.width / 1.5,
                          child: TextField(
                            onChanged: (value) {
                              initiateSearch(value.toUpperCase());
                            },
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(50)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(50)),
                                filled: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                hintText: 'Search User',
                                hintStyle: const TextStyle(
                                    color: Color.fromARGB(255, 231, 229, 229))),
                          ))
                      : const Text(
                          'Chatify',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                  const Spacer(),
                  search
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              search = false;
                            });
                          },
                          icon: const Icon(Icons.close),
                          iconSize: 35,
                          color: Colors.white,
                        )
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              search = true;
                            });
                          },
                          icon: const Icon(Icons.search),
                          iconSize: 35,
                          color: Colors.white,
                        ),
                  IconButton(
                      onPressed: () {
                        _showSignOutConfirmationDialog();
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            Container(
              height: search ? size.height / 1.169 : size.height / 1.145,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  search
                      ? ListView(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          primary: false,
                          shrinkWrap: true,
                          children: tempSearchStore.map((element) {
                            return buildResultCard(element);
                          }).toList(),
                        )
                      : chatroomlist()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          search = false;
        });
        var chatId = getIdbyusername(myUsername!, data["UserName"]);
        Map<String, dynamic> chatroomInfoMap = {
          "users": [myUsername, data["UserName"]],
        };
        await DatabaseOperations().createchatroom(chatId, chatroomInfoMap);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ChatPage(
              name: data["Name"],
              profilepic: data["Photo"],
              username: data["UserName"]);
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      data['Photo'],
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['Name'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      data["UserName"],
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatroomListTile extends StatefulWidget {
  const ChatroomListTile(
      {super.key,
      required this.myUsername,
      required this.lastmessage,
      required this.time,
      required this.chatroomId});
  final String myUsername, lastmessage, time, chatroomId;

  @override
  State<ChatroomListTile> createState() => _ChatroomListTileState();
}

class _ChatroomListTileState extends State<ChatroomListTile> {
  String name = "", profilepic = "", username = "", id = "";

  getthisUserInfo() async {
    username =
        widget.chatroomId.replaceAll("_", "").replaceAll(widget.myUsername, "");
    QuerySnapshot querySnapshot =
        await DatabaseOperations().getUserInfo(username.toUpperCase());
    name = "${querySnapshot.docs[0]["Name"]}";
    profilepic = "${querySnapshot.docs[0]["Photo"]}";
    id = "${querySnapshot.docs[0]["Id"]}";
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getthisUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ChatPage(
                name: name, profilepic: profilepic, username: username);
          }));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profilepic == ""
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      'assets/images/user.png',
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      profilepic,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  username,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    widget.lastmessage,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.black45,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              widget.time,
              style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
