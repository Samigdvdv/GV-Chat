import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  createChatRoom(String chatRoomId, List<String> users) async {
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .set({
      'chatroomId': chatRoomId,
      'users': users,
      'unreadMessages': 0,
      'latestMessage': '',
      'timestamp': Timestamp.now(),
    });
  }

  createGroup(
      String userId, List<dynamic> users, String title, String imageUrl) {
    return FirebaseFirestore.instance.collection('group').add({
      'dp': imageUrl,
      'groupId': '',
      'title': title,
      'members': users,
      'admin': userId,
      'unreadMessages': 0,
      'latestMessage': '',
      'timestamp': Timestamp.now(),
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('group')
          .doc(value.id)
          .update({
        'groupId': value.id,
      });
      return value.id;
    });
  }
}
