import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:user_app/helpers/user_helper.dart';

const urlApi = "http://192.168.15.32:8088/";

void main() async {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _userController = TextEditingController();
  List<User> _users = [];

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  void _addUser() {}

  Future<Null> _refresh() async {
    return null;
  }

  Future<String> getAllUsers() async {
    http.Response res = await http.get(urlApi, headers: _setHeaders());

    if (res.statusCode == 200) {
        return res.body;
      //print("TESTE=======>>>>>" + _users[1]["name"]);
    }
    return "erro";
  }

  @override
  void initState() {
    super.initState();
    this.getAllUsers()
        .then((body) {
            //this.setState(() {
             var jsonUsers = json.decode(body) as List;
             List<dynamic> list;
             print(" ************* TESTE *************");
             //print(jsonUsers);
             print(_users);

             jsonUsers.forEach((e) {
                 //print(e["_id"]);
                 //print(e["name"]);
                 //print(e["password"]);
                 //print(e["email"]);
                 //print("FIM DO REGISTRO");
                 _users.add(User.fromJson(e));
             });

             print(" ************* TESTE 2 *************");
             print(_users);
             //list.map((i) =>  i );
            //});
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index){

          }
      ),
    );
  }

}
