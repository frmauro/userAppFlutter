import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:user_app/helpers/user_helper.dart';

const urlApi = "http://192.168.15.32:8088/";

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

  var _userTypesEnum = ['Administrator', 'Client'];
  var _statusEnum = ['Active', 'Inactive'];

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

    if (response.statusCode == 201) {
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
          print(_editedUser.name);
          print(_editedUser.email);
          print(_editedUser.password);
          print(_editedUser.userType);
          print(_editedUser.status);
          saveUser(_editedUser).then((result) {
            print(result);
          });
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
                  value: dropDownStringItem,
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
