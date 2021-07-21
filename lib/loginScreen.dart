import 'dart:ui';

import 'package:aliceblu_demo/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'homeScreen.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtEmailIdController = TextEditingController();
  TextEditingController txtPswdController = TextEditingController();
  bool isSecurePswEnable = true;
  GoogleSignIn _gSignIn = GoogleSignIn(clientId: '175723429362-vo23qn9se1br82h8t42bcrt3q1tglku1.apps.googleusercontent.com', scopes: ["email"]);

  Future<User?> callLoginApiService(String email, String pswd) async {
    var uriObj =
        Uri.parse("https://dwtest.aliceblueonline.com/ftest/login.php");
    // https://dwtest.aliceblueonline.com/ftest/login.php
    var response = await http.post(uriObj, body: {
      'user': 'cdw3n82a9w',
      'key': 'WQEr432D34r3d93r',
      'email': email,
      'pwd': pswd
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      User userObj;
      if (response.body.toLowerCase().contains("success")) {
        userObj = User.fromJson(jsonResponse);
      } else {
        userObj =
            User(status: "Failure", message: "No Guest found", data: null);
      }

      return userObj;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Login Page"),
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: txtEmailIdController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              suffixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              )),
                              labelText: 'EmailId',
                              hintText: 'EmailId',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: txtPswdController,
                          obscureText: isSecurePswEnable,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isSecurePswEnable =
                                          isSecurePswEnable ? false : true;
                                    });
                                  },
                                  child: isSecurePswEnable
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off)),
                              border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              )),
                              labelText: 'Password',
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String username = txtEmailIdController.text;
                            String password = txtPswdController.text;
                            if (username.length == 0) {
                              var snack =
                                  SnackBar(content: Text('User name required'));
                              ScaffoldMessenger.of(context).showSnackBar(snack);
                              return;
                            }

                            if (password.length == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Password required')));
                              return;
                            }
                            User? userObj = await callLoginApiService(
                                txtEmailIdController.text,
                                txtPswdController.text);

                            if ((userObj != null) &&
                                (userObj.data != null) &&
                                (userObj.data?.emailId?.length != 0)) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            userDetails: userObj,
                                          )),
                                  (route) => false);
                            } else {
                              var snack = SnackBar(
                                  content: Text('Something went wrong!'));
                              ScaffoldMessenger.of(context).showSnackBar(snack);
                              return;
                            }
                          },
                          child: Text("Login"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(children: [
                          Text("(or)"),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              try {
                                _gSignIn.signIn().then((userData) {
                                  print("Google UserData: \n $userData");
                                  var snack = SnackBar(
                                      content: Text(userData.toString()));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snack);
                                });
                              } catch (error) {
                                var snack = SnackBar(
                                    content:
                                        Text("Error while Logging In: $error"));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snack);
                              }
                            },
                            child: Text("Google Sign In"),
                          )
                        ])
                      ]))),
        ));
  }
}
