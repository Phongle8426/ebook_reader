import 'package:ebook_reader/widget/pages/forgot_password_page.dart';
import 'package:flutter/material.dart';
import 'package:ebook_reader/service/authen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loading_widget_2.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  String error = '';
  late String email;
  late String password;
  bool isRemember = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  bool _passwordVisible = false;

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Trở lại',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: false,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            controller: emailController,
              validator: (value){
                if(value == null || value.isEmpty){
                  return 'Yêu cầu nhập!';
                }
                return null;
              }
          )
        ],
      ),
    );
  }

  Widget _entryPasswordField(String title) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: !_passwordVisible,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                  _passwordVisible
                  ? Icons.visibility : Icons.visibility_off,
                color: Color(0xFFFF7643),
              ),
              onPressed: (){
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            )),
            controller: passwordController,
              validator:  (value){
                if(value == null || value.isEmpty){
                  return 'Yêu cầu nhập!';
                }
                return null;
              }
          )
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Đăng nhập',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onTap: () async {
        setState(() {
          loading = true;
        });
        email = emailController.text;
        password = passwordController.text;
        dynamic result =
            await _auth.signInWithEmailAndPassword(email, password);
        if (result == null) {
          setState(() {
            error = 'Email hoặc mật khẩu không chính xác !';
            loading = false;
          });
        } else {
          if(isRemember){
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', email);
            prefs.setString('pass', password);
          }
          Navigator.of(context).pushNamed(HomePage.routeName);
        }
      },
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email"),
        _entryPasswordField("Mật khẩu"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return loading
        ? Loading2()
        : Scaffold(
            body: Container(
            height: height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .2),
                        Text('Ebook Reader',
                            style: GoogleFonts.portLligatSans(
                              textStyle: Theme.of(context).textTheme.headline1,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.deepOrange,
                            )),
                        SizedBox(height: 50),
                        _emailPasswordWidget(),
                        SizedBox(height: 20),
                        _submitButton(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    value: isRemember,
                                    activeColor: Colors.orange,
                                    onChanged: (newValue) {
                                      setState(() {
                                        isRemember = newValue!;
                                      });
                                    }),
                                Text('Nhớ mật khẩu',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  child: Text('Quên mật khẩu ?',
                                  style: TextStyle(
                                    color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              onPressed: (){
                                Navigator.of(context).pushNamed(ForgotPassword.routeName);
                              },),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(top: 40, left: 0, child: _backButton()),
              ],
            ),
          ));
  }
}
