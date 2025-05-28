import 'package:chatapp/widgets/chat_message.dart';
import 'package:chatapp/widgets/my_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScrean extends StatefulWidget {
  const ChatScrean({super.key});

  @override
  State<ChatScrean> createState() => _ChatScreanState();
}

class _ChatScreanState extends State<ChatScrean> {
void setupPushNotification() async{
  final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    await fcm.subscribeToTopic('chat');
  //  final  getTaken = await fcm.getToken();
   
}
  @override
  void initState() {
    
    // TODO: implement initState
    super.initState();
     setupPushNotification();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
       AppBar(
        title: Text("Flutter chat "),
        actions: [
           IconButton(onPressed: (){
         FirebaseAuth.instance.signOut();

           }, icon: Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.primary,))
        ],

      ),
      body: const   Column(
        children:   [
           MyMessages(),
           Spacer(),
            ChatMessage()

        ],
      )
    );
  }
}