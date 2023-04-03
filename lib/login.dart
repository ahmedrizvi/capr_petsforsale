import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'PasswordReset.dart';
import 'register.dart';
import 'AccountHome.dart';

void main() => runApp(const Login());

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  static const String _title = 'Canis';
  final appbarcl = const Color(0xFFF8EDEB);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        backgroundColor: appbarcl,
        appBar: AppBar(
            backgroundColor: appbarcl,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Canis",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
        body: const login(),
      ),
    );
  }
}

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<login> {
  final textbg = const Color(0xFF3D3D3D);
  final appbarcl = const Color(0xFFF8EDEB);
  bool _isvisible = false, _nameError = false, _passEmpty1 = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future LoginSuccessDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Success"),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
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
                  ),
                  labelText: 'Enter Your Email Address',
                  labelStyle: const TextStyle(color: Colors.black),
                  errorText: _nameError ? 'Please enter your email' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: passwordController,
                obscureText: !_isvisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isvisible = !_isvisible;
                        });
                      },
                      icon: _isvisible
                          ? Icon(
                              Icons.visibility,
                              color: Colors.black,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Enter Your Password',
                  labelStyle: const TextStyle(color: Colors.black),
                  errorText: _passEmpty1 ? 'Please Enter Your Password' : null,
                ),
              ),
            ),
            TextButton(
              child: const Align(
                alignment: Alignment.topRight,
                child: Text(
                  'Forgot Password',
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Forget()));
                //forgot password screen
              },
            ),
            Container(
                height: 400,
                padding: const EdgeInsets.fromLTRB(50, 340, 50, 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  child: const Text('Login',
                      style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
                  onPressed: () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: nameController.text,
                            password: passwordController.text)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountHome()));
                    });
                    setState(() {
                      nameController.text.isEmpty
                          ? _nameError = true
                          : _nameError = false;
                      passwordController.text.isEmpty
                          ? _passEmpty1 = true
                          : _passEmpty1 = false;
                    });
                    if (nameController.text.isNotEmpty) {}
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                        decoration: TextDecoration.underline, fontSize: 15),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()));
                  },
                )
              ],
            ),
          ],
        ));
  }
}
