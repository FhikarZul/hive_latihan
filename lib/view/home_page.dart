import 'package:flutter/material.dart';
import 'package:hive_latihan/hive/data_source.dart';
import 'package:hive_latihan/model/user_model.dart';
import 'package:hive_latihan/view/add_contact_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dataSource = DataSource();
  Map<String, UserModel> contacts = {};
  final nameC = TextEditingController();
  final phoneC = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchContact();
  }

  void fetchContact() async {
    final result = await dataSource.getAllContact();

    setState(() {
      contacts = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...contacts.entries.map(
                (e) {
                  final key = e.key;
                  final value = e.value;

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          _updateDialog(uuid: key, userModel: e.value);
                        },
                        child: ListTile(
                          leading: const Icon(Icons.person_pin),
                          title: Text(value.name),
                          subtitle: Text(value.phone),
                          trailing: InkResponse(
                            onTap: () {
                              dataSource.deleted(uuid: key);
                              fetchContact();
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const AddCpntactPage()),
            ),
          );

          if (result != null) {
            fetchContact();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _updateDialog({required String uuid, required UserModel userModel}) {
    nameC.text = userModel.name;
    phoneC.text = userModel.phone;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameC,
            ),
            TextField(
              controller: phoneC,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await dataSource.update(
                  uuid: uuid,
                  userModel: UserModel(
                    uuid: uuid,
                    name: nameC.text,
                    phone: phoneC.text,
                  ),
                );

                if (result) {
                  fetchContact();

                  Future.delayed(const Duration(seconds: 0)).whenComplete(
                    () => Navigator.pop(context),
                  );
                }
              },
              child: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}
