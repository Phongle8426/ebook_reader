import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

class EditInformation extends StatefulWidget {
  static const routeName = '/EditInformation';
  @override
  _EditInformation createState() => _EditInformation();
}

class _EditInformation extends State<EditInformation>{
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = "";
  final nameUser = TextEditingController();
  final email = TextEditingController();

  @override
  void initState() {
    uid = auth.currentUser?.uid ?? "";
    super.initState();
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tên của bạn',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF7643)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Color(0xfff3f3f4),
                        filled: true),
                    controller:  nameUser,),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF7643)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Color(0xfff3f3f4),
                        filled: true),
                    controller:  email,)
                ],
              ),
            )
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