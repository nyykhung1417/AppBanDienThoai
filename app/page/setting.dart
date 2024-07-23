import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/page/account/change_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/sharepre.dart';
import '../page/account/edit_user_info.dart';
import '../page/account/my_user_info.dart';
import '../model/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user = User.userEmpty();

  // Hàm lấy thông tin người dùng từ SharedPreferences
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');

    if (strUser != null && strUser.isNotEmpty) {
      try {
        user = User.fromJson(jsonDecode(strUser));
        setState(() {});
        print('Thông tin người dùng:');
        print('Số CMND: ${user.idNumber}');
        print('Họ và tên: ${user.fullName}');
        print('Số điện thoại: ${user.phoneNumber}');
        print('Giới tính: ${user.gender}');
        print('Ngày sinh: ${user.birthDay}');
        print('Niên khóa: ${user.schoolYear}');
        print('Mã trường: ${user.schoolKey}');
        print('Ngày tạo: ${user.dateCreated}');
        print('Ảnh đại diện: ${user.imageURL}');
      } catch (e) {
        print('Lỗi giải mã JSON: $e');
      }
    } else {
      print('Không tìm thấy dữ liệu người dùng');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin người dùng
              _buildUserProfile(context),
              const SizedBox(height: 20),
              // Các lựa chọn menu
              _buildMenuOption(
                context,
                'Thông tin của tôi',
                Icons.account_circle_outlined,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyInfoScreen()),
                  );
                },
              ),

              _buildMenuOption(
                context,
                'Xác thực hai bước',
                Icons.security_outlined,
                () {
                  // Navigator.pushNamed(context, '/two_factor_authentication');
                },
              ),
              _buildMenuOption(
                context,
                'Thay đổi mật khẩu',
                Icons.lock_outline,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen()),
                  );
                },
              ),
              _buildMenuOption(context, 'Đăng xuất', Icons.logout_outlined, () {
                logOut(context);
              }),

              const SizedBox(height: 20),

              // Các lựa chọn khác
              const Text(
                'Thêm',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              _buildMenuOption(
                context,
                'Trợ giúp & Hỗ trợ',
                Icons.help_outline,
                () {
                  // Navigator.pushNamed(context, '/help_support');
                },
              ),
              _buildMenuOption(
                context,
                'Thông tin ứng dụng',
                Icons.info_outline,
                () {
                  // Navigator.pushNamed(context, '/about_app');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị thông tin người dùng
  Widget _buildUserProfile(BuildContext context) {
    return user != null
        ? Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(146, 202, 221, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Avatar người dùng
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.imageURL ?? ''),
                ),
                const SizedBox(width: 16.0),
                // Tên người dùng
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.fullName ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '@${user.fullName ?? ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Icon chỉnh sửa
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfile(user: user)),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  // Widget cho mỗi lựa chọn menu
  Widget _buildMenuOption(BuildContext context, String title, IconData icon,
      VoidCallback onPressed) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onPressed,
    );
  }
}
