import 'dart:math';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_latihan/hive/dao/contact.dart';
import 'package:hive_latihan/model/user_model.dart';

class DataSource {
  static const boxName = 'contact';

  Future<bool> addContact({required String name, required String phone}) async {
    final rand = Random();

    final uuid = rand.nextInt(99999999);

    try {
      final box = await Hive.openBox<Contact>(boxName);

      final contact = Contact()
        ..uuid = uuid.toString()
        ..name = name
        ..phone = phone;

      box.put(uuid.toString(), contact);

      box.close();

      return true;
    } catch (e) {
      print('Add contact is failed. [$e]');
    }

    return false;
  }

  Future<Map<String, UserModel>> getAllContact({required String name}) async {
    Map<String, UserModel> map = {};

    try {
      final box = await Hive.openBox<Contact>(boxName);

      var mapData = box.toMap();

      for (var data in mapData.entries) {
        if (data.value.name.toLowerCase().contains(name.toLowerCase())) {
          map.putIfAbsent(
            data.key,
            () => UserModel(
              uuid: data.value.uuid,
              name: data.value.name,
              phone: data.value.phone,
            ),
          );
        }
      }
      box.close();
    } catch (e) {
      print('Get contact is error!. [$e]');
    }

    return map;
  }

  Future<bool> deleted({required String uuid}) async {
    try {
      final box = await Hive.openBox<Contact>(boxName);

      box.delete(uuid);

      box.close();

      return true;
    } catch (e) {
      print('Deleted is failed [$e]');
    }

    return false;
  }

  Future<bool> update({
    required String uuid,
    required UserModel userModel,
  }) async {
    try {
      final box = await Hive.openBox<Contact>(boxName);
      final contact = Contact()
        ..uuid = uuid
        ..name = userModel.name
        ..phone = userModel.phone;

      box.put(uuid, contact);

      box.close();

      return true;
    } catch (e) {
      print('Update is failed. [$e]');
    }

    return false;
  }
}
