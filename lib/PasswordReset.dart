import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(const Forget());

class Forget extends StatelessWidget {
  const Forget({Key? key}) : super(key: key);

  static const String _title = 'Canis Orbis';
  final appbarcl = const Color(0xFFF8EDEB);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        backgroundColor: appbarcl,
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: appbarcl,
            title: const Text(
              "Canis",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            )),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _nameError = false;
  final textbg = const Color(0xFF3D3D3D);
  final appbarcl = const Color(0xFFF8EDEB);

  TextEditingController nameController = TextEditingController();

  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  void errorRun() {
    openDialog();
  }
  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: nameController.text.trim());
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              content: Text('Password Reset Link sent! Check your email.'),
            );
          });
    } on FirebaseAuthException catch(e) {
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  content: Text(e.message.toString()),
                );
              });
    }
    }
  Future openDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Password Reset link has been sent!"),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              alignment: Alignment.center,
              child: const Text(
                  'Enter your email and we will send you a password reset link',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Montserrat'))),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black)),
                labelText: 'Enter Your Email Address',
                labelStyle: const TextStyle(color: Colors.black),
                errorText: _nameError ? 'Please enter your email' : null,
              ),
            ),
          ),

          Container(
              height: 300,
              padding: const EdgeInsets.fromLTRB(50, 230, 50, 10),
              child: MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text('Reset Password',
                      style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
                  onPressed: () async {
                    setState(() {
                      nameController.text.isEmpty
                          ? _nameError = true
                          : _nameError = false;
                    });
                    if (nameController.text.isNotEmpty) {
                      try {
                        passwordReset();
                      } catch (e) {
                        // Display error message based on the error code
                        print("Error while sending password reset email: $e");
                      }
                    }
                  }
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: const Text(
                  'Remembered your Password? Click to Login',
                  style: TextStyle(
                      decoration: TextDecoration.underline, fontSize: 15),
                ),
                onPressed: () {
                  //signup screen
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
