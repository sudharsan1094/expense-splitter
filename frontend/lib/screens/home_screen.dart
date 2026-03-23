import 'package:flutter/material.dart';
import '../models/group.dart';
import '../services/api_service.dart';
import 'group_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Group> _groups = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final groups = await ApiService.getGroups();
    setState(() {
      _groups = groups;
      _loading = false;
    });
  }

  void _showCreateGroupDialog() {
    final nameController = TextEditingController();
    final membersController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Group Name'),
            ),
            TextField(
              controller: membersController,
              decoration: const InputDecoration(
                labelText: 'Members (comma separated)',
                hintText: 'Alice, Bob, Charlie',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final members = membersController.text
                  .split(',')
                  .map((m) => m.trim())
                  .where((m) => m.isNotEmpty)
                  .toList();
              if (name.isNotEmpty && members.isNotEmpty) {
                await ApiService.createGroup(name, members);
                Navigator.pop(context);
                _loadGroups();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Splitter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _groups.isEmpty
              ? const Center(child: Text('No groups yet. Create one!'))
              : ListView.builder(
                  itemCount: _groups.length,
                  itemBuilder: (_, i) {
                    final group = _groups[i];
                    return ListTile(
                      leading: const Icon(Icons.group),
                      title: Text(group.name),
                      subtitle: Text('${group.members.length} members'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GroupScreen(group: group),
                        ),
                      ).then((_) => _loadGroups()),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateGroupDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}