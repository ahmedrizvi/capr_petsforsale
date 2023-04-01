import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(const Forget());

class Forget extends StatelessWidget {
  const Forget({Key? key}) : super(key: key);

  static const String _title = 'Pet Ordis';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.black,
            title: const Text(
              "Canis",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Palatino'),
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

  bool _isvisible = false, _isvisible2 = false;
  bool _nameError = false, _passEmpty1 = false, _passEmpty2 = false;
  String _passMessage = '';

  bool _8Characters = false;
  bool _1NumCharacters = false;
  bool _1SpeCharacters = false;
  bool _1CapitalCharacters = false;

  final textbg = const Color(0xFF3D3D3D);

  var btn_color = const Color(0xFF000000);
  static const String _title = 'Pet Ordis';
  

  TextEditingController nameController = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirm_Pass = TextEditingController();

  void dispose() {
    nameController.dispose();
    pass.dispose();
    confirm_Pass.dispose();
    super.dispose();
  }


  void clearText() {
    pass.clear();
    confirm_Pass.clear();
  }

  void errorRun() {
    openDialog();
    clearText();

  onNameChange(String name)
  {
    setState(() {
      _nameError = false;
    });
  }
  onPasswordChange(String password)
  {
    setState(() {
      final capitalRegex = RegExp(r'[A-Z]');
      final numericRegex = RegExp(r'[0-9]');
      final specialRegex = RegExp(r'[!@#\$&*~]');

      _passEmpty1 = false;
      _1NumCharacters = false;
      _1SpeCharacters = false;
      _1CapitalCharacters = false;
      _8Characters = false;

      if(password.length >= 8)
      {
        _8Characters = true;
      }
      if(numericRegex.hasMatch(password))
      {
        _1NumCharacters = true;
      }
      if (specialRegex.hasMatch(password))
      {
        _1SpeCharacters = true;
      }
      if (capitalRegex.hasMatch(password))
      {
        _1CapitalCharacters = true;
      }

    });
  }

  onCoPasswordChange(String conform)
  {
    setState(() {
      _passEmpty2 = false;
    });
  }

  Future openDialog() => showDialog(
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
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              alignment: Alignment.center,
              child: const Text('Trouble with logging in?', style: TextStyle(color: Colors.grey, fontSize: 18))
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (name) => onNameChange(name),
                style: const TextStyle(color: Colors.white),
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black)),
                labelText: 'Enter Your Email Address',
                labelStyle: const TextStyle(color: Colors.white70),
                errorText: _nameError ? 'Please enter your email' : null,
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (password) => onPasswordChange(password),
                style: const TextStyle(color: Colors.white),
                controller: pass,
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
                    borderSide: const BorderSide(color: Colors.grey)),
                labelText: 'Enter Your New Password',
                labelStyle: const TextStyle(color: Colors.white70),
                errorText:
                    _passEmpty1 ? 'Please Enter Your New Password' : null,
              ),
            ),

            SizedBox(height: 10,),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _8Characters ? Colors.blueAccent : btn_color,
                    border: _8Characters ? Border.all(color: Colors.transparent) :
                    Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Icon(Icons.check, color: Colors.black, size:15),),
                ),
                SizedBox(width: 10,),
                const Text ("Contains at least 8 characters",
                  style: TextStyle(color: Colors.white),),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _1NumCharacters ? Colors.blueAccent : btn_color,
                    border: _1NumCharacters ? Border.all(color: Colors.transparent) :
                    Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Icon(Icons.check, color: Colors.black, size:15),),
                ),
                SizedBox(width: 10,),
                const Text ("Contains at least 1 number",
                  style: TextStyle(color: Colors.white),),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _1SpeCharacters ? Colors.blueAccent : btn_color,
                    border: _1SpeCharacters ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Icon(Icons.check, color: Colors.black, size:15),),
                ),
                SizedBox(width: 10,),
                const Text ("Contains at least 1 special character",
                  style: TextStyle(color: Colors.white),),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _1CapitalCharacters ? Colors.blueAccent : btn_color,
                    border: _1CapitalCharacters ? Border.all(color: Colors.transparent)
                        :Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Icon(Icons.check, color: Colors.black, size:15),),
                ),
                SizedBox(width: 10,),
                const Text ("Contains at least 1 capital letter",
                  style: TextStyle(color: Colors.white),),
              ],
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (password) => onCoPasswordChange(password),
                style: const TextStyle(color: Colors.white),
                controller: conform_Pass,
                obscureText: !_isvisible2,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  suffixIcon: IconButton(
                    onPressed: (){
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
                    borderSide: const BorderSide(color: Colors.blueAccent)),
                labelText: 'Re-Enter Your New Password',
                labelStyle: const TextStyle(color: Colors.white70),
                errorText: _passEmpty2 ? _passMessage : null,
              ),
            ),
            Container(
                height: 100,
                padding: const EdgeInsets.fromLTRB(50, 50, 50, 10),
                child: MaterialButton(
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: const Text('Reset',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      _passMessage = "Please Enter Your Conformation Password";
                      nameController.text.isEmpty ? _nameError = true : _nameError = false;
                      pass.text.isEmpty ? _passEmpty1 = true : _passEmpty1 = false;
                      conform_Pass.text.isEmpty ? _passEmpty2 = true : _passEmpty2 = false;
                      btn_color = const Color(0xFFA30000);
                    });
                    if(nameController.text.isNotEmpty)
                      {
                        if(conform_Pass.text != pass.text) {
                          conform_Pass.clear();
                          _passMessage = 'Password\'s don\'t Match';
                          setState(() {
                            conform_Pass.text != pass.text
                                ? _passEmpty2 = true
                                : _passEmpty2 = false;

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
                    'Remembered your Password, Return to Login',
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
          ),
        ],
      ),
    );
  }
}
