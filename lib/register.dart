import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(const Register());

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

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
            title: const Text(" - Registration - ",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
        body: MyStatefulWidget (),
      ),
    );
  }
}

class MyStatefulWidget  extends StatefulWidget {
  const MyStatefulWidget ({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget > createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget > {
  final textbg = const Color(0xFF3D3D3D);

  bool _FnameError = false, _LnameError = false, _emailError = false,
      _passError = false, _CpassError = false, _isvisible = false, _isvisible2 = false;

  String _CpassMessage = '';

  TextEditingController _FnameController = TextEditingController();
  TextEditingController _LnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confPasswordController = TextEditingController();

  Future openDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title:  Text("Success"),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Row(children: [
              const SizedBox(width: 10,),
              Expanded(child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _FnameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'First Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText:  _FnameError ? 'Please Enter Your First Name' : null,
                ),
              ),),
              const SizedBox(width: 20,),
              Expanded(child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _LnameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Last Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText:  _LnameError ? 'Please Enter Your Last Name' : null,
                ),
              ),),
              const SizedBox(width: 10,),
            ]),
            Container(
              padding: const EdgeInsets.fromLTRB(10,20,10,10),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Email Address',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText:  _emailError ? 'Please Enter Your Email Address' : null,
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
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText:  _passError ? 'Please Enter Your Password' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                obscureText: !_isvisible2,
                controller: confPasswordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _isvisible2 = !_isvisible2;
                        });
                      },
                      icon: _isvisible2 ? Icon(Icons.visibility, color: Colors.white,) : Icon(Icons.visibility_off, color: Colors.grey,)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Conform Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText:  _CpassError ? _CpassMessage : null,
                ),
              ),
            ),
            Container(
                height: 120,
                padding: const EdgeInsets.fromLTRB(360, 40, 360, 40),
                child: ElevatedButton(
                  child: const Text('Create',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      _CpassMessage = 'Please Enter Your Conformation Password';
                      _FnameController.text.isEmpty ? _FnameError = true : _FnameError = false;
                      _LnameController.text.isEmpty ? _LnameError = true : _LnameError = false;
                      emailController.text.isEmpty ? _emailError = true : _emailError = false;
                      passwordController.text.isEmpty ? _passError = true : _passError = false;
                      confPasswordController.text.isEmpty ? _CpassError = true : _CpassError = false;
                    });
                    if(_FnameController.text.isNotEmpty & _LnameController.text.isNotEmpty & emailController.text.isNotEmpty)
                    {
                      if(confPasswordController.text != passwordController.text) {
                        confPasswordController.clear();
                        _CpassMessage = 'Password\'s don\'t Match';
                        setState(() {
                          confPasswordController.text != passwordController.text
                              ? _CpassError = true
                              : _CpassError = false;

                        });
                      }
                      else
                      {
                        openDialog();
                      }
                    }
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: const Text(
                    'Already have an account? Login Here',
                    style: TextStyle(
                        decoration: TextDecoration.underline,fontSize: 15),
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
        ));
  }
}
