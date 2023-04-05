import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(const Register());

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  final appbarcl = const Color(0xFFF8EDEB);
  static const String _title = 'Pet Store';

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
              "Create An Account",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
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
  final appbarcl = const Color(0xFFF8EDEB);

  final RegExp capitalLetter = RegExp('[a-zA-Z]');
  final RegExp numbercheck = RegExp('[0-9]');
  final RegExp specialcheck = RegExp('[\$&+,:;=?@#|*()]');

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

  onPasswordChanged(String password) {
    _8Characters = false;
    _1NumCharacters = false;
    _1CapitalCharacters = false;
    _1SpeCharacters = false;

    setState(() {
      if (password.length >= 8) _8Characters = true;
      if (numbercheck.hasMatch(password)) _1NumCharacters = true;
      if (capitalLetter.hasMatch(password)) _1CapitalCharacters = true;
      if (specialcheck.hasMatch(password)) _1SpeCharacters = true;
    });
  }

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
  Future addUserDetails(String firstName, String lastName, String userName,
      String email, String phoneNumber, String address) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name:': firstName,
      'last name:': lastName,
      'user name:': userName,
      'email:': email,
      'phone number:': phoneNumber,
      'address:': address,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Row(children: [
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: _FnameController,
                  onChanged: (value) {
                    setState(() {
                      _FnameError = false;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'First Name',
                    labelStyle: const TextStyle(color: Colors.black),
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
                  style: const TextStyle(color: Colors.black),
                  controller: _LnameController,
                  onChanged: (value) {
                    setState(() {
                      _LnameError = false;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Last Name',
                    labelStyle: const TextStyle(color: Colors.black),
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
                style: const TextStyle(color: Colors.black),
                controller: userNameController,
                onChanged: (value) {
                  setState(() {
                    _usernameError = false;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: Colors.black),
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
                style: const TextStyle(color: Colors.black),
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    _emailError = false;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Email Address',
                  labelStyle: const TextStyle(color: Colors.black),
                  errorText:
                      _emailError ? 'Please Enter Your Email Address' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  onPasswordChanged(value);
                  setState(() {
                    _passError = false;
                  });
                },
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
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black),
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
                    color:
                        _8Characters ? Colors.blueAccent : Colors.transparent,
                    border: _8Characters
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.black),
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
                  style: TextStyle(color: Colors.black),
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
                    color: _1NumCharacters
                        ? Colors.blueAccent
                        : Colors.transparent,
                    border: _1NumCharacters
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.black),
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
                  style: TextStyle(color: Colors.black),
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
                    color: _1SpeCharacters
                        ? Colors.blueAccent
                        : Colors.transparent,
                    border: _1SpeCharacters
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.black),
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
                  style: TextStyle(color: Colors.black),
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
                    color: _1CapitalCharacters
                        ? Colors.blueAccent
                        : Colors.transparent,
                    border: _1CapitalCharacters
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.black),
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
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                obscureText: !_isvisible2,
                controller: confPasswordController,
                onChanged: (value) {
                  setState(() {
                    _CpassError = false;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isvisible2 = !_isvisible2;
                        });
                      },
                      icon: _isvisible2
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
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.black),
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
                style: const TextStyle(color: Colors.black),
                controller: addressController,
                onChanged: (value) {
                  setState(() {
                    _addressError = false;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Address',
                  labelStyle: const TextStyle(color: Colors.black),
                  errorText: _addressError
                      ? 'Please Enter Your Physical Address'
                      : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextField(
                onTap: () {
                  _phoneNumberError = false;
                },
                style: const TextStyle(color: Colors.black),
                controller: phoneNumberController,
                onChanged: (value) {
                  setState(() {
                    _phoneNumberError = false;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Phone number',
                  labelStyle: const TextStyle(color: Colors.black),
                  errorText: _phoneNumberError
                      ? 'Please Enter Your Phone Number'
                      : null,
                ),
              ),
            ),
            Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  child: const Text('Create',
                      style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
                  onPressed: () {
                    setState(() {
                      _CpassMessage = 'Please Enter Your Confirmation Password';
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
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text)
                            .then((value) async {
                          // Set the display name for the newly created user
                          await value.user
                              ?.updateDisplayName(userNameController.text);
                          addUserDetails(
                              _FnameController.text.trim(),
                              _LnameController.text.trim(),
                              userNameController.text.trim(),
                              emailController.text.trim(),
                              phoneNumberController.text.trim(),
                              addressController.text.trim());
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
