import 'package:ebook_reader/widget/pages/filter_kind_book_page.dart';
import 'package:ebook_reader/widget/pages/home_page.dart';
import 'package:ebook_reader/widget/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 3);
  @override
  Widget build(BuildContext context) {
    final name = 'Thái Phan';
    final email = 'thaiphan@gmail.com';
    final urlImage =
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80';

    return Drawer(
      child: Material(
        color: Color.fromRGBO(220, 167, 56, 1.0),
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () => {
                Navigator.of(context).pushNamed(ProfilePage.routeName)
              },
            ),
            Container(
              padding: padding,
              height: 500,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    buildMenuItem(
                      text: 'Trang chủ',
                      icon: Icons.home,
                      onClicked: () =>  Navigator.of(context).pushNamed(HomePage.routeName),
                    ),
                    buildMenuItem(
                      text: 'Sách đã lưu',
                      icon: Icons.bookmark_added_rounded,
                      onClicked: () => selectedItem(context, 0, ''),
                    ),
                    buildMenuItem(
                      text: 'Kiếm Hiệp',
                      icon: Icons.star_border,
                      onClicked: () => selectedItem(context, 1,'Kiếm Hiệp' ),
                    ),
                    buildMenuItem(
                      text: 'Tình cảm',
                      icon: Icons.star_border,
                      onClicked: () => selectedItem(context, 1,'Tình cảm'),
                    ),
                    buildMenuItem(
                      text: 'Hành động',
                      icon: Icons.star_border,
                      onClicked: () => selectedItem(context, 1,'Hành động'),
                    ),
                    buildMenuItem(
                      text: 'Trinh thám',
                      icon: Icons.star_border,
                      onClicked: () => selectedItem(context, 1,'Trinh thám'),
                    ),
                    buildMenuItem(
                      text: 'Pháp Thuật',
                      icon: Icons.star_border,
                      onClicked: () => selectedItem(context, 1, 'Cổ tích'),
                    ),
                    buildMenuItem(
                      text: 'Cổ tích',
                      icon: Icons.star_border,
                      onClicked: () => selectedItem(context, 1, 'Cổ tích'),
                    ),
                    buildMenuItem(
                      text: 'Tiểu Thuyết',
                      icon: Icons.star_border,
                      onClicked: () => selectedItem(context, 1, 'Cổ tích'),
                    ),
                    buildMenuItem(
                      text: 'Truyện thơ',
                      icon: Icons.star_border,
                      onClicked: () => selectedItem(context, 1, 'Cổ tích'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      );


  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context,int index, String type) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => PeoplePage(),
        // ));
        break;
      case 1:
        Navigator.of(context).pushNamed(
          KindBookPage.routeName,
          arguments: type,
        );
        break;
    }
  }
}