import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gvchat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _controller = new TextEditingController(text: Constants.myUserName);
  var _enteredUsername = '';
  late File _image;
  final picker = ImagePicker();
  var isLoading = false;

  // loadingSpinner(bool isLoading) {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return isLoading
  //             ? Center(
  //                 child: CircularProgressIndicator(),
  //               )
  //             : Container();
  //       });
  // }

  updateUsername(String username) async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      Constants.myUserName = username;
    });
    final searchKeywords = [];
    for (int i = 0; i < username.length; i++) {
      searchKeywords.add(username.substring(0, i + 1));
    }
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'username': username,
      'searchKeywords': searchKeywords,
    });
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  showUpdateUsernameDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Enter your username',
        ),
        content: TextField(
          cursorColor: Theme.of(context).colorScheme.secondary,
          controller: _controller,
          decoration: InputDecoration(
              hintText: 'New username',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )),
          onChanged: (value) {
            setState(() {
              _enteredUsername = value;
            });
          },
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
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              updateUsername(_enteredUsername);
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

  imageUpload() async {
    setState(() {
      isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child(user!.uid + '.jpg');
    await ref.putFile(
      _image,
    );
    final url = await ref.getDownloadURL();
    setState(() {
      Constants.imageUrl = url;
    });
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'image': url,
    });
    setState(() {
      isLoading = false;
    });
  }

  removeImage() async {
    setState(() {
      isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'image': '',
    });
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child(user.uid + '.jpg');
    await ref.delete();
    setState(() {
      Constants.imageUrl = '';
    });
    setState(() {
      isLoading = false;
    });
  }

  pickImagefromGallery() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    _image = File(pickedFile!.path);
    imageUpload();
  }

  pickImagefromCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 150);
    _image = File(pickedFile!.path);
    imageUpload();
  }

  showOptionsForImageUpload() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  pickImagefromCamera();
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_camera,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Text(
                        'Camera',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.transparent,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  pickImagefromGallery();
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.transparent,
                ),
              ),
              if (Constants.imageUrl.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    removeImage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        Text(
                          'Remove',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Colors.transparent,
                  ),
                ),
            ],
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                value: 100,
              ),
            )
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            child: CircleAvatar(
              radius: width / 7,
              backgroundImage: Constants.imageUrl.isEmpty
                  ? AssetImage(
                      'assets/images/person.png',
                    )
                  : NetworkImage(
                      Constants.imageUrl,
                    ) as ImageProvider,
            ),
            onTap: showOptionsForImageUpload,
          ),
          SizedBox(
            height: 30,
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.grey,
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              onPressed: () {
                showUpdateUsernameDialog();
              },
            ),
            onTap: () {
              showUpdateUsernameDialog();
            },
            title: Text(
              'Username',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            selectedTileColor: Colors.white,
            subtitle: Text(
              Constants.myUserName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
              ),
            ),
            horizontalTitleGap: 10,
          ),
          ListTile(
            leading: Icon(
              Icons.mail,
              color: Colors.grey,
            ),
            isThreeLine: true,
            title: Text(
              'Email',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            selectedTileColor: Colors.white,
            subtitle: Text(
              Constants.myEmail,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
              ),
            ),
            horizontalTitleGap: 10,
          ),
        ],
      ),
    );
  }
}
