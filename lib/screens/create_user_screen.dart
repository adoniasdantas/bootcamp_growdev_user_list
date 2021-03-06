import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bootcamp_growdev_user_list/infra/db.dart';
import 'package:bootcamp_growdev_user_list/models/user.dart';
import 'package:bootcamp_growdev_user_list/repositories/user_repository.dart';

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  User user;

  File file;

  final picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = (ModalRoute.of(context).settings?.arguments as User) ?? User();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          user.image = File(pickedFile.path);
          file = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    });
  }

  void save() async {
    if (!_formKey.currentState.validate()) {
      showSnackBar(
        message: 'Fill the fields correctly!',
        color: Colors.red,
      );
      return;
    }
    _formKey.currentState.save();
    var repository = UserRepository(DB());

    if (user.id != null) {
      var updated = await repository.update(user);
      if (!updated) {
        showSnackBar(
          message: 'User not updated!',
          color: Colors.red,
        );
        print('updateduser = $user');
        return;
      }
    } else {
      user.id = await repository.store(user);
    }

    Navigator.of(context).pop(user);
  }

  void showSnackBar({String message, Color color}) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        padding: EdgeInsets.all(10.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
        centerTitle: true,
      ),
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: getImage,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Hero(
                            tag: user?.id?.toString() ?? '',
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: user.image == null
                                  ? AssetImage('assets/user.jpg')
                                  : FileImage(
                                      user.image,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: user?.name,
                        decoration: InputDecoration(hintText: 'Name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          user.name = value;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        initialValue:
                            user?.age != null ? user?.age.toString() : '',
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Age'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'This field must be a number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          user.age = int.tryParse(value);
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        initialValue: user?.email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(hintText: 'Email'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          user.email = value;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        initialValue: user?.document,
                        decoration: InputDecoration(hintText: 'Document'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          user.document = value;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Switch(
                            value: user?.active,
                            onChanged: (value) {
                              print('switch = $value');
                              setState(() {
                                user.active = value;
                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                          ),
                          Text(user.active ? 'Active' : 'Inactive'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xfff24fdb),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(width: 20),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                    onPressed: save,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
