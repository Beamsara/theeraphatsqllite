import '/service/database_helper.dart';
import 'package:flutter/material.dart';

class SqlitePage extends StatefulWidget {
  const SqlitePage({super.key});

  @override
  State<SqlitePage> createState() => _SqlitePageState();
}

class _SqlitePageState extends State<SqlitePage> {
  DatabaseHelper dbHelper = DatabaseHelper();
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _telController = TextEditingController();
  List<Map<String, dynamic>> users = [];

  // ฟังก์ชันเพิ่มข้อมูล
  Future<void> _addUser() async {
    await dbHelper.insertUser({
      'name': _nameController.text,
      'nickname': _nicknameController.text,
      'email': _emailController.text,
      'tel': _telController.text,
    });
    _clearForm();
    _refreshUsers();
  }

  // ฟังก์ชันเคลียร์ฟอร์ม
  void _clearForm() {
    _nameController.clear();
    _nicknameController.clear();
    _emailController.clear();
    _telController.clear();
  }


  // ดึงข้อมูลเมื่อเริ่มใช้งานหน้า
  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  Future<void> _refreshUsers() async {
    final data = await dbHelper.getUsers();
    setState(() {
      users = data;
    });
  }

  // ฟังก์ชันแสดงฟอร์ม
  void _showForm(int? id) {
    if (id != null) {
      final existingUser = users.firstWhere((element) => element['id'] == id);
      _nameController.text = existingUser['name'];
      _nicknameController.text = existingUser['nickname'];
      _emailController.text = existingUser['email'];
      _telController.text = existingUser['tel'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 15,
            left: 15,
            right: 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'ชื่อ'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(labelText: 'ชื่อเล่น'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'อีเมล'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _telController,
                  decoration: InputDecoration(labelText: 'เบอร์โทร'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (id == null) {
                      _addUser();
                    } else {
                      _updateUser(id);
                    }
                    Navigator.of(context).pop(); // ปิด bottom sheet
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(id == null ? 'เพิ่มข้อมูล' : 'แก้ไขข้อมูล'),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // ฟังก์ชันแก้ไขข้อมูล
  Future<void> _updateUser(int id) async {
    await dbHelper.updateUser({
      'id': id,
      'name': _nameController.text,
      'nickname': _nicknameController.text,
      'email': _emailController.text,
      'tel': _telController.text,
    });
    _clearForm();
    _refreshUsers();
  }

  // ฟังก์ชันลบข้อมูล
  Future<void> _deleteUser(int id) async {
    await dbHelper.deleteUser(id);
    _refreshUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการข้อมูล'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: users.isEmpty
          ? Center(
        child: Text(
          'ไม่มีข้อมูล กรุณาเพิ่มข้อมูลใหม่',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(users[index]['name'][0]),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              title: Text(
                users[index]['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ชื่อเล่น: ${users[index]['nickname']}'),
                  Text('อีเมล: ${users[index]['email']}'),
                  Text('เบอร์โทร: ${users[index]['tel']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () => _showForm(users[index]['id']),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteUser(users[index]['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
      ),
    );
  }
}
