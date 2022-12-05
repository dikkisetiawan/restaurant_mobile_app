import 'package:flutter/material.dart';
import 'package:restorant/login_&_register/register.dart';
import 'package:restorant/widget/bottom_navbar.dart';
import 'package:restorant/widget/button/button.dart';
import 'package:restorant/widget/image/icon_app_img.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showpw = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
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
                    "Login",
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
                          "belum punya akun?",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ));
                          },
                          child: const Text(
                            "Register",
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
            obscureText: !showpw,
            decoration: InputDecoration(
              icon: const Icon(Icons.lock),
              hintText: 'Masukkan Masukkan Password',
              labelText: 'Password',
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    showpw = !showpw;
                  });
                },
                child: Icon(showpw ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
