import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gvchat/helpers/screen_arguements.dart';
import 'package:gvchat/screens/profile_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'search/search.dart';

class AppDrawer extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  showDialogLogout(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Are you sure want to logout?',
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          ElevatedButton(
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              logout();
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('text')
              .doc('playstore_link')
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> textSnapshot) {
            if (textSnapshot.connectionState == ConnectionState.waiting ||
                !textSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            Map<String, dynamic>? textData =
                textSnapshot.data!.data() as Map<String, dynamic>?;

            final text = textData!['link'];
            return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  Map<String, dynamic>? data =
                      snapshot.data!.data() as Map<String, dynamic>?;
                  final username = data!['username'];
                  final imageUrl = data['image'];
                  return Drawer(
                    elevation: 5,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ProfileScreen.routeName,
                                      arguments: ScreenArguments(
                                          chatRoomId: '',
                                          username: username,
                                          imageUrl: imageUrl,
                                          email: data['email']));
                                },
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: imageUrl.isEmpty
                                      ? AssetImage(
                                          'assets/images/person.png',
                                        )
                                      : NetworkImage(
                                          imageUrl,
                                        ) as ImageProvider,
                                ),
                              ),
                              SizedBox(
                                height: 22,
                              ),
                              Text(
                                username,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Divider(
                                indent: 30,
                                endIndent: 30,
                                thickness: 2,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.15),
                              ),
                              ListTile(
                                  onTap: () {
                                    showSearch(
                                        context: context,
                                        delegate:
                                            SearchUser(currentMembers: []));
                                  },
                                  leading: Icon(
                                    Icons.search,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  title: Text(
                                    "Search user",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )),
                              ListTile(
                                leading: Icon(
                                  Icons.group_add,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: Text(
                                  "New group",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                onTap: () {
                                  showSearch(
                                      context: context,
                                      delegate: SearchUser(
                                          isGroup: true, currentMembers: []));
                                },
                              ),
                              ListTile(
                                  onTap: () {
                                    Share.share(text);
                                    // share(context);
                                  },
                                  leading: Icon(
                                    Icons.share,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  title: Text(
                                    "Invite friends",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )),
                              ListTile(
                                  leading: Icon(
                                    Icons.exit_to_app,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onTap: () async {
                                    await showDialogLogout(context);
                                    Navigator.of(context).pop();
                                  },
                                  title: Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  const url =
                                      'https://github.com/dcyrus/GV-Chat/tree/master';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                icon: FaIcon(
                                  FontAwesomeIcons.github,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 35,
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    const url =
                                        'https://www.instagram.com/gvtv_/';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.instagram,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 35,
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
