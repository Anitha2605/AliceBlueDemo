import 'package:aliceblu_demo/placing_order.dart';
import 'package:aliceblu_demo/scheme_model.dart';
import 'package:aliceblu_demo/schemes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class SchemeDetail extends StatefulWidget {
  SchemeData? schemeData;
  SchemeDetail({this.schemeData});
  _SchemeDetailState createState() => _SchemeDetailState();
}

class _SchemeDetailState extends State<SchemeDetail> {
  TextEditingController txtAmountController = TextEditingController();
  Future<PlacingOrder?> callPlacingOrderApiService(String orderAmt) async {
    var uriObj =
        Uri.parse("https://dwtest.aliceblueonline.com/ftest/placingorder.php");
    // https://dwtest.aliceblueonline.com/ftest/login.php
    var response = await http.post(uriObj, body: {
      'user': 'cdw3n82a9w',
      'key': 'WQEr432D34r3d93r',
      'userId': '118',
      'schemeCode': '32037',
      'orderAmt': orderAmt
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      PlacingOrder placingOrderObj;
      if (response.body.toLowerCase().contains("success")) {
        placingOrderObj = PlacingOrder.fromJson(jsonResponse);
      } else {
        placingOrderObj = PlacingOrder(
            status: "Failure", message: "Order Amount Not Eligible");
      }

      return placingOrderObj;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: Text("Scheme Page"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
              child: Center(
                  child: Text(
                      "schemeName : ${widget.schemeData?.schemeName}\n schemeCode : ${widget.schemeData?.schemecode}\n minInv : ${widget.schemeData?.minInv}\n navrs : ${widget.schemeData?.navrs}\n schemeType : ${widget.schemeData?.schemeType}"))),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              txtAmountController.clear();
              showPopupDialog();
            } ,
            child: Icon(
              Icons.add,
            )));
  }

  void showPopupDialog(){
    showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                        title: TextFormField(
                          controller: txtAmountController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              )),
                              labelText: 'Enter Amount',
                              hintText: 'Enter Amount',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: () async {
                                String orderAmt = txtAmountController.text;
                                PlacingOrder? placingOrderObj =
                                    await callPlacingOrderApiService(
                                        orderAmt);
                                        Navigator.pop(context);

String msg = placingOrderObj?.message ?? ""; 
                                    
                                var snack =
                                    SnackBar(content: Text(msg));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snack);
                                return;
                              },
                              child: Text("payment"))
                        ]));
  }
}
