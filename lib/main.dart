import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


  static const String _title = 'Pet Ordis';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start up',
      routes: {
        '/': (BuildContext context) => const Login(),
      },
    );
  }
}

      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            title: const Text("Manu",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Palatino'),)),
        body: const Main(),
      ),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<Main> {
  final textbg = const Color(0xFF3D3D3D);

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
                decoration: InputDecoration(
                  filled: true,
                  fillColor: textbg,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black)
                  ),
                  labelText: 'Enter Your Email Address',
                ),
              ),
            ),
          ],
        ));
  }
}
