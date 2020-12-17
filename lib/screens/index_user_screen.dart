import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bootcamp_growdev_user_list/infra/db.dart';
import 'package:bootcamp_growdev_user_list/models/user.dart';
import 'package:bootcamp_growdev_user_list/routes/routes.dart';
import 'package:bootcamp_growdev_user_list/repositories/user_repository.dart';

class IndexUserScreen extends StatefulWidget {
  IndexUserScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _IndexUserScreenState createState() => _IndexUserScreenState();
}

class _IndexUserScreenState extends State<IndexUserScreen> {
  List<User> users;
  var repository = UserRepository(DB());
  Future<List<User>> getUsers;

  @override
  void initState() {
    super.initState();
    getUsers = repository.index();
  }

  Future<bool> _showDeleteDialog(DismissDirection direction) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete user'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 20.0,
        ),
        child: FutureBuilder(
          future: getUsers,
          builder: (_context, AsyncSnapshot<List<User>> snapshot) {
            if (!snapshot.hasData) {
              print('snapshot = $snapshot');
              return Center(
                child: Text('There are no users!'),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            }

            users = snapshot.data;
            print('users length = ${users.length}');

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                var user = users[index];
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  child: Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) async {
                      var deleted = await repository.destroy(user.id);
                      if (deleted) {
                        setState(() {
                          users.removeAt(index);
                        });
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("User ${user.name} dismissed")));
                      }
                    },
                    background: Container(
                      padding: EdgeInsets.only(right: 20.0),
                      color: Colors.red.shade600,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    confirmDismiss: _showDeleteDialog,
                    direction: DismissDirection.endToStart,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border(
                          right: BorderSide(
                            width: 10.0,
                            color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: Hero(
                          tag: user.id.toString(),
                          child: CircleAvatar(
                            backgroundImage: user.image == null
                                ? AssetImage('assets/user.jpg')
                                : FileImage(
                                    user.image,
                                  ),
                          ),
                        ),
                        title: Text(
                          '${user.name}, ${user.age} years old',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Document: ${user.document}'),
                            Text('Email: ${user.email}'),
                          ],
                        ),
                        isThreeLine: true,
                        onTap: () async {
                          var userUpdated =
                              await Navigator.of(context).pushNamed(
                            AppRoutes.CREATE_USER,
                            arguments: user,
                          );

                          if (userUpdated != null) {
                            setState(() {
                              user = userUpdated;
                            });
                          }
                        },
                        onLongPress: () async {
                          var deleted = await repository.destroy(user.id);
                          if (deleted) {
                            setState(() {
                              users.removeAt(index);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          var user = await Navigator.pushNamed(
            context,
            AppRoutes.CREATE_USER,
          );
          if (user != null) {
            setState(() {
              users.add(user);
            });
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
