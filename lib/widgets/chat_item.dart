import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/person.png'),
          ),
        ),
      ],
    );
  }
}
