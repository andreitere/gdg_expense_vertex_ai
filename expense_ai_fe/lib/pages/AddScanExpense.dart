import 'dart:convert';
import 'dart:io';

import 'package:expense_ai_fe/models/api.dart';
import 'package:expense_ai_fe/state/GroupsController.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddScanExpense extends StatefulWidget {
  final int groupId;

  const AddScanExpense({super.key, required this.groupId});

  @override
  State<AddScanExpense> createState() => _AddScanExpenseState();
}

class _AddScanExpenseState extends State<AddScanExpense> {
  final ImagePicker picker = ImagePicker();
  final GroupsController _groupsController = Get.find<GroupsController>();
  XFile? imageFile;

  ExpensesReceipt? scannedReceipt;

  void _takePicture() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        imageFile = photo;
      });
    }
  }

  void _uploadFile() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageFile = image;
      });
    }
  }

  Future<String?> getBase64FromFile(XFile? file) async {
    if (file == null) return null;
    return base64Encode(await file.readAsBytes());
  }

  Future<void> _processReceipt() async {
    String? b64 = await getBase64FromFile(imageFile);
    if (b64 == null) return;
    var receipt = await _groupsController.createExpense(b64);
    setState(() {
      scannedReceipt = receipt;
    });
  }

  final List<String> users = ['User 1', 'User 2', 'User 3', 'User 4'];
  Map<String, String> selectedUsers = {};

  @override
  Widget build(BuildContext context) {
    // You might fetch data here or simply display it
    return Container(
      padding: EdgeInsets.all(20),
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Add Expense (using receipt)",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Visibility(
            visible: imageFile == null,
            child: Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Card(
                    child: InkWell(
                      onTap: _uploadFile,
                      child: Container(
                          height: 150,
                          padding: const EdgeInsets.all(20),
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload,
                                color: Colors.blue.shade600,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("upload picture"),
                            ],
                          ))),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Visibility(
            visible: imageFile != null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: SizedBox(
                width: double.infinity,
                height: 150,
                child: imageFile != null
                    ? Image.network(imageFile!.path, fit: BoxFit.cover)
                    : null,
              ),
            ),
          ),
          SizedBox(height: 10),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _groupsController.processingReceipt.value ||
                          imageFile == null
                      ? null
                      : _processReceipt,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0)),
                  icon: _groupsController.processingReceipt.value
                      ? Container(
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.blueAccent,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.auto_fix_high_outlined),
                  label: const Text('process'),
                ),
              ],
            );
          }),
          Expanded(
            // Makes the SingleChildScrollView flexible within the column
            child: SingleChildScrollView(
              child: scannedReceipt != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: scannedReceipt!.items.map(
                        (e) {
                          String productKey = '${e.title}_${e.price}';
                          return Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.title,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                          'Price: ${e.price.toStringAsFixed(2)}'),
                                      Text('Quantity: ${e.quantity}'),
                                      SizedBox(height: 16),
                                      // Using Row to align DropdownButton to the right
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Assigned to: ${selectedUsers[productKey] ?? "None"}'),
                                          DropdownButton<String>(
                                            hint: Text("Assign User"),
                                            value: selectedUsers[productKey],
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedUsers[productKey] =
                                                    newValue!;
                                              });
                                            },
                                            items: users
                                                .map<DropdownMenuItem<String>>(
                                                    (String user) {
                                              return DropdownMenuItem<String>(
                                                value: user,
                                                child: Text(user),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      )
                                    ]),
                              ));
                        },
                      ).toList(),
                    )
                  : SizedBox(
                      width: 0,
                    ),
            ),
          ),
          Center(
            child: Visibility(
              child: FilledButton(
                onPressed: () => {
                  setState(() {
                    imageFile = null;
                  })
                },
                child: Text("reset"),
              ),
            ),
          ),
          // Visibility(
          //     visible: kIsWeb && imageFile != null,
          //     child: Image.network(imageFile!.path)),
          // Visibility(
          //     visible: !kIsWeb && imageFile != null,
          //     child: Image.file(File(imageFile!.path)))
        ],
      ),
    );
  }
}
