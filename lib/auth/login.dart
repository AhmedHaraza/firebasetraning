// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetraning/auth/home.dart';
import 'package:firebasetraning/auth/signup.dart';
import 'package:firebasetraning/helper/AwesomeDialog.dart';
import 'package:firebasetraning/widgets/custom_boutton.dart';
import 'package:firebasetraning/widgets/custom_logo_auth.dart';
import 'package:firebasetraning/widgets/custom_text_formfiled.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formstate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 50),
                const CustomLogoAuth(),
                Container(height: 20),
                const Text("Login",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Container(height: 10),
                const Text("Login To Continue Using The App",
                    style: TextStyle(color: Colors.grey)),
                Container(height: 20),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                  hinttext: "ُEnter Your Email",
                  mycontroller: email,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "email is required";
                    }
                    return null;
                  },
                ),
                Container(height: 10),
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                  hinttext: "ُEnter Your Password",
                  mycontroller: password,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "password is required";
                    }
                    return null;
                  },
                ),
                InkWell(
                  onTap: () {
                    if (email.text.isEmpty) {
                      awesomeDialog(
                        context: context,
                        description:
                            "please Enter your email address So you can change the password",
                        dialogType: DialogType.info,
                      );
                      return;
                    }
                    try {
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: email.text);
                      awesomeDialog(
                        context: context,
                        description:
                            "please Go to your email ${email.text} to reset your password",
                        dialogType: DialogType.success,
                      );
                    } catch (e) {
                      awesomeDialog(
                        context: context,
                        description: "{e.toString()}",
                        dialogType: DialogType.info,
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    alignment: Alignment.topRight,
                    child: const Text(
                      "Forgot Password ?",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomButtonAuth(
            title: "login",
            onPressed: () async {
              if (formstate.currentState!.validate()) {
                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                  if (credential.user!.emailVerified) {
                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                  } else {
                    awesomeDialog(
                        context: context,
                        description: "please go to gmail & verification",
                        dialogType: DialogType.error);
                  }
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Success")));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    awesomeDialog(
                        context: context,
                        description: "weak-password",
                        dialogType: DialogType.error);
                  } else if (e.code == 'user-not-found') {
                    awesomeDialog(
                        context: context,
                        description: "No user found for that email.",
                        dialogType: DialogType.error);
                    debugPrint('The account already exists for that email.');
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              } else {
                debugPrint("Not Valid for that email or Password");
              }
            },
          ),
          Container(height: 20),

          MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.red[700],
              textColor: Colors.white,
              onPressed: () {
                signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login With Google  "),
                  Image.asset(
                    "assets/images/google.png",
                    width: 20,
                  )
                ],
              )),
          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, SingUpScreens.id);
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Don't Have An Account ? ",
                ),
                TextSpan(
                    text: "Register",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
              ])),
            ),
          )
        ]),
      ),
    );
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    Navigator.pushReplacementNamed(context, HomeScreen.id);
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}