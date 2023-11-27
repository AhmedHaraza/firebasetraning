// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetraning/auth/login.dart';
import 'package:firebasetraning/helper/AwesomeDialog.dart';
import 'package:firebasetraning/widgets/custom_boutton.dart';
import 'package:firebasetraning/widgets/custom_logo_auth.dart';
import 'package:firebasetraning/widgets/custom_text_formfiled.dart';
import 'package:flutter/material.dart';

class SingUpScreens extends StatefulWidget {
  const SingUpScreens({super.key});
  static const String id = "singin";

  @override
  State<SingUpScreens> createState() => _SignUpState();
}

class _SignUpState extends State<SingUpScreens> {
  TextEditingController username = TextEditingController();
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
                const Text("SignUp",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Container(height: 10),
                const Text("SignUp To Continue Using The App",
                    style: TextStyle(color: Colors.grey)),
                Container(height: 20),
                const Text(
                  "username",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                CustomTextForm(
                  hinttext: "ُEnter Your username",
                  mycontroller: username,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "user name is required";
                    }
                    return null;
                  },
                ),
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
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 20),
                  alignment: Alignment.topRight,
                  child: const Text(
                    "Forgot Password ?",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomButtonAuth(
              title: "SignUp",
              onPressed: () async {
                if (formstate.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Success")));
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      awesomeDialog(
                          context: context,
                          description: "weak-password",
                          dialogType: DialogType.error);
                    } else if (e.code == 'email-already-in-use') {
                      awesomeDialog(
                          context: context,
                          description:
                              "The account already exists for that email.",
                          dialogType: DialogType.error);
                      debugPrint('The account already exists for that email.');
                    }
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                }
              }),
          Container(height: 20),

          Container(height: 20),
          // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Have An Account ? ",
                ),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
