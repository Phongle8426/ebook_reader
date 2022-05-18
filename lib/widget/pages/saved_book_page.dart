import 'package:ebook_reader/models/book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/database_service.dart';
import '../navigation_drawer.dart';
import '../trending_book_widget.dart';


class SavedBookPage extends StatefulWidget {
  static const routeName = '/SavedBookPage';

  @override
  _SavedBookPage createState() => _SavedBookPage();
}

class _SavedBookPage extends State<SavedBookPage>{
  List<PreviewBook> _books = [];
  String? typeBook = '';
  String? uid ='';
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
      FirebaseAuth auth = FirebaseAuth.instance;
      uid  = auth.currentUser?.uid;
      _getSavedBook(uid!);
    });
  }

  _getSavedBook(String uid) async {
    List<PreviewBook> lisst = await DatabaseRealTimeService().getAllFavouriteBook(uid);
    setState(() {
      _books = lisst;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      body: Builder(
          builder: (context) {
            return Container(
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
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xfffbb448), Color(0xffe46b10)])),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 40,
                      bottom: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 35,
                          ),
                          onPressed: (){
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        Text('Ebook Reader',
                            style: GoogleFonts.portLligatSans(
                              textStyle: Theme.of(context).textTheme.headline1,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 35,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 20,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xfffff8ee),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Sách đã lưu",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 15,
                                bottom: 15,
                              ),
                              width: 180,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(0xffc44536),
                              ),
                            ),
                            TrendingBook(_books)
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}