import 'dart:io';

import 'package:expense_ai_fe/models/api.dart';
import 'package:expense_ai_fe/pages/AddScanExpense.dart';
import 'package:expense_ai_fe/state/GroupsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GroupDetails extends StatefulWidget {
  final int groupId;
  const GroupDetails({super.key, required this.groupId});

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  UserGroup? groupDetails;
  GroupsController groupsCtrl = Get.find<GroupsController>();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takePicture() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  Future<void> fetchDataFromApi() async {
    groupDetails =
        await groupsCtrl.getGroup(widget.groupId); // Simulate network delay
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDataFromApi(),
      builder: (context, _) {
        if (groupDetails == null) {
          return Center(
            child: Text("not found"),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                groupDetails?.photo != null
                    ? Image.network(
                        groupDetails?.photo as String,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(
                        width: 0,
                      ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          groupDetails?.title ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Category: ${groupDetails?.category}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        // const SizedBox(height: 8),
                        // Text(
                        //   groupDetails?.description ?? "",
                        //   style: const TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 16,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Expenses',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => FractionallySizedBox(
                          heightFactor: 0.95,
                          widthFactor: 0.95,
                          child: AddScanExpense(groupId: widget.groupId),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
