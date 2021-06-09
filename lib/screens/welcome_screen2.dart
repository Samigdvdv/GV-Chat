import 'package:flutter/material.dart';

import './login_screen.dart';
import './signup_screen.dart';
import '../gv_chat_icons.dart';
import '../buttons/primary_button.dart';

class WelcomeScreen2 extends StatefulWidget {
  static const routeName = '/welcome';
  const WelcomeScreen2({Key? key}) : super(key: key);

  @override
  _WelcomeScreen2State createState() => _WelcomeScreen2State();
}

class _WelcomeScreen2State extends State<WelcomeScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  //   SizedBox(
                  //   height: 30,
                  // ),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    width: 150,
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.blue,
                        Colors.deepPurple,
                        Colors.pink,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'GV Chat',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              // Spacer(),
              Column(
                children: [
                  PrimaryButton(
                    icon: Icons.add_box_outlined,
                    text: 'Create new account',
                    press: () {
                      Navigator.of(context).pushNamed(SignupScreen.routeName);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  PrimaryButton(
                      icon: Icons.account_box_outlined,
                      press: () {
                        Navigator.of(context).pushNamed(LoginScreen.routeName);
                      },
                      text: 'Login to your account'),
                  SizedBox(
                    height: 10,
                  ),
                  PrimaryButton(
                      icon: CustomIcons.google,
                      press: () {},
                      text: 'Continue with Google'),
                ],
              ),
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
