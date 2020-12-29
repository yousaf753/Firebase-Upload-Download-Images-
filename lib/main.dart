import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
 class MyHomePage extends StatefulWidget {
   @override
   _MyHomePageState createState() => _MyHomePageState();
 }
 
 class _MyHomePageState extends State<MyHomePage> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('Firebase'),
       ),
       body: SingleChildScrollView(
         child: Center(
           child: Column(
             children: [
               RaisedButton(onPressed:(){
                 getImage(true);
                }
               ,child: Text('Camera'),),
               SizedBox(height: 20,),
               RaisedButton(onPressed:(){
                  getImage(false);
                },
                 child: Text('Gallery'),),
               _imagefile == null ?
               Container() : Image.file(
                 _imagefile,
                 height: 300,
                 width: 300,),
              _imagefile == null ? Container() :
              RaisedButton(onPressed: (){
                  uploadImage();
               },
                 child: Text('Upload Image'),
               ),
               _uploaded == false ? Container() :
                   RaisedButton(onPressed: (){
                     downloadImage();
                   },
                   child: Text('Download Image '),
                   ),
               _downloadUrl == null ?  Container() :
                   Image.network(_downloadUrl),
             ],
           ),
         ),
       ),
     );
   }
   File _imagefile;
   bool _uploaded = false;
   String _downloadUrl;
   Reference _reference =  FirebaseStorage . instance .ref().child('myimage.jpg');
   Future getImage(bool isCamera)async{
     File image;
     if(isCamera)
       {
         // ignore: deprecated_member_use
         image = await ImagePicker.pickImage(source: ImageSource.camera);
       }
     else
       {
         // ignore: deprecated_member_use
         image = await ImagePicker.pickImage(source: ImageSource.gallery);
       }
     setState(() {
       _imagefile = image;
     });
   }
   Future uploadImage () async{
     UploadTask  uploadTask = _reference.putFile(_imagefile);
     TaskSnapshot taskSnapshot = await uploadTask . whenComplete(() {
       setState(() {
         _uploaded = true ;
       });
     });
   }
   Future downloadImage () async{
    String downloadAddress = await _reference.getDownloadURL();
    setState(() {
      _downloadUrl = downloadAddress;
    });
   }
 }
 