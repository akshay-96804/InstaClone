import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:insta_clone/utils/';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/homeScreen.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/text_field_input.dart';

class SignUpscreenScreen extends StatefulWidget {
  const SignUpscreenScreen({Key? key}) : super(key: key);

  @override
  State<SignUpscreenScreen> createState() => _SignUpscreenScreenState();
}

class _SignUpscreenScreenState extends State<SignUpscreenScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  Uint8List? _image;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  void _selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    print("inside call");

    print(_emailController.text);
    print(_passwordController.text);
    print(_userNameController.text);

    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _userNameController.text,
        bio: _bioController.text,
        file: _image!);

    if (res != 'Success') {
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flexible(child: Container(), flex: 2),
              // SvgPicture.asset('assets/ic_instagram.svg',
              //     color: primaryColor, height: 64.0),
              SizedBox(height: 64.0),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64.0,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64.0,
                          backgroundImage: NetworkImage(
                              'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        color: Colors.red,
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: () {
                          _selectImage();
                        },
                      ))
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              TextFieldInput(
                  textEditingController: _userNameController,
                  hintText: 'Enter username',
                  textInputType: TextInputType.text),
              const SizedBox(height: 24.0),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(height: 24.0),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter password',
                textInputType: TextInputType.emailAddress,
                isPass: true,
              ),
              const SizedBox(height: 24.0),
              TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'Enter bio',
                  textInputType: TextInputType.text),
               SizedBox(height: 25.0),   
              GestureDetector(
                onTap: signUpUser,
                // () async {
                // String res = await AuthMethods().signUpUser(
                //     email: _emailController.text,
                //     password: _passwordController.text,
                //     username: _userNameController.text,
                //     bio: _bioController.text,
                //     file: _image!
                //     );
                // },

                child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)))),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: primaryColor,
                            ),
                          )
                        : const Text('Sign Up')),
              ),
              const SizedBox(height: 12.0),
              Flexible(child: Container(), flex: 2),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text('Dont have an account ?'),
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
      ),
    );
  }
}
