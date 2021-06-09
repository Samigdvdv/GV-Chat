import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gvchat/constants.dart';

class NewMessage extends StatefulWidget {
  final String chatRoomId;
  NewMessage(this.chatRoomId);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    // final user = await FirebaseAuth.instance.currentUser();
    // final userData =
    //     await Firestore.instance.collection('users').document(user.uid).get();
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .add({
      'message': _enteredMessage,
      'sender': Constants.myUserName,
      'createdAt': Timestamp.now(),
    });
    _controller.clear();
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.chatRoomId)
        .update({
      'latestMessage': _enteredMessage,
      'timestamp': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.send_rounded),
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendMessage,
                ),
                isDense: true,
                contentPadding: EdgeInsets.only(left: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    )),
                filled: true,
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary),
                fillColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.2),
                hintText: 'Send a message',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
