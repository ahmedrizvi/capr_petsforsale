import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
            title: const Text(
              "Canis",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Palatino'),
            )),
        body: MyStatefulWidget(),
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
  final textbg = const Color(0xFF3D3D3D);

  bool _FnameError = false,
      _LnameError = false,
      _usernameError = false,
      _emailError = false,
      _passError = false,
      _CpassError = false,
      _addressError = false,
      _phoneNumberError = false,
      _isvisible = false,
      _isvisible2 = false;

  bool _8Characters = false;
  bool _1NumCharacters = false;
  bool _1SpeCharacters = false;
  bool _1CapitalCharacters = false;

  String _CpassMessage = '';

  onPasswordChanged(String password) {}

  TextEditingController _FnameController = TextEditingController();
  TextEditingController _LnameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Success"),
        ),
      );
  Future addUserDetails(String firstName, String lastName, String userName, String email, String phoneNumber, String address) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name:': firstName,
      'last name:': lastName,
      'user name:': userName,
      'email:': email,
      'phone number:': phoneNumber,
      'address:': address,
    } as Map<String, dynamic>);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                alignment: Alignment.center,
                child: const Text('Sign up to buy, sell or view pets!',
                    style: TextStyle(color: Colors.grey, fontSize: 18))),
            Row(children: [
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
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
                    errorText:
                        _FnameError ? 'Please Enter Your First Name' : null,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
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
                    errorText:
                        _LnameError ? 'Please Enter Your Last Name' : null,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ]),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
                onTap: () {
                  _usernameError = false;
                },
                style: const TextStyle(color: Colors.white),
                controller: userNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText:
                  _usernameError ? 'Please Enter Your Username' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
                onTap: () {
                  _emailError = false;
                },
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
                  errorText:
                      _emailError ? 'Please Enter Your Email Address' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (passwordController) =>
                    onPasswordChanged(passwordController),
                style: const TextStyle(color: Colors.white),
                controller: passwordController,
                obscureText: !_isvisible,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isvisible = !_isvisible;
                        });
                      },
                      icon: _isvisible
                          ? Icon(
                              Icons.visibility,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText: _passError ? 'Please Enter Your Password' : null,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: Colors.black, size: 15),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                const Text(
                  "Contains at least 8 characters",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: Colors.black, size: 15),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                const Text(
                  "Contains at least 1 number",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: Colors.black, size: 15),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                const Text(
                  "Contains at least 1 special character",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(Icons.check, color: Colors.black, size: 15),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                const Text(
                  "Contains at least 1 capital letter",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 10,
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
                      onPressed: () {
                        setState(() {
                          _isvisible2 = !_isvisible2;
                        });
                      },
                      icon: _isvisible2
                          ? Icon(
                              Icons.visibility,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText: _CpassError ? _CpassMessage : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
                onTap: () {
                  _addressError = false;
                },
                style: const TextStyle(color: Colors.white),
                controller: addressController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Address',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText:
                  _addressError ? 'Please Enter Your Physical Address' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
                onTap: () {
                  _phoneNumberError = false;
                },
                style: const TextStyle(color: Colors.white),
                controller: phoneNumberController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Phone number',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText:
                  _phoneNumberError ? 'Please Enter Your Phone Number' : null,
                ),
              ),
            ),
            Container(
                height: 250,
                padding: const EdgeInsets.fromLTRB(40, 150, 40, 40),
                child: ElevatedButton(
                  child: const Text('Create',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      _CpassMessage = 'Please Enter Your Conformation Password';
                      _FnameController.text.isEmpty
                          ? _FnameError = true
                          : _FnameError = false;
                      _LnameController.text.isEmpty
                          ? _LnameError = true
                          : _LnameError = false;
                      userNameController.text.isEmpty
                          ? _usernameError = true
                          : _usernameError = false;
                      emailController.text.isEmpty
                          ? _emailError = true
                          : _emailError = false;
                      passwordController.text.isEmpty
                          ? _passError = true
                          : _passError = false;
                      confPasswordController.text.isEmpty
                          ? _CpassError = true
                          : _CpassError = false;
                      addressController.text.isEmpty
                          ? _addressError = true
                          : _addressError = false;
                      phoneNumberController.text.isEmpty
                          ? _phoneNumberError = true
                          : _phoneNumberError = false;
                    });
                    if (_FnameController.text.isNotEmpty &
                        _LnameController.text.isNotEmpty &
                        emailController.text.isNotEmpty &
                        userNameController.text.isNotEmpty &
                        phoneNumberController.text.isNotEmpty &
                        addressController.text.isNotEmpty) {
                      if (confPasswordController.text !=
                          passwordController.text) {
                        confPasswordController.clear();
                        _CpassMessage = 'Password\'s don\'t Match';
                        setState(() {
                          confPasswordController.text != passwordController.text
                              ? _CpassError = true
                              : _CpassError = false;
                        });
                      } else {
                        FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text).then((value) {
                            addUserDetails(
                                _FnameController.text.trim(),
                                _LnameController.text.trim(),
                                userNameController.text.trim(),
                                emailController.text.trim(),
                                phoneNumberController.text.trim(),
                                addressController.text.trim()
                            );
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        });



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
        ));
  }
}
