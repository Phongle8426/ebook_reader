import 'package:ebook_reader/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/book_data.dart';
import '../../service/database_service.dart';
import '../navigation_drawer.dart';
import '../recent_book_widget.dart';
import '../trending_book_widget.dart';


class KindBookPage extends StatefulWidget {
  static const routeName = '/KindBookPage';

  @override
  _KindBookPage createState() => _KindBookPage();
}

class _KindBookPage extends State<KindBookPage>{
  List<PreviewBook> _books = [];
  String? typeBook = '';
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() {
      print("Chay ne 123");
      typeBook = ModalRoute.of(context)?.settings.arguments.toString();
      _getBookByType(typeBook!);
    });
  }

  _getBookByType(String type) async {
    List<PreviewBook> lisst = await DatabaseRealTimeService().getBookByType(type);
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
                                  "Thể loại : ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 3,),
                                Text( typeBook ?? '',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
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