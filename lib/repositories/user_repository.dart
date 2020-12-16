import 'package:bootcamp_growdev_user_list/infra/db.dart';
import 'package:bootcamp_growdev_user_list/models/user.dart';

class UserRepository {
  final DB _db;

  UserRepository(this._db);

  Future<List<User>> index() async {
    var instance = await _db.getInstance();
    print('getUsers');

    var users = await instance.query('users');

    return List.generate(users.length, (index) {
      return User(
        id: users[index]['id'],
        name: users[index]['name'],
        document: users[index]['document'],
        active: users[index]['active'] == 0 ? false : true,
        age: users[index]['age'],
      );
    });
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
