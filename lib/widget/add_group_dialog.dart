import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_password_manager/api/api.dart';
class GroupCreateBottomSheet extends StatefulWidget {
  const GroupCreateBottomSheet({Key? key}) : super(key: key);

  @override
  State<GroupCreateBottomSheet> createState() => _GroupCreateBottomSheetState();
}

class _GroupCreateBottomSheetState extends State<GroupCreateBottomSheet> {
  final TextEditingController _groupNameController = TextEditingController();
  final List<String> _selectedMembers = [];
  late DateTime _createdAt;
  late DateTime _lastMessageTime;

  @override
  void initState() {
    super.initState();
    _createdAt = DateTime.now();
    _lastMessageTime = DateTime.now();
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  // Save group data to Firestore
  void _saveGroupToFirestore() async {
    if (_groupNameController.text.isNotEmpty && _selectedMembers.isNotEmpty) {
      final  groupid ='${APIs.myUser.uid}-${_groupNameController.text}';
      final groupData = {
        'group_id':groupid,
        'created_at': Timestamp.now(),
        'last_message': 'Hello', // Can be updated when the first message is sent
        'last_message_time': Timestamp.now(),
        'members': _selectedMembers,
        'name': _groupNameController.text,

      };


      APIs.createGroup(groupData);
    } else {
      // Handle validation (group name or members not selected)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _groupNameController,
            decoration: const InputDecoration(
              labelText: "Group Name",
              labelStyle: TextStyle(color: Colors.green),
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green))
            ),
          ),
          const SizedBox(height: 8),
          Text("Select Group Members"),
          // You can implement a list of available members here
          // For now, just assume we have a list of users to select
          // Example members selection:
          ListView.builder(
            shrinkWrap: true,
            itemCount: 5, // Example, replace with dynamic data
            itemBuilder: (context, index) {
              return CheckboxListTile(
                activeColor: Colors.green,
                title: Text("User $index"),
                value: _selectedMembers.contains("User $index"),
                onChanged: (value) {
                  setState(() {
                    if (value == true) {
                      _selectedMembers.add("User $index");
                    } else {
                      _selectedMembers.remove("User $index");
                    }
                  });
                },
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveGroupToFirestore,
            child: const Text("Create Group"),
          ),
        ],
      ),
    );
  }
}