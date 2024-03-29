import 'package:flutter/material.dart';
import 'package:insta_clone/providers/authProvider.dart';
import 'package:insta_clone/screens/homeScreen.dart';
import 'package:insta_clone/screens/registerPage.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:insta_clone/widgets/text_field_input.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;


  void logInUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await Provider.of<AuthProvider>(context,listen: false).logInUser(_emailController.text, _passwordController.text);
  
    if (res == "Success") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    } else {
      setState(() {
      _isLoading = false;
    });
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
                Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("PhotoGram",style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 30.0,fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 25.0),
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
              GestureDetector(
                onTap: logInUser,
                child: Container(
                  
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(4.0)))),
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child:  _isLoading? const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: primaryColor,
                    ),
                  ):const Text('Log In'),
                ),
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
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
                      },
                      child: Container(
                        child: const Text(
                          'Sign up',
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
