import 'package:flutter/material.dart';
import 'package:hive_latihan/hive/data_source.dart';

class AddCpntactPage extends StatefulWidget {
  const AddCpntactPage({Key? key}) : super(key: key);

  @override
  State<AddCpntactPage> createState() => _AddCpntactPageState();
}

class _AddCpntactPageState extends State<AddCpntactPage> {
  final dataSource = DataSource();
  late String name;
  late String phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama'),
              TextField(
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text('Nomor Hp'),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: ((value) {
                  setState(() {
                    phone = value;
                  });
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  dataSource
                      .addContact(
                        name: name,
                        phone: phone,
                      )
                      .whenComplete(() => Navigator.pop(context, true));
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
