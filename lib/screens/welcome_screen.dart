import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/screens/login_screen.dart';
import 'package:flutter_firebase_chat_app/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_firebase_chat_app/components/rounded_button.dart';
class WelcomeScreen extends StatefulWidget {
 static String id = "Welcome_Screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
        vsync: this,
      upperBound: 100
    );
    animation = ColorTween(
        begin: Colors.grey,
        end: Colors.white
    ).animate(controller);

    controller.forward();

    controller.addListener(() {
     setState(() {

     });
    });
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "jump",
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Expanded(
                  child: TypewriterAnimatedTextKit(
                    text: ["DO CHAT"],
                    textStyle: TextStyle(
                      fontSize: 35.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
           RoundedButton(
             color: Colors.blue,
             onPressed:(){
               Navigator.pushNamed(context, LoginScreen.id);
             },
             title: "Log In",
           ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              onPressed:(){
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              title: "Registration",
            ),

          ],
        ),
      ),
    );
  }
}












