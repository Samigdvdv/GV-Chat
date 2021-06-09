import 'package:flutter/material.dart';

import '../../constants.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  MessageBubble({
    required this.isMe,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: 3 * MediaQuery.of(context).size.width / 4,
      ),
      padding: EdgeInsets.only(
        left: isMe ? 0 : 16,
        right: isMe ? 16 : 0,
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 12,
              backgroundImage: Constants.imageUrl.isEmpty
                  ? AssetImage(
                      'assets/images/person.png',
                    )
                  : NetworkImage(
                      Constants.imageUrl,
                    ) as ImageProvider,
            ),
          if (!isMe)
            SizedBox(
              width: 10,
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: 3 * MediaQuery.of(context).size.width / 4,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.primary
                  : Color(0x1AFFFFFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
              ),
            ),
            child: Text(
              message,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      // child: Row(
      //   mainAxisAlignment:
      //       isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      //   children: [
      //     if (!isMe)
      //       CircleAvatar(
      //         radius: 12,
      //         backgroundImage: AssetImage(
      //           'assets/images/person.png',
      //         ),
      //       ),
      //     SizedBox(
      //       width: 7,
      //     ),
      //     Container(
      //       decoration: BoxDecoration(
      //         gradient: isMe
      //             ? LinearGradient(colors: [
      //                 Theme.of(context).colorScheme.primary,
      //                 Theme.of(context).colorScheme.secondary,
      //               ])
      //             : null,
      //         color: isMe ? null : Colors.grey,
      //       ),
      //     ),
      //     Text(message),
      //   ],
      // ),
    );
  }
}
