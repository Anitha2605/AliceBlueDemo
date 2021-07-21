import 'package:aliceblu_demo/orders.dart';
import 'package:aliceblu_demo/schemes.dart';
import 'package:aliceblu_demo/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  User? userDetails;
  HomeScreen({this.userDetails});

  _HomeScreenState createState() => _HomeScreenState();
}

@override
class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;
  List<Widget> listScreens = [SchemePage(), OrderPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(userDetails: widget.userDetails,),
        appBar: AppBar(
          title: Text("Home Screen"),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
        body: IndexedStack(index: _tabIndex, children: listScreens),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tabIndex,
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.schema,
                  color: Colors.grey,
                ),
                label: "Schemes",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.online_prediction_rounded,
                  color: Colors.grey,
                ),
                label: "orders",
              ),
            ]));
  }
}
