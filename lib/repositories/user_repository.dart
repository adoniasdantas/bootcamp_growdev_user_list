import 'package:bootcamp_growdev_user_list/infra/db.dart';
import 'package:bootcamp_growdev_user_list/models/user.dart';

class UserRepository {
  final DB _db;

  UserRepository(this._db);

  Future<List<User>> index() async {
    var instance = await _db.getInstance();
    print('getUsers');
    await Future.delayed(Duration(seconds: 2));
    var usersDB = await instance.query('users');

    usersDB.forEach((element) {
      print(element);
    });

    var users = usersDB.map((user) => User.fromJson(user)).toList();
    return users;
  }

  Future<int> store(User user) async {
    var instance = await _db.getInstance();

    final idUser = await instance.insert('users', user.toMap());

    return idUser;
  }

  Future<bool> update(User user) async {
    var instance = await _db.getInstance();

    final effects = await instance.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );

    print('idUserBanco $effects');
    print('userid ${user.id}');

    return effects > 0;
  }

  Future<bool> destroy(int id) async {
    var instance = await _db.getInstance();
    var effects =
        await instance.delete('users', where: 'id = ?', whereArgs: [id]);
    return effects > 0;
  }
}
