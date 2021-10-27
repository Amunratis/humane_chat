import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  static const USER_NAME = 'name';
  static const USERS_COLLECTION = 'users';
  static const CHAT_ROOM = 'ChatRoom';

  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .where(USER_NAME, isEqualTo: username)
        .get()
        .catchError((e) {
      print(e.toString() + "errorsss");
    });
  }

  getUserByEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .where(USER_NAME, isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .add(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection(CHAT_ROOM)
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}
