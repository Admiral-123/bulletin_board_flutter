import 'package:bulletin_board/home_page.dart';
import 'package:bulletin_board/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController username_controller = TextEditingController();
  //TextEditingController password_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey,
        child: Center(
          child: Container(
            width: 350,
            height: 400,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0, left: 12.0, right: 12.0, top: 60),
                  child: TextField(
                    controller: username_controller,
                    decoration: InputDecoration(
                        labelText: 'username',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        )),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(
                //     right: 12.0,
                //     left: 12.0,
                //   ),
                //   child: TextField(
                //     controller: password_controller,
                //     obscureText: true,
                //     obscuringCharacter: '^',
                //     decoration: InputDecoration(
                //         labelText: 'password',
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(10.0),
                //           borderSide: BorderSide(color: Colors.black),
                //         ),
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(10.0),
                //           borderSide: BorderSide(color: Colors.grey),
                //         )),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        // set pref bool to true

                        // send to homepage

                        if (username_controller.text.isNotEmpty) {
                          var userName = username_controller.text;
                          var pref = await SharedPreferences.getInstance();
                          pref.setBool(SplashScrState.keyLogin, true);
                          pref.setString(SplashScrState.keyUser, userName);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  Navigator.pop(context);
                                });
                                return AlertDialog(
                                  actions: [
                                    Center(child: Text('add a useraname'))
                                  ],
                                );
                              });
                        }
                      },
                      child: Text('login')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
