import 'package:ebook_reader/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/book_data.dart';
import '../../service/database_service.dart';
import '../recent_book_widget.dart';
import '../trending_book_widget.dart';


class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  List<PreviewBook> _recentBooks = [];
  @override
  void initState() {
    super.initState();
    _getRecentBooks();
  }

  _getRecentBooks() async {
    List<PreviewBook> lisst = await DatabaseRealTimeService().getAllBook();
     setState(() {
       print("boook $lisst");
       _recentBooks = lisst;
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    onPressed: (){},
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
                            "Chào bạn đọc,",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 3,),
                          Text(
                            "Thái Phan",
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
                      RecentBook(_recentBooks),
                      TrendingBook(recentBooks)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}