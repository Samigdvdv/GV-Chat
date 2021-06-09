import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/chat_screen.dart';

import '../constants.dart';
import 'package:gvchat/helpers/create_chat.dart';
import '../helpers/screen_arguements.dart';

class SearchUser extends SearchDelegate<String> {
  startConversation(String username, String image) {
    final chatRoomId = getChatRoomId(username, Constants.myUserName);
    List<Map<String, String>> users = [
      {
        username: image,
        Constants.myUserName: Constants.imageUrl,
      }
    ];
    DatabaseMethods().createChatRoom(chatRoomId, users);
    return chatRoomId;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    print("build Actions override");
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    print("build Leading override");
    return IconButton(
      onPressed: () => close(context, ''),
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // ignore: todo
    // TODO: implement buildResults
    print("build Results override");
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print("build suggestions override");
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where("searchKeywords", arrayContains: query)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? Center(child: CircularProgressIndicator())
            : snapshot.data!.docs.isEmpty
                ? Center(
                    child: Text(
                      'No results found!',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data!.docs[index];
                          return Constants.myUserName != data['username']
                              ? Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        final chatRoomId = startConversation(
                                            data['username'], data['image']);
                                        print(chatRoomId);
                                        Navigator.of(context).popAndPushNamed(
                                            ChatScreen.routeName,
                                            arguments: ScreenArguments(
                                                data['username'], chatRoomId));
                                      },
                                      leading: CircleAvatar(
                                        radius: 20,
                                        backgroundImage: data['image'].isEmpty
                                            ? AssetImage(
                                                'assets/images/person.png',
                                              )
                                            : NetworkImage(
                                                data['image'],
                                              ) as ImageProvider,
                                      ),
                                      title: Text(
                                        data['username'],
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                )
                              : Container();
                        }),
                  );
      },
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.compareTo(b) == 1) {
    return "$b\~$a";
  } else {
    return "$a\~$b";
  }
}
