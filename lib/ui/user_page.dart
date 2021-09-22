import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:user_app/helpers/user_helper.dart';

//const urlApi = "http://192.168.15.32:8088/";
// Esse é o IP do wifi
const urlApi = "http://192.168.15.61:80/users";

class UserPage extends StatefulWidget {
  final User user;
  UserPage({this.user});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userTypeController = TextEditingController();
  final _statusController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _userTypeFocus = FocusNode();
  final _statusFocus = FocusNode();

  var _userTypesEnum = ['administrator', 'client'];
  var _statusEnum = ['active', 'inactive'];

  bool _userEdited = false;
  User _editedUser;

  Future<String> saveUser(User user) async {
    final http.Response response = await http.post(
      urlApi,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'token': "123",
        'userType': user.userType,
        'status': user.status
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return "operation success";
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  Future<String> updateUser(User user) async {
    final http.Response response = await http.put(
      urlApi,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "_id": user.id,
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'token': "123",
        'userType': user.userType,
        'status': user.status
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      return "operation success";
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.user == null) {
      _editedUser = new User();
    } else {
      _editedUser = widget.user;
      _nameController.text = _editedUser.name;
      _emailController.text = _editedUser.email;
      _passwordController.text = _editedUser.password;
      _userTypeController.text = _editedUser.userType;
      _statusController.text = _editedUser.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(_editedUser.name ?? "Novo usuário"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("event onPressed");

          //print(_editedUser.name);
          //print(_editedUser.id);
          //print(_editedUser.email);
          //print(_editedUser.password);
          //print(_editedUser.userType);
          //print(_editedUser.status);

          if (_editedUser.name.isEmpty || _editedUser.name == null) {
            FocusScope.of(context).requestFocus(_nameFocus);
          }

          if (_editedUser.email.isEmpty || _editedUser.email == null) {
            FocusScope.of(context).requestFocus(_emailFocus);
          }

          if (_editedUser.password.isEmpty || _editedUser.password == null) {
            FocusScope.of(context).requestFocus(_passwordFocus);
          }

          if (_editedUser.userType.isEmpty || _editedUser.userType == null) {
            FocusScope.of(context).requestFocus(_userTypeFocus);
          }

          if (_editedUser.status.isEmpty || _editedUser.status == null) {
            FocusScope.of(context).requestFocus(_statusFocus);
          }

          if (_editedUser.id == null) {
            print("INSERT");
            saveUser(_editedUser).then((result) {
              print("---- Result ----");
              print(result);
              Navigator.pop(context, _editedUser);
            });
          } else {
            print("UPDATE");
            updateUser(_editedUser).then((result) {
              print("---- Result ----");
              print(result);
              Navigator.pop(context, _editedUser);
            });
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage("images/avatar.png"))),
              ),
            ),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(labelText: "Name"),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editedUser.name = text;
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "email"),
              onChanged: (text) {
                _userEdited = true;
                _editedUser.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "password"),
              onChanged: (text) {
                _userEdited = true;
                _editedUser.password = text;
              },
              keyboardType: TextInputType.visiblePassword,
            ),
            DropdownButton<String>(
              items: _userTypesEnum.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem.toLowerCase(),
                  child: Text(dropDownStringItem),
                );
              }).toList(),
              onChanged: (String userTypeSelected) {
                setState(() {
                  _userEdited = true;
                  _editedUser.userType = userTypeSelected;
                });
              },
              value: _editedUser.userType,
            ),
            DropdownButton<String>(
              items: _statusEnum.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(dropDownStringItem),
                );
              }).toList(),
              onChanged: (String statusSelected) {
                setState(() {
                  _userEdited = true;
                  _editedUser.status = statusSelected;
                });
              },
              value: _editedUser.status,
            ),
          ],
        ),
      ),
    );
  }
}
