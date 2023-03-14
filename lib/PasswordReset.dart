import 'package:flutter/material.dart';
import 'login.dart';

void main() => runApp(const Forget());

class Forget extends StatelessWidget {
  const Forget({Key? key}) : super(key: key);

  static const String _title = 'Canis Orbis';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            elevation:0,
            centerTitle: true,
            backgroundColor: Colors.black,
            title: const Text("Canis",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Palatino'),)),
        body: const MyStatefulWidget (),
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

  bool _isvisible = false, _isvisible2 = false;
  bool _nameError = false, _passEmpty1 = false, _passEmpty2 = false;
  String _passMessage = '';
  final textbg = const Color(0xFF3D3D3D);
  static const String _title = 'Canis Orbis';
  
  TextEditingController nameController = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController conform_Pass = TextEditingController();

  void dispose()
  {
    nameController.dispose();
    pass.dispose();
    conform_Pass.dispose();
    super.dispose();
  }

  void clearText()
  {
    pass.clear();
    conform_Pass.clear();
  }

  void errorRun()
  {
    openDialog();
    clearText();
  }


  Future openDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
        title:  Text("Success"),
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
                      icon: _isvisible ? Icon(Icons.visibility, color: Colors.white,) : Icon(Icons.visibility_off, color: Colors.grey,)
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey)
                  ),
                  labelText: 'Enter Your New Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText: _passEmpty1 ? 'Please Enter Your New Password' : null,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
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
                    icon: _isvisible2 ? Icon(Icons.visibility, color: Colors.white,) : Icon(Icons.visibility_off, color: Colors.grey,)
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent)
                  ),
                  labelText: 'Re-Enter Your New Password',
                  labelStyle: const TextStyle(color: Colors.white70),
                  errorText: _passEmpty2 ? _passMessage : null,
                ),
              ),
            ),
            Container(
                height: 100,
                padding: const EdgeInsets.fromLTRB(360, 50, 360, 10),
                child: MaterialButton(
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)),
                  child: const Text('Submit',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      _passMessage = "Please Enter Your Conformation Password";
                      nameController.text.isEmpty ? _nameError = true : _nameError = false;
                      pass.text.isEmpty ? _passEmpty1 = true : _passEmpty1 = false;
                      conform_Pass.text.isEmpty ? _passEmpty2 = true : _passEmpty2 = false;
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
        );
  }
}
