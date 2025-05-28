// import 'package:flutter/material.dart';

// class ChatMessage extends StatefulWidget {
//   const ChatMessage({super.key});

//   @override
//   State<ChatMessage> createState() => _ChatMessageState();
// }

// class _ChatMessageState extends State<ChatMessage> {
//   final messageController = TextEditingController();
//    @override
//   void dispose() {
//     messageController.dispose();
//     // TODO: implement dispose
//     super.dispose();
//   }
//   void sendMessage (){
//      final enteredMessage = messageController.text;
//      if(enteredMessage.trim().isEmpty){
//       return ;
//      }

//       messageController.clear();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12, right: 8,left: 8),
//       child: Row(
//         children: [
//            Expanded(
//              child: TextField(
//                   controller: messageController,
//               textCapitalization: TextCapitalization.sentences,
//               enableSuggestions: true,
//                autocorrect:  true,
//                     decoration: InputDecoration(
//                      label:  Text( "send message ...",style: TextStyle(color:  Theme.of(context).colorScheme.primary,),)
      
//                     ),
             
//              ),
//            ),
//             IconButton(onPressed: sendMessage, icon: Icon(Icons.send , color: Theme.of(context).colorScheme.primary,))
//         ]
//       ),
//     ) ;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage({super.key});

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
void sendMessage() async {
  final enteredMessage = messageController.text;
  if (enteredMessage.trim().isEmpty) {
    return;
  }
  messageController.clear();
  FocusScope.of(context).unfocus();
  
  final userId = FirebaseAuth.instance.currentUser!;
  final userDate = await FirebaseFirestore.instance.collection('users').doc(userId.uid).get();

  FirebaseFirestore.instance.collection('chat').add({
    'text': enteredMessage,
    'createdAt': Timestamp.now(),
    'userId': userId.uid,  // Fix userId reference
    'username': userDate.data()!['username'],
    'userImage': userDate.data()!['image'],
  });
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 8, left: 8),
      child: Row(
        children: [
          // Message Input Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: messageController,
                textCapitalization: TextCapitalization.sentences,
                enableSuggestions: true,
                autocorrect: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  hintText: "Send a message...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send Button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
