import 'dart:ui';

import 'package:aliceblu_demo/scheme_model.dart';
import 'package:aliceblu_demo/schemedetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';

class SchemePage extends StatefulWidget {
  _SchemePageState createState() => _SchemePageState();
}

class _SchemePageState extends State<SchemePage> {
  Future<SchemeModel?> callSchemeApiService() async {
    var uriObj = Uri.parse("https://dwtest.aliceblueonline.com/ftest/list.php");

    var response = await http.post(uriObj, body: {
      'user': 'cdw3n82a9w',
      'key': 'WQEr432D34r3d93r',
    });
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      SchemeModel schemeModel;
      if (response.body.toLowerCase().contains("success")) {
        schemeModel = SchemeModel.fromJson(jsonResponse);
      } else {
        schemeModel = SchemeModel(
            status: "Failure",
            message: "API authentication failed",
            data: null);
      }

      return schemeModel;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            child: FutureBuilder<SchemeModel?>(
                future: callSchemeApiService(),
                builder: (BuildContext context,
                    AsyncSnapshot<SchemeModel?> snapshot) {
                  if (snapshot.data == null) {
                    return Container(child: Center(child: Text("Loading...")));
                  } else {
                    return ListView.separated(
                        separatorBuilder: (context, index) =>
                            Container(height: 1, color: Colors.black),
                        itemCount: snapshot.data!.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title:
                                Text(snapshot.data!.data![index].schemeName!),
                            subtitle:
                                Text(snapshot.data!.data![index].schemecode!),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SchemeDetail(
                                      schemeData: snapshot.data!.data![index],
                                    ),
                                  ));
                            },
                          );
                        });
                  }
                }));
  }
}
