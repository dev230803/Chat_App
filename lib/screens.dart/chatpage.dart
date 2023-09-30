import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_chat/screens.dart/home.dart';
import 'package:my_chat/services/database.dart';
import 'package:my_chat/services/shared_preference.dart';
import 'package:random_string/random_string.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key,
      required this.name,
      required this.profilepic,
      required this.username});
  final String name, profilepic, username;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messagecontroller = TextEditingController();
  String? myName, myEmail, myProfilePic, myUsername, messageId, chatroomId;
  Stream? meassageStream;

  getSharedPref() async {
    myName = await SharedPReferenceData().getUSerName();
    myEmail = await SharedPReferenceData().getUSerEmail();
    myProfilePic = await SharedPReferenceData().getUSerPic();
    myUsername = await SharedPReferenceData().getUSerName();
    chatroomId = getIdbyusername(widget.username, myUsername!);
    setState(() {});
  }

  onload() async {
    await getSharedPref();
    await getAndsetMessage();
    setState(() {});
  }

  getIdbyusername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$a\_$b";
    } else {
      return "$b\_$a";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onload();
  }

  Widget messageTile(bool sendbyMe, String message) {
    return Row(
      mainAxisAlignment:
          sendbyMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(24),
                bottomRight: sendbyMe
                    ? const Radius.circular(0)
                    : const Radius.circular(24),
                topRight: const Radius.circular(24),
                bottomLeft: sendbyMe
                    ? const Radius.circular(24)
                    : const Radius.circular(0)),
            color: sendbyMe
                ? const Color.fromARGB(255, 234, 236, 240)
                : Colors.white,
          ),
          child: Text(
            message,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.w500),
          ),
        ))
      ],
    );
  }

  Widget chatMessage() {
    return StreamBuilder(
        stream: meassageStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90, top: 130),
                  itemCount: snapshot.data.docs.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return messageTile(
                        ds["sendby"] == myUsername, ds["message"]);
                  })
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  addMessage(bool sendClicked) {
    if (messagecontroller.text.isNotEmpty) {
      String message = messagecontroller.text;
      messagecontroller.text = "";
      DateTime now = DateTime.now();
      String formatted = DateFormat('h:mma').format(now);
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendby": myUsername,
        "ts": formatted,
        "time": FieldValue.serverTimestamp(),
        "imageUrl": myProfilePic,
      };

      messageId ??= randomAlphaNumeric(10);

      DatabaseOperations()
          .addMessage(messageId!, chatroomId!, messageInfoMap)
          .then(
        (value) {
          Map<String, dynamic> LastMessageInfo = {
            "lastmessage": message,
            "lastmessagets": formatted,
            "sendby": myUsername,
            "time": FieldValue.serverTimestamp(),
          };
          DatabaseOperations().updateLastMessage(chatroomId!, LastMessageInfo);

          if (sendClicked) {
            messageId = null;
          }
        },
      );
    }
  }

  getAndsetMessage() async {
    meassageStream = await DatabaseOperations().getChatRoomMessage(chatroomId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF553370),
      body: Container(
        padding: const EdgeInsets.only(top: 60.0),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.12,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
              ),
              child: chatMessage()),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                        return const HomeScreen();
                      }));
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Color(0Xffc199cd),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    widget.name,
                    style: const TextStyle(
                        color: Color(0Xffc199cd),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
              alignment: Alignment.bottomCenter,
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child:
                       TextField(
                          controller: messagecontroller,
                          decoration:  InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                addMessage(true);
                              },
                              child: Icon(Icons.send_rounded)),
                              border: InputBorder.none,
                              hintText: "Type a message",
                              hintStyle: TextStyle(color: Colors.black45)),
                        ),
                      ),
                      
                    
                  ),
            ),
                
              
            
          ],
        ),
      ),
    );
  }
}
