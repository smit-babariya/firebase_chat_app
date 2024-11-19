import 'package:demo/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF498aa2),
              Color(0xFF377b94),
              Color(0xFF81b7cf),
              Color(0xFF81b7cf),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/account.png"),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    SizedBox(height: 30.0),
                    TextField(
                      controller: namecontroller,
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.5),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    TextField(
                      controller: emailcontroller,
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.5),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    TextField(
                      controller: passwordcontroller,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1.5),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (namecontroller.text != "" &&
                                  emailcontroller.text != "" &&
                                  passwordcontroller.text != "") {
                                setState(() {
                                  email = emailcontroller.text;
                                  name = namecontroller.text;
                                  password = passwordcontroller.text;
                                });
                              }
                              signUpWithEmailAndPassword();
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
                                child: Icon(Icons.arrow_forward,
                                    color: Colors.white, size: 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SigninScreen()),
                            );
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signUpWithEmailAndPassword() async {
    email = emailcontroller.text;
    password = passwordcontroller.text;
    name = namecontroller.text;

    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      email = email.replaceAll(RegExp(r'\s+'), '').trim();

      try {
        // Create a user with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        User? userDetails = userCredential.user;

        if (userDetails != null) {
          Provider.of<UserProvider>(context, listen: false).setUser(userDetails);
          // Map user details to a Firestore document
          Map<String, dynamic> userInfoMap = {
            "email": userDetails.email,
            "name": name, // Use the name entered during sign-up
            "id": userDetails.uid, // Firebase user ID
          };

          // Save user details in Firestore
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userDetails.uid)
              .set(userInfoMap);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20),
            ),
          ));

          // Navigate to the Sign-In screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SigninScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'weak-password') {
          message = "Password Provided is too weak";
        } else if (e.code == 'email-already-in-use') {
          message = "Account already exists";
        }

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            message,
            style: TextStyle(fontSize: 20),
          ),
        ));
      } catch (e) {
        // General error handling
        print("Error: $e");
      }
    } else {
      // Show a message if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          "All fields are required",
          style: TextStyle(fontSize: 20),
        ),
      ));
    }
  }
}
