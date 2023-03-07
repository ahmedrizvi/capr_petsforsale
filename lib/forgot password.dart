import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Pets for Sale';

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
            title: const Text("Forgot Your Password?",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
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
  final textbg = Color(0xFF3D3D3D);
  
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
                height: 80,
                padding: const EdgeInsets.fromLTRB(360, 40, 360, 0),
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
          ],
        ));
  }
}
