import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humane_chat/helper/constants.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection(Constants.USERS_COLLECTION)
        .where(Constants.USER_NAME, isEqualTo: username)
        .get()
        .catchError((e) {
      print(e.toString() + "errors");
    });
  }

  getUserByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection(Constants.USERS_COLLECTION)
        .where(Constants.USER_NAME, isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(Map<String, dynamic> userMap) {
    FirebaseFirestore.instance
        .collection(Constants.USERS_COLLECTION)
        .add(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, Map<String, dynamic> chatRoomMap) {
    FirebaseFirestore.instance
        .collection(Constants.CHAT_ROOM)
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, Map<String, dynamic> messageMap) {
    FirebaseFirestore.instance
        .collection(Constants.CHAT_ROOM)
        .doc(chatRoomId)
        .collection(Constants.COLLECTION_CHATS)
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection(Constants.CHAT_ROOM)
        .doc(chatRoomId)
        .collection(Constants.COLLECTION_CHATS)
        .orderBy(Constants.TIME, descending: true)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await FirebaseFirestore.instance
        .collection(Constants.CHAT_ROOM)
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
