import 'package:chatapp/widgets/bubble.chat.dart';
import 'package:chatapp/widgets/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MyMessages extends StatefulWidget {
  const MyMessages({super.key});

  @override
  State<MyMessages> createState() => _MyMessagesState();
}

class _MyMessagesState extends State<MyMessages> {
   final userId = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(stream: FirebaseFirestore.instance.collection('chat').orderBy('createdAt',
    descending: true).snapshots(), builder: (context, snapshot) {
    if(snapshot.connectionState==ConnectionState.waiting){
  return CircularProgressIndicator();
    }

if(!snapshot.hasData){
  return Center(child: Text("no message found"),);

}
 if(snapshot.hasError){
  return Center(child: Text(" something went wrong  "),);

 }
 final loadeDate = snapshot.data!.docs;
  return Expanded(
    child: ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount:loadeDate.length  ,
    reverse: true,
      
      itemBuilder: (context, index) {
        final ChatMessage=loadeDate[index].data();
        final nexChatMessage = index+1<loadeDate.length?
        loadeDate[index+1].data():null;
        final  currentMessageUserId = ChatMessage['userId'];
        final nexMessageUserId = nexChatMessage!=null? nexChatMessage['userId']:null;
        final  nextuserIsSame = nexMessageUserId==currentMessageUserId;
    
      if(nextuserIsSame){
        return MessageBubble.next(message: ChatMessage['text'], isMe: userId.uid==currentMessageUserId);

      }
      else{
        return MessageBubble.first(userImage: ChatMessage['userImage'], username: ChatMessage['username'], message: ChatMessage['text'], isMe: userId.uid==currentMessageUserId);
        
      }


      }

      
       ,),
  );



    },);
  }
}