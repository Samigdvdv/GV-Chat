import 'package:flutter/material.dart';
import 'package:gvchat/widgets/chats/new_message.dart';

import '../widgets/chats/messages.dart';
import '../helpers/screen_arguements.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chats';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0d0b14),
        title: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage(
                'assets/images/person.png',
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(args.username),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(args.chatRoomId),
          ),
          NewMessage(args.chatRoomId),
        ],
      ),
    );
  }
}
