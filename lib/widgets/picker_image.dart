import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class PickerImage extends StatefulWidget {
  const PickerImage({super.key , required this.selectedImage});
  final  void  Function  (File imageSeleced) selectedImage;
@override
State<PickerImage> createState (){

 return   _PickerImage ();

}
}


class _PickerImage extends  State<PickerImage>  {
  File? pickerImage;
  void pickimage () async{
       final pickedImage =  await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 150)  ;
      if(pickedImage==null){
        return ;
      }
   setState(() {
      pickerImage =File(pickedImage.path);
   });
  
    widget.selectedImage(pickerImage!);


  }
@override
Widget build(context){

 return  Column(
  children: [
     CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 40,
        foregroundImage:    pickerImage!=null? FileImage(pickerImage!): null ,
     ),
      TextButton.icon(onPressed: pickimage, label: Text("Add Image" , style: TextStyle( color:  Theme.of(context).primaryColor,)), icon: Icon(Icons.image),),

  ],
 ) ;


}
}