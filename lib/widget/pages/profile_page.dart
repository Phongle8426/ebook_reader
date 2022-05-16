import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../profile_item.dart';
import 'edit_information_user_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/ProfilePage';
  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>{
  void _logout(BuildContext context, VoidCallback press) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Xác nhận'),
            content: const Text('Bạn muốn thoát khỏi ứng dụng ?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {press;},
                  child: const Text('Thoát')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Ở lại'))
            ],
          );
        });
  }
@override
  Widget build(BuildContext context) {
  var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color.fromRGBO(249, 191, 161, 1), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.center
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
                  height: size.height * 0.085,
                  width: size.width,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Material(
                            color: Colors.white.withOpacity(0),
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: BorderRadius.circular(
                                  constraints.maxHeight * 0.4),
                              splashColor: Colors.white,
                              child: Container(
                                padding:
                                EdgeInsets.all(constraints.maxHeight * 0.18),
                                //color: Colors.black,
                                height: constraints.maxHeight * 0.8,
                                width: constraints.maxWidth * 0.15,
                                child: FittedBox(
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 115,
                  width: 115,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Thái Phan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                ProfileMenu(
                  text: "Tài khoản",
                  icon: Icons.person_rounded,
                  press: () => {
                  Navigator.of(context).pushNamed(EditInformation.routeName)
                  },
                ),
                ProfileMenu(
                  text: "Đăng xuất",
                  icon: Icons.logout,
                  press: () {
                    _logout(context,_signOut);
                  },
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
void _signOut() {
  FirebaseAuth.instance.signOut();
  runApp(
      new MaterialApp(
        home: new LoginPage(),
      )

  );
}
}