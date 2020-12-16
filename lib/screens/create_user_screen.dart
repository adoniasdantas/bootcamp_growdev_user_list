import 'package:flutter/material.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = (ModalRoute.of(context).settings?.arguments as User) ?? User();
  }

  void save() async {
    if (!_formKey.currentState.validate()) {
      showSnackBar(
        message: 'Preencha os campos corretamente!',
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
          message: 'Usuário não atualizado',
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
                      TextFormField(
                        initialValue: user?.name,
                        decoration: InputDecoration(hintText: 'Nome'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Este campo é obrigatório';
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
                        initialValue: user?.age,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: 'Idade'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Este campo é obrigatório';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          user.age = value;
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
                            return 'Este campo é obrigatório';
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
                        decoration: InputDecoration(hintText: 'Documento'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Este campo é obrigatório';
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
                          Text(user.active ? 'Ativo' : 'Inativo'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            RaisedButton(
              onPressed: save,
              color: Theme.of(context).primaryColor,
              child: Text(
                user?.id == null ? 'SAVE' : 'UPDATE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
