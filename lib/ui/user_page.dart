import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:user_app/helpers/user_helper.dart';

class UserPage extends StatefulWidget {

  final User user;
  UserPage({this.user});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _userEdited = false;
  User _editedUser;

  @override
  void initState() {
    super.initState();

    if (widget.user == null) {
      _editedUser = new User();
    } else {
      _editedUser = widget.user;
      _nameController.text = _editedUser.name;
      _emailController.text = _editedUser.email;
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
        onPressed: () {},
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
                        image: AssetImage("images/avatar.png")
                    )
                ),
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
            )
          ],
        ),
      ),
    );
  }
}
