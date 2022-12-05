import 'package:flutter/material.dart';
import 'package:restorant/login_&_register/login.dart';
import 'package:restorant/widget/bottom_navbar.dart';
import 'package:restorant/widget/button/button.dart';
import 'package:restorant/widget/image/icon_app_img.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: 300,
                decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
              ),
              getcontentform()
            ],
          ),
        ],
      ),
    );
  }

  Widget getcontentform() {
    return Column(
      children: [
        getimageicon(100, 100),
        Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Form(
                    key: formkey,
                    child: getform(),
                  ),
                  Container(
                      width: 250,
                      padding: const EdgeInsets.only(top: 30),
                      child: getelevatedbutton(
                          onpress: () {
                            if (formkey.currentState!.validate()) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const BottomNavbar()),
                                  (route) => false);
                            }
                          },
                          textchild: "Login")),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah punya akun?",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getform() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: TextFormField(
            validator: (val) => val!.isEmpty ? 'Mohon isi Username anda' : null,
            decoration: const InputDecoration(
                icon: Icon(Icons.people),
                hintText: 'Masukkan Username Anda',
                labelText: 'Username'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: TextFormField(
            validator: (val) => val!.isEmpty ? 'Mohon isi Email anda' : null,
            decoration: const InputDecoration(
                icon: Icon(Icons.email),
                hintText: 'Masukkan Email Anda',
                labelText: 'Email'),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: TextFormField(
            validator: (val) => val!.isEmpty ? 'Mohon password!' : null,
            decoration: const InputDecoration(
              icon: Icon(Icons.lock),
              hintText: 'Masukkan Masukkan Password',
              labelText: 'Password',
            ),
          ),
        ),
      ],
    );
  }
}
