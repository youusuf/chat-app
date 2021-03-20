import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final fireStore = FirebaseFirestore.instance;
User loggedInUser;
class ChatScreen extends StatefulWidget {
  static String id = 'Chat_Screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {

   String messageText;
   TextEditingController messageTextController = TextEditingController();

   var auth = FirebaseAuth.instance;
   @override
  void initState() {
     super.initState();
    getLoggedUser();
  }
   void getLoggedUser()async{
     try{
       var user = await auth.currentUser;
       if(user!=null){
         loggedInUser = user;
       }

     }catch(e){
       print(e);
     }

   }
 /*  void messagesStream() async {
     await for (var snapshot in fireStore.collection('messages').snapshots()) {
       for (var message in snapshot.docs) {
         print(message.data());
       }
     }
   }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                   auth.signOut();
                   Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
                MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                          fireStore.collection("msg").add({
                            "text":messageText,
                            "sender":loggedInUser.email,
                          });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore.collection('msg').snapshots(),
      builder:(context,snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for(var message in messages){
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final currentUser = loggedInUser.email;
          final messageBubble =MessageBubble(
            sender:messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            children:messageBubbles,
          ),
        );

        return null;
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  MessageBubble({this.sender,this.text,this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54
            ),

          ),
          Material(
            elevation: 10.0,
            color: isMe ? Colors.lightBlueAccent:Colors.white,
            borderRadius:isMe?BorderRadius.only(
              topLeft: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ):BorderRadius.only(
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: Text(
                    text,
                style: TextStyle(
                  color: isMe?Colors.black:Colors.black54,
                  fontSize: 15.0
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

