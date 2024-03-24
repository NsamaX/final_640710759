import 'dart:convert';

import 'package:flutter/material.dart';

import '../helpers/api_caller.dart';
import '../helpers/dialog_utils.dart';
import '../helpers/my_list_tile.dart';
import '../helpers/my_text_field.dart';
import '../models/misfortune.dart';

final String baseUrl = "https://cpsu-api-49b593d4e146.herokuapp.com";
final String apiData = "api/2_2566/final/web_types";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<misfortune> _misfortunes = [];
  TextEditingController urlController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  misfortune? selectedMisfortune;

  @override
  void initState() {
    super.initState();
    _loadmisfortunes();
  }

  Future<void> _loadmisfortunes() async {
    try {
      final data = await ApiCaller().get(baseUrl, apiData);
      List list = jsonDecode(data);
      setState(() {
        _misfortunes = list.map((e) => misfortune.fromJson(e)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  void _handleTileTap(int index) {
    setState(() {
      // Deselect all items first
      _misfortunes.forEach((item) => item.selected = false);
      // Select the tapped item
      selectedMisfortune = _misfortunes[index];
      _misfortunes[index].selected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
            child: const Text(
          'Webby Fondus\nระบบรายงานเว็ปเลวๆ',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyTextField(
              controller: urlController,
              hintText: 'URL *',
              keyboardType: TextInputType.text,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: MyTextField(
                controller: detailsController,
                hintText: 'รายละเอียด',
                keyboardType: TextInputType.text,
              ),
            ),
            Text('ระบุระเภเว็เลว*', style: textTheme.titleMedium),
            Expanded(
              child: ListView.builder(
                itemCount: _misfortunes.length,
                itemBuilder: (context, index) {
                  final item = _misfortunes[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyListTile(
                      title: item.title,
                      subtitle: item.subtitle,
                      baseUrl: baseUrl,
                      imageUrl: item.imageUrl,
                      selected: item.selected,
                      onTap: () => _handleTileTap(index),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),

            // ปุ่มทดสอบ POST API
            ElevatedButton(
              onPressed: _handleApiPost,
              child: const Text('ส่งข้อมูล'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    if (urlController.text.isEmpty || selectedMisfortune == null) {
      showOkDialog(
        context: context,
        title: "Error",
        message: "กรุณากรอก URL และเลือกประเภทเว็ป",
      );
      return;
    }

    try {
      print(urlController.text.isEmpty ? "URL null" : urlController.text);
      print(detailsController.text.isEmpty
          ? "Detail null"
          : detailsController.text);
      print(selectedMisfortune!.id);
      final data = await ApiCaller().post(
        baseUrl,
        "api/2_2566/final/report_web",
        params: {
          "id": selectedMisfortune!.id,
          "type": selectedMisfortune!.title,
          "url": urlController.text,
          "description":
              detailsController != null ? detailsController.text : "",
        },
      );
      // API นี้จะส่งข้อมูลที่เรา post ไป กลับมาเป็น JSON object ดังนั้นต้องใช้ Map รับค่าจาก jsonDecode()

      // Parse the response JSON
      Map<String, dynamic> response = jsonDecode(data);

      // Extract the values
      int id = response['insertItem']['id'];
      String url = response['insertItem']['url'];
      String type = response['insertItem']['type'];
      List<dynamic> summary = response['summary'];

      // Show dialog here
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            // content: Text(text),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }
}
