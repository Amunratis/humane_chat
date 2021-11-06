import 'package:animated_button/animated_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:humane_chat/helper/helperfunctions.dart';
import 'package:humane_chat/services/auth.dart';
import 'package:humane_chat/services/database.dart';
import 'package:humane_chat/widget/widget.dart';

import 'chatRoomsScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  const SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  late QuerySnapshot snapshotUserInfo;

  final formKey = GlobalKey<FormState>();

  signIn() {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      databaseMethods
          .getUserByUsername(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val as QuerySnapshot<Object?>;
        HelperFunctions.saveUserEmailSharedPreference(
            snapshotUserInfo.docs[0].get("name") as String);
      });
      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        if (value != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(context: context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 70,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Enter correct email";
                        },
                        controller: emailTextEditingController,
                        style: myTextStyle(),
                        decoration: textFieldInputDecoration("email")),
                    TextFormField(
                      obscureText: true,
                      validator: (val) {
                        return val!.length > 6
                            ? null
                            : "Please provide password 6+ characters";
                      },
                      controller: passwordTextEditingController,
                      style: myTextStyle(),
                      decoration: textFieldInputDecoration("password"),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Forgot Password?", style: mediumTextStyle()),
                ),
              ),
              SizedBox(height: 8),
              AnimatedButton(
                width: MediaQuery.of(context).size.width - 70,
                shape: BoxShape.rectangle,
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: Colors.blue,
                onPressed: () {
                  signIn();
                },
                enabled: true,
                shadowDegree: ShadowDegree.light,
              ),
              SizedBox(height: 16),
              AnimatedButton(
                width: MediaQuery.of(context).size.width - 70,
                shape: BoxShape.rectangle,
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: Colors.white,
                onPressed: () {
                  //TODO;
                },
                enabled: true,
                shadowDegree: ShadowDegree.light,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account ? ", style: mediumTextStyle()),
                  GestureDetector(
                    onTap: () {
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Register now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline)),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
