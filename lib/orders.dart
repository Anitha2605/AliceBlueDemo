import 'dart:ui';

import 'package:aliceblu_demo/scheme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

import 'order_model.dart';

class OrderPage extends StatefulWidget {
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  Future<OrderModel?> callOrderApiService() async {
    var uriObj =
        Uri.parse("https://dwtest.aliceblueonline.com/ftest/orders.php");

    var response = await http.post(uriObj, body: {
      'user': 'cdw3n82a9w',
      'key': 'WQEr432D34r3d93r',
      'userId': '118',
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      OrderModel? orderModel;
      if (response.body.toLowerCase().contains("success")) {
        orderModel = OrderModel.fromJson(jsonResponse);
      } else {
        orderModel = OrderModel(
            status: "Failure", message: "No order Found", data: null);
      }

      return orderModel;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            child: FutureBuilder<OrderModel?>(
                future: callOrderApiService(),
                builder: (BuildContext context,
                    AsyncSnapshot<OrderModel?> snapshot) {
                  if (snapshot.data == null) {
                    return Container(child: Center(child: Text("Loading...")));
                  } else {
                    return Center(
                        child: Text(
                            "orderId : ${snapshot.data!.data!.orderId!} \n userId : ${snapshot.data!.data!.userId} \n schemeCode : ${snapshot.data!.data!.schemeCode} \n orderAmount :  ${snapshot.data!.data!.orderAmount} \n orderDate : ${snapshot.data!.data!.orderDate} "));
                  }
                }));
  }
}
