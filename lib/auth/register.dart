import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/services/global_variables.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin{

  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController _fullNameController = TextEditingController(text: '');
  late TextEditingController _emailTextController = TextEditingController(text: '');
  late TextEditingController _passTextController = TextEditingController(text: '');
  late TextEditingController _locationController = TextEditingController(text: '');
  late TextEditingController _phoneNumberController = TextEditingController(text: '');

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();
  FocusNode _positionCPFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();
  bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String? imageUrl;

  @override
  void dispose(){
    _animationController.dispose();
    _emailTextController.dispose();
    _fullNameController.dispose();
    _passTextController.dispose();
    _phoneNumberController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _positionCPFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation  = CurvedAnimation(parent: _animationController, curve: Curves.linear)
    ..addListener(() {
      setState(() { });
    })..addStatusListener((animationStatus){
      if(animationStatus  == AnimationStatus.completed){
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
              imageUrl: signUpUrlImage,
            placeholder: (context , url) => Image.asset("assets/images/wallpaper.jpg", fit: BoxFit.fill,),

            errorWidget: (context, url , error) => Icon(Icons.error),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            color: Colors.black54,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
                child: ListView(
                  children: [
                    Form(
                      key: _signUpFormKey,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: (){
                                _showImageDialog();
                              },
                              child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Container(
                                    width: size.width * 0.24,
                                    height: size.height * 0.24,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: Colors.white,),
                                      borderRadius: BorderRadius.circular(16)
                                    ),
                                    child: imageFile == null 
                                        ? Icon(Icons.camera_enhance, color: Colors.blue, size: 30,)
                                        : Image.file(imageFile!, fit: BoxFit.fill,),
                                  ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context).requestFocus(_emailFocusNode),
                              keyboardType: TextInputType.name,
                              controller: _fullNameController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "This field is missing";
                                }else{
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Full name / Company name",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context).requestFocus(_passFocusNode),
                              focusNode: _emailFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailTextController,
                              validator: (value){
                                if(value!.isEmpty || !value.contains("@")){
                                  return "Please enter a valid email address";
                                }else{
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
                              focusNode: _passFocusNode,
                              keyboardType: TextInputType.visiblePassword,
                              controller: _passTextController,
                              validator: (value){
                                if(value!.isEmpty || value.length < 5){
                                  return "Please enter a valid password";
                                }else{
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText ? Icons.visibility: Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context).requestFocus(_positionCPFocusNode),
                              focusNode: _phoneNumberFocusNode,
                              keyboardType: TextInputType.phone,
                              controller: _phoneNumberController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "This field is missing";
                                }else{
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context).requestFocus(_positionCPFocusNode),
                              focusNode: _positionCPFocusNode,
                              keyboardType: TextInputType.phone,
                              controller: _locationController,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "This field is missing";
                                }else{
                                  return null;
                                }
                              },
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Company address",
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red)
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            isLoading
                                ? Center(
                              child: Container(
                                width: 70,
                                height: 70,
                                child: CircularProgressIndicator(),
                              ),
                            ) : MaterialButton(
                                onPressed: (){},
                              color: Colors.blue,
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)
                              ),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  children: [
                                    Text("SignUp", style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                    ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Center(
                              child: RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Already Have an Account?",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                    ),
                                  ),
                                  TextSpan(text: '    '),
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : null,
                                      text: 'Login Here', style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  )),
                                ],
                              )),
                            )
                          ],
                        ),
                    ),
                  ],
                ),
            ),
          )
        ],
      ),
    );
  }
  void _showImageDialog(){
    showDialog(context: context,
        builder: (context){
      return AlertDialog(
        title: Text("please choose an option"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: (){
                _getFromCamera();
              },
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.camera, color: Colors.purple,
                    ),
                  ),
                  Text("Camera", style: TextStyle(color: Colors.purple),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                _getFromGallery();
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.image, color: Colors.purple,
                    ),
                  ),
                  Text("Gallery", style: TextStyle(color: Colors.purple),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }


  void _getFromCamera() async{
    PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1080,
    );
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        maxHeight: 1080,
        maxWidth: 1080,
    );
    if(croppedImage != null){
      setState(() {
        imageFile = croppedImage;
      });
    }
  }
}
