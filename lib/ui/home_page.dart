import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:user_app/helpers/user_helper.dart';
import 'package:user_app/ui/user_page.dart';

//const urlApi = "http://192.168.15.32:8088/";
// Esse é o IP do wifi
const urlApi = "http://192.168.15.61:80/users";

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
    loadUsers();
  }

  void loadUsers() {
    this.getAllUsers().then((body) {
      var jsonUsers = json.decode(body) as List;
      List<dynamic> list;
      _users.clear();

      jsonUsers.forEach((e) {
        _users.add(User.fromJson(e));
      });

      setState(() {
        _users = _users;
      });
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
        onPressed: () {
          _showUserPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: _users.length,
          itemBuilder: (context, index) {
            return _userCard(context, index);
          }),
    );
  }

  Widget _userCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("images/avatar.png"))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _users[index].name ?? "",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _users[index].email ?? "",
                      style: TextStyle(fontSize: 12.0),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showUserPage(user: _users[index]);
      },
    );
  }

  void _showUserPage({User user}) async {
    final recUser = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserPage(user: user)));

    if (recUser != null) {
      if (user != null) {
        //method call to update user
      } else {
        // insert user
      }
      //method call load users
      loadUsers();
    }
  }
}
