
import 'package:chatapp/screans/auth.dart';
import 'package:chatapp/screans/chat_screan.dart';
import 'package:chatapp/screans/splach_scren.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main()  async{

WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: ThemeData().copyWith(
       
        colorScheme: ColorScheme.fromSeed(
            seedColor:const Color.fromARGB(255, 38, 21, 228)
            // const Color.fromARGB(255, 17, 57, 177)
            ),

      ),
      home:StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          const  SplachScren();
        }
         if(snapshot.hasData){
          return const   ChatScrean();
         }
         return const  AuthScreen();

      }
 
       
       ,),

    );
  }
}