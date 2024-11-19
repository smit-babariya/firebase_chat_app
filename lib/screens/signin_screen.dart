import 'package:demo/provider/user_provider.dart';
import 'package:demo/screens/chat_screen.dart';
import 'package:demo/screens/signup_screen.dart';
import 'package:demo/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String email = "", password = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF9dc3d5),
              Color(0xFF9ac3d4),
              Color.fromARGB(145, 27, 94, 118)
            ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
        ),
        child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/welcome_screen.png',
                ),
                   Container(
                      padding: EdgeInsets.only(left: 30,right: 30),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.5
                              )
                            )
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 1.5
                                  )
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.white
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              )
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                          obscureText: _isPasswordVisible,
                        ),
                        SizedBox(height: 30),
                       Padding(
                           padding: EdgeInsets.only(right: 20,left: 10),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(
                               "Sign in",
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 25,
                                 fontWeight: FontWeight.bold
                               ),
                             ),
                             GestureDetector(
                               onTap: () {
                                 if(emailController.text!="" &&  passwordController.text!="") {
                                   setState(() {
                                     email = emailController.text;
                                     password = passwordController.text;
                                   });
                                 }
                                 signInWithEmailAndPassword();
                               },
                               child: Material(
                                 elevation: 5.0,
                                 borderRadius: BorderRadius.circular(60),
                                 child: Container(
                                   padding: EdgeInsets.all(20),
                                   decoration: BoxDecoration(
                                     color: Color(0xFF4C7296),
                                     borderRadius: BorderRadius.circular(60),
                                   ),
                                   child: Icon(
                                     Icons.arrow_forward,
                                     color: Colors.white,
                                     size: 30,
                                   ),
                                 ),
                               ),
                             )
                           ],
                         ),
                       ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                AuthMethods().signInWithGoogle(context);
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Image.asset(
                                  'assets/google.png',
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have a account? ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupScreen()));
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
              ],
            ),
          )
      ),
    );
  }

  signInWithEmailAndPassword() async {
    try {
      email = email.replaceAll(RegExp(r'\s+'), '').trim();
   UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
             email: email,
             password: password,
           );

      User? user = userCredential.user;
      if (user != null) {
        Provider.of<UserProvider>(context,listen: false).setUser(user);
      }
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => ChatScreen(
        chatPartnerId: 'targetUserId',

      )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user_not_found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found",
              style: TextStyle(fontSize: 20),
            )
        ));
      } else if (e.code == 'Wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password",
              style: TextStyle(fontSize: 20),
            )
        ));
      }
    }
  }
}
