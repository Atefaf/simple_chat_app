// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//  final _firebas = FirebaseAuth.instance;
// class AuthScrean extends StatefulWidget {
//   const AuthScrean({super.key});

//   @override
//   State<AuthScrean> createState() => __AuthScreanState();
// }

// class __AuthScreanState extends State<AuthScrean> {
//   final _form = GlobalKey<FormState>();
//    var email = '';
//    var password = '';
//   var islogin = true;
//   void _submit() async{
//       final valid = _form.currentState!.validate();
//       if(!valid){
//         return ;
//       }
//       if(valid){
//         _form.currentState!.save();

//       }
//  try{
 
//       if(islogin) {
//                   final UserCredential = await _firebas.signInWithEmailAndPassword(email: email, password: password);
//  print(UserCredential);
    
//       }
//       else
//       {
      
//           final UserCredential = await _firebas.createUserWithEmailAndPassword(email: email, password: password);
//  print(UserCredential);
          
//         }  

//         } on FirebaseAuthException catch (e) {
        
//             ScaffoldMessenger.of(context).clearSnackBars();
//            ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(e.message??"aut is faild"))

//            );
//         }

//       }


//   }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//  backgroundColor: const   Color.fromARGB(255, 38, 21, 228),
//       ),
           
//  backgroundColor: const   Color.fromARGB(255, 38, 21, 228),
//       body: SingleChildScrollView(
//         child: Column(
        
//           children: [
//              Container(
//             margin: EdgeInsets.only(
//               bottom: 20,
//               right: 20,
//               left: 40,

//             ),
              
//               width:  200,
               
//                  child: Image.asset('assets/chat.png'),
//              ),
//              Padding(
//               padding: EdgeInsets.all(12),
//                child: Card(
//                 child: Form(
//                    key: _form,
                  
//                   child: 
//               Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         onSaved: (newValue) => 
//                                email=newValue!,
//                         validator: (value) {
//                             if(value==null|| value.trim().isEmpty  ||!value.contains('@')){
//                               return "please enter a valid email adress";
//                             }
//                             return null;
//                         },
//                           decoration: InputDecoration(
//                               labelText: "Email Address"
//                           ),
//                           keyboardType: TextInputType.emailAddress,
//                           autocorrect: false,
//                           textCapitalization: TextCapitalization.none,
//                       ),

//                       TextFormField(
//                         onSaved: (newValue) => password=newValue!,
//                         validator: (value) {
//                            if(value==null|| value.trim().length<6){
//                             return "Your Password should be more thatn 6 character ";
//                            }
//                            return null;
//                         },
                                 
                                 
//                          decoration: InputDecoration(
//                           labelText: "Password",
                                 
//                          ),
//                          obscureText: false,
//                       ),
//                        ElevatedButton(onPressed: _submit, child: Text( islogin?  "login": "signup")),
//                     TextButton(onPressed: (){
//                                setState(() {
//                                    islogin=!islogin;
//                                });

//                     }, child: Text( islogin?"Create a new acount ":"i have already acount ")),
//                     ],
//                   ),
//                 )),
//                ),
//              ),
//           ],
//         ),
//       ),
//     );
//   }

import 'dart:io';

import 'package:chatapp/widgets/picker_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var email = '';
  var password = '';
  var userName ='';
  var isLogin = true;
   File? selectedImage;
   var  isAuthantacting =false;

  void _submit() async {
    final valid = _form.currentState!.validate();
    if (!valid  || selectedImage==null&&!isLogin) {
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        isAuthantacting=true;
      });
      if (isLogin) {
        final userCredential = await _firebase.signInWithEmailAndPassword(email: email, password: password);
        print(userCredential);
      } else {
        final userCredential = await _firebase.createUserWithEmailAndPassword(email: email, password: password);
      final storageRef = FirebaseStorage.instance.ref().child('user_images').child('${userCredential.user!.uid}.jpg');
        await  storageRef.putFile(selectedImage!);
       final imageUrl = await storageRef.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'username': userName,
            'email':    email,
            'password': password,
              'image': imageUrl,


      
        });

      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Auth failed")),
      );
    }
          setState(() {
        isAuthantacting=false;
      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF6A1B9A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 200,
                  child: Image.asset(
                    'assets/chat.png', // Replace this with a new link to your image
                    fit: BoxFit.cover,
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _form,
                      child: Column(
                        children: [
                                    if(!isLogin)
                                       PickerImage(selectedImage: (image){
                                                   selectedImage=image;
                                  },),
                                 
                                   
                                    if(!isLogin)
                                  TextFormField(
  onSaved: (newValue) => userName = newValue!,  // Assuming you have a 'username' variable
  validator: (value) {
    if (value == null || value.trim().isEmpty || value.trim().length<4) {
      return "Please enter a valid username";
    }
    return null;
  },
  decoration: InputDecoration(
    labelText: "Username",
    prefixIcon: Icon(Icons.person),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  keyboardType: TextInputType.text,
  autocorrect: false,
  textCapitalization: TextCapitalization.none,
),
  const SizedBox(height: 20),


                          TextFormField(
                            onSaved: (newValue) => email = newValue!,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty || !value.contains('@')) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            onSaved: (newValue) => password = newValue!,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return "Your password should be more than 6 characters";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          if(isAuthantacting)
                        const    CircularProgressIndicator(),
                          if(!isAuthantacting)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), backgroundColor: Color(0xFF1E88E5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              isLogin ? "Login" : "Signup",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if(!isAuthantacting)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isLogin = !isLogin;
                              });
                            },
                            child: Text(
                              isLogin ? "Create a new account" : "I already have an account",
                              style: TextStyle(color: Color(0xFF1E88E5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
