import 'package:expense_ai_fe/models/api.dart';
import 'package:expense_ai_fe/state/GroupsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<int> items = List.generate(20, (index) => index);
  final GroupsController groupsCtrl = Get.find<GroupsController>();
  final TextEditingController _txtCtrl = TextEditingController();

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    await groupsCtrl.loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    groupsCtrl.loadGroups();
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                return Column(
                    children: groupsCtrl.groups.value.map((group) {
                  return SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        elevation: 8, // Adds shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                        child: InkWell(
                          onTap: () {
                            context.go("/groups/${group.groupId}/details");
                          },
                          child: Column(
                            children: [
                              (group.photo != null)
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                      child: SizedBox(
                                          width: 400,
                                          height: 400,
                                          child: Image(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(group.photo as String),
                                          )))
                                  : SizedBox.shrink(),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${group.title}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8), // Spacer between title and description
                                      Text(
                                        group.description,
                                        maxLines: null,
                                        softWrap: true,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList());
              }),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showBottomSheet(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void createGroup() async {
    // Handle form submission
    CreatedGroup group = await groupsCtrl.createGroup(_txtCtrl.text);
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    context.go("/groups/${group.groupId}/details");
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                child: Text("What's this group about?"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _txtCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              Obx(() {
                return Center(
                  child: OutlinedButton.icon(
                    onPressed: groupsCtrl.creatingGroup.value ? null : createGroup,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    label: const Text("Create my group"),
                    icon: groupsCtrl.creatingGroup.value
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
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
