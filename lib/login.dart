import 'package:flutter/material.dart';
import 'PasswordReset.dart';
import 'register.dart';

void main() => runApp(const Login());

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  static const String _title = 'Canis Orbis';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            title: const Text("- Sign In -",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
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
  bool _isvisible = false, _nameError = false, _passEmpty1=false;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black)
                  ),
                  labelText: 'Enter Your Email Address',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText: _nameError ? 'Please enter your email' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: passwordController,
                obscureText: !_isvisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _isvisible = !_isvisible;
                        });
                      },
                      icon: _isvisible ? Icon(Icons.visibility, color: Colors.white,) : Icon(Icons.visibility_off, color: Colors.grey,)
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey)
                  ),
                  labelText: 'Enter Your Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText: _passEmpty1 ? 'Please Enter Your Password' : null,
                ),
              ),
            ),
            TextButton(
              child: const Align(
                alignment: Alignment.topRight,
                child:  Text(
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
                height: 120,
                padding: const EdgeInsets.fromLTRB(360, 40, 360, 40),
                child: ElevatedButton(
                  child: const Text('Login',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      nameController.text.isEmpty ? _nameError = true : _nameError = false;
                      passwordController.text.isEmpty ? _passEmpty1 = true : _passEmpty1 = false;
                    });
                    if (nameController.text.isNotEmpty)
                      {

                      }
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                TextButton(
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                        decoration: TextDecoration.underline,fontSize: 15),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Register()));
                  },
                )
              ],
            ),
          ],
        ));
  }
}
