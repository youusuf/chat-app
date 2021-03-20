import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/components/rounded_button.dart';
import 'package:flutter_firebase_chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat_app/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class RegistrationScreen extends StatefulWidget {
  static String id = "Registration_Screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}
class _RegistrationScreenState extends State<RegistrationScreen> {

    bool  showSpin= false;
    String email;
    String password;
    var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpin,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'jump',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                      email = value;
                  },
                  decoration: KTextFieldDecoration.copyWith(
                    hintText: "Enter Yours Email",

                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: KTextFieldDecoration.copyWith(
                    hintText: "Enter your password"
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  onPressed:()async{
                    setState(() {
                      showSpin = true;
                    });
                          try{
                            final user =await auth.createUserWithEmailAndPassword(email: email, password: password);
                            if(user!=null){
                              Navigator.pushNamed(context, ChatScreen.id);
                            }
                            setState(() {
                              showSpin = false;
                            });
                          }catch(e){
                              print(e);
                          }

                  },
                  color: Colors.lightBlueAccent,
                  title: "Registration",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
