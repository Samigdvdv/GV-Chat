import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gvchat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './chat_screen.dart';
import '../helpers/screen_arguements.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    Constants.myUserName = userData.data()!['username'].toString();
    Constants.myEmail = userData.data()!['email'];
    Constants.imageUrl = userData.data()!['image'];
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chatroom")
            .orderBy('timestamp', descending: true)
            .where('users.' + Constants.myUserName, isEqualTo: true)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> chatroomSnapshot) {
          if (chatroomSnapshot.connectionState == ConnectionState.waiting ||
              !chatroomSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final chatroomDocs = chatroomSnapshot.data!.docs;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: chatroomDocs.isEmpty
                ? Center(
                    child: Text(
                      'No conversations!',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: chatroomDocs.length,
                    itemBuilder: (context, index) {
                      final String username = chatroomDocs[index]['chatroomId']
                          .toString()
                          .replaceAll('~', '')
                          .replaceFirst(Constants.myUserName, '');
                      int l = chatroomDocs[index]['latestMessage']
                          .toString()
                          .length;
                      return chatroomDocs[index]['latestMessage']
                              .toString()
                              .isEmpty
                          ? Container()
                          : Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        ChatScreen.routeName,
                                        arguments: ScreenArguments(username,
                                            chatroomDocs[index]['chatroomId']));
                                  },
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: Constants.imageUrl.isEmpty
                                        ? AssetImage(
                                            'assets/images/person.png',
                                          )
                                        : NetworkImage(
                                            Constants.imageUrl,
                                          ) as ImageProvider,
                                  ),
                                  title: Text(
                                    username,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    l > 40
                                        ? "${chatroomDocs[index]['latestMessage'].toString().substring(0, 40)}..."
                                        : chatroomDocs[index]['latestMessage'],
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                    }),
          );
        });
  }
}
