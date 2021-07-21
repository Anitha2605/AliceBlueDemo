import 'package:aliceblu_demo/user_model.dart';
import 'package:flutter/material.dart';

import 'loginScreen.dart';

class NavDrawer extends StatelessWidget {
  User? userDetails;
  NavDrawer({this.userDetails});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Side menu',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(userDetails?.data?.name ?? ""),
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text(userDetails?.data?.userId ?? ""),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(userDetails?.data?.emailId ?? ""),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false)

          ),
        ],
      ),
    );
  }
}
