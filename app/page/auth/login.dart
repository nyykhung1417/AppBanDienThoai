import 'package:flutter/material.dart';
import 'package:lab8_9_10/app/data/sharepre.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lab8_9_10/app/data/api.dart';
import 'package:lab8_9_10/mainpage.dart';
import '../register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      String accountID = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      try {
        String token = await APIRepository().login(accountID, password);

        if (token.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', token);
          prefs.setString('accountID', accountID);

          // Lưu thông tin người dùng vào SharedPreferences
          var user = await APIRepository().current(token);
          saveUser(user); // Gọi hàm lưu thông tin người dùng

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Mainpage()),
          );
        } else {
          _showErrorDialog(
              'Tài khoản hoặc mật khẩu không đúng. Vui lòng thử lại.');
        }
      } catch (e) {
        print('Login error: $e');
        _showErrorDialog('Đăng nhập thất bại. Vui lòng đăng nhập lại.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Đăng nhập thất bại',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A1B9A), // Màu tím
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Màu cyan
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromRGBO(0, 255, 255, 1).withOpacity(0.5),
                  Colors.transparent,
                ],
                radius: 1.0,
                center: Alignment.center,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/logoapp.png',
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image),
                    width: 200,
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "PL MOBILE",
                    style: TextStyle(
                      fontSize: 34,
                      color: Colors.cyan, // Màu cyan
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 70),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 249, 249, 249),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person, color: Colors.black),
                              labelText: 'Tài khoản',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập tài khoản của bạn';
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode
                                .onUserInteraction, // Thêm dòng này để validate khi người dùng tương tác
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255)
                                .withOpacity(0.8),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              icon: Icon(Icons.lock, color: Colors.black),
                              labelText: 'Mật khẩu',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập mật khẩu của bạn';
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode
                                .onUserInteraction, // Thêm dòng này để validate khi người dùng tương tác
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(150, 50),
                            backgroundColor: Colors.cyan, // Màu cyan
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 24.0),
                            child: Text(
                              "Đăng nhập",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Bạn chưa có tài khoản? ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Text(
                                "Đăng ký ngay",
                                style: TextStyle(
                                  color: Colors.cyan, // Màu cyan
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
