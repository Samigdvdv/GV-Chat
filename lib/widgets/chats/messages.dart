import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gvchat/constants.dart';
import 'package:gvchat/widgets/chats/message_bubble.dart';

class Messages extends StatelessWidget {
  final String chatRoomId;
  Messages(this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatroom')
            .doc(chatRoomId)
            .collection('chats')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final chatDocs = chatSnapshot.data!.docs;
          return ListView.builder(
            itemCount: chatDocs.length,
            reverse: true,
            itemBuilder: (ctx, index) => MessageBubble(
              isMe: chatDocs[index]['sender'] == Constants.myUserName,
              message: chatDocs[index]['message'],
            ),
          );
        });
  }
}
