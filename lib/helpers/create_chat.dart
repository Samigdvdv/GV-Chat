import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  createChatRoom(String chatRoomId, List<Map<String, String>> users) {
    FirebaseFirestore.instance.collection('chatroom').doc(chatRoomId).set({
      'chatroomId': chatRoomId,
      'users': users,
      'latestMessage': '',
      'timestamp': Timestamp.now(),
    });
  }
}
