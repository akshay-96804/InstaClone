// import 'dart:html';
import 'dart:io';
import 'dart:math';
// import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/providers/authProvider.dart';
import 'package:insta_clone/screens/homeScreen.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  // const RegisterPage({ Key? key }) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  bool _imgSpinner = false;

  String imgUrl =
      'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg';
  // Uint8List? _image ;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Random _rnd = Random();
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Reference storageReference = FirebaseStorage.instance.ref();

  PickedFile? _image;
  late File _imgFile;

  void _getImage() async {
    final _pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (_pickedFile != null) {
      setState(() {
        _imgSpinner = true;
      });

      _imgFile = File(_pickedFile.path);
      addImageToFirebase();
    }
  }

  void addImageToFirebase() async {
    String imgName = getRandomString(15);
    Reference ref = storageReference.child("profilePics/$imgName.jpg");

    TaskSnapshot uploadTask = await ref.child("image1.jpg").putFile(_imgFile);
    final downloadUrl = await uploadTask.ref.getDownloadURL();

    setState(() {
      imgUrl = downloadUrl;
      _imgSpinner = false;
    });
  }

  // void signUpUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   print("inside call");

  //   print(_emailController.text);
  //   print(_passwordController.text);
  //   print(_userNameController.text);

  //   String res = await Provider.of<AuthProvider>(context, listen: false)
  //       .createUser(_emailController.text, _passwordController.text);

  //   if (res != 'Success') {
  //     _isLoading = false;
  //      showSnackBar(res, context);

  //      setState(() {
          
  //      });
  //   }

  //   print("Succesfully created your account");
  //   setState(() {
  //     _isLoading = false;
  //   });

  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(builder: (context) => HomeScreen()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('PhotoGram', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                      child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 45.0,
                              backgroundImage: NetworkImage(imgUrl),
                              child: _imgSpinner
                                  ? CircularProgressIndicator()
                                  : null,
                            ),
                            Positioned(
                              bottom: 0.15,
                              right: 0.25,
                              child: IconButton(
                                  color: Colors.black,
                                  icon: Icon(Icons.camera_alt_sharp),
                                  onPressed: () {
                                    _getImage();
                                  }),
                            )
                          ],
                        ),
                        SizedBox(height: 25.0),
                        TextFormField(
                          controller: _userNameController,
                          decoration: InputDecoration(
                              hintText: 'Enter Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            
                              hintText: 'Enter email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              hintText: 'Enter password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        TextFormField(
                          controller: _bioController,
                          decoration: InputDecoration(
                              hintText: 'Enter Bio',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                             setState(() {
      _isLoading = true;
    });
                            String res = await Provider.of<AuthProvider>(
                                    context,
                                    listen: false)
                                .createUser(_emailController.text,
                                    _passwordController.text);
                            if (res != "Success") {
                               _isLoading = false;
       showSnackBar(res, context);

       setState(() {
          
       });
                            } else {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .storeUser(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      username: _userNameController.text,
                                      bio: _bioController.text,
                                      photoUrl: imgUrl);
                                      
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            }
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 12.0),
                              alignment: Alignment.center,
                              color: Colors.blueAccent,
                              width: double.infinity,
                              child: const Text(
                                'Create Account',
                                // style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              padding: EdgeInsets.all(12.0)),
                        )
                      ],
                    ),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: const Text('Already have an account ?'),
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Container(
                            child: const Text(
                              'Log In',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
