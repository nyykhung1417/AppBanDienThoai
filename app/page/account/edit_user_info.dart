import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final User user;

  const EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController _fullNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _genderController;
  late TextEditingController _birthDayController;
  late TextEditingController _schoolYearController;
  late TextEditingController _schoolKeyController;
  late TextEditingController _imageURLController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName);
    _phoneNumberController =
        TextEditingController(text: widget.user.phoneNumber);
    _genderController = TextEditingController(text: widget.user.gender);
    _birthDayController = TextEditingController(text: widget.user.birthDay);
    _schoolYearController = TextEditingController(text: widget.user.schoolYear);
    _schoolKeyController = TextEditingController(text: widget.user.schoolKey);
    _imageURLController = TextEditingController(text: widget.user.imageURL);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _genderController.dispose();
    _birthDayController.dispose();
    _schoolYearController.dispose();
    _schoolKeyController.dispose();
    _imageURLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 46, 239, 194),
                Color.fromARGB(255, 0, 212, 131).withOpacity(0.5),
                Color.fromARGB(255, 33, 240, 243).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Chỉnh sửa thông tin",
          style: TextStyle(fontSize: 26, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFormField(_fullNameController, 'Họ và tên'),
            const SizedBox(height: 16),
            _buildTextFormField(_phoneNumberController, 'Số điện thoại'),
            const SizedBox(height: 16),
            _buildTextFormField(_genderController, 'Giới tính'),
            const SizedBox(height: 16),
            _buildTextFormField(_birthDayController, 'Ngày sinh'),
            const SizedBox(height: 16),
            _buildTextFormField(_schoolYearController, 'Năm học'),
            const SizedBox(height: 16),
            _buildTextFormField(_schoolKeyController, 'Khóa học'),
            const SizedBox(height: 16),
            _buildTextFormField(_imageURLController, 'Đường dẫn ảnh'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Center(
                child: const Text('Lưu', style: TextStyle(color: Colors.white)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextFormField(
      TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final updatedUser = User(
      idNumber: widget.user.idNumber,
      accountId: widget.user.accountId,
      fullName: _fullNameController.text,
      phoneNumber: _phoneNumberController.text,
      imageURL: _imageURLController.text,
      birthDay: _birthDayController.text,
      gender: _genderController.text,
      schoolYear: _schoolYearController.text,
      schoolKey: _schoolKeyController.text,
      dateCreated: widget.user.dateCreated,
      status: widget.user.status,
    );

    try {
      Dio dio = Dio();
      final response = await dio.put(
        'https://huflit.id.vn:4321/api/Auth/updateProfile',
        data: FormData.fromMap({
          'NumberID': updatedUser.idNumber,
          'FullName': updatedUser.fullName,
          'PhoneNumber': updatedUser.phoneNumber,
          'Gender': updatedUser.gender,
          'BirthDay': updatedUser.birthDay,
          'SchoolYear': updatedUser.schoolYear,
          'SchoolKey': updatedUser.schoolKey,
          'ImageURL': updatedUser.imageURL,
        }),
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final success = await saveUser(updatedUser);
        if (success) {
          Navigator.pop(context, true);
        } else {
          print("Lưu thông tin người dùng thất bại");
        }
      } else {
        print("Cập nhật thông tin thất bại: ${response.data}");
      }
    } catch (e) {
      print("Lỗi khi cập nhật thông tin: $e");
    }
  }
}

Future<bool> saveUser(User objUser) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUser = jsonEncode(objUser.toJson());
    prefs.setString('user', strUser);
    print("Lưu thành công: $strUser");
    return true;
  } catch (e) {
    print("Lỗi khi lưu user: $e");
    return false;
  }
}

Future<User> getUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String strUser = pref.getString('user') ?? '';
  return User.fromJson(jsonDecode(strUser));
}
