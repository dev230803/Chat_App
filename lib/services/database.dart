import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_chat/services/shared_preference.dart';


class DatabaseOperations{

  Future addData(Map<String,dynamic>userInfo,String id)async{
         return await FirebaseFirestore.instance. collection("users").doc(id).set(userInfo);
  }
   Future<QuerySnapshot> getUserbyemail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot>Search(String username)async{
    return await FirebaseFirestore.instance.collection("users").where("SearchKey",isEqualTo: username.substring(0,1).toUpperCase()).get();
  }

  createchatroom(chatPageroomId,Map<String,dynamic>map)async{
     final snapshot= await FirebaseFirestore.instance.collection("chatrooms").doc(chatPageroomId).get();
     if(snapshot.exists){
      return true;
     }
     else{
      return await FirebaseFirestore.instance.collection("chatrooms").doc(chatPageroomId).set(map);
     }
  }

  Future addMessage(String messageId,String chatroomId,Map<String,dynamic>infoMessage)async{
    return await FirebaseFirestore.instance.collection('chatrooms').doc(chatroomId).collection('chats').doc(messageId).set(infoMessage);

  }
  updateLastMessage(String chatRoomId,Map<String,dynamic>lastInfoMap){
    return FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).update(lastInfoMap);
  }

  Future<Stream<QuerySnapshot>>getChatRoomMessage(chatroomId)async{
    return  FirebaseFirestore.instance.collection('chatrooms').doc(chatroomId).collection('chats').orderBy('time',descending: true).snapshots();
  }

  Future<QuerySnapshot>getUserInfo(String username)async{
    return await FirebaseFirestore.instance.collection('users').where('UserName',isEqualTo: username).get();

  }

  Future<Stream<QuerySnapshot>>getChatRooms()async{
    String? myUsername=await SharedPReferenceData().getUSerName();
    return await FirebaseFirestore.instance.collection('chatrooms').orderBy('time',descending: true).where('users',arrayContains: myUsername).snapshots();

  }
}