import 'package:ebook_reader/models/book_model.dart';
import 'package:ebook_reader/widget/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../service/database_service.dart';
import '../navigation_drawer.dart';
import '../recent_book_widget.dart';
import '../trending_book_widget.dart';


class HomePage extends StatefulWidget {
  static const routeName = '/HomePage';

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  List<PreviewBook> _recentBooks = [];
  List<PreviewBook> _trendingBooks = [];
  UserInfor user = UserInfor.emtpy();
  String userName = "";
  bool loading = true;
  bool isOpenSearchBox = false;
  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid  = auth.currentUser?.uid;
    _getInforUser(uid!);
    _getRecentBooks();
    _getTrendingBooks();
    super.initState();
  }

  _getRecentBooks() async {
    List<PreviewBook> lisst = await Provider.of<DatabaseRealTimeService>(context, listen: false).getAllBook();
     setState(() {
       _recentBooks = lisst;
     });
  }

  _getTrendingBooks() async {
    List<PreviewBook> lisst = await Provider.of<DatabaseRealTimeService>(context, listen: false).getAllBook();
    setState(() {
      _trendingBooks = lisst;
      loading = false;
    });
  }
  void _getInforUser(String uid) async{
    UserInfor userInfor = await Provider.of<DatabaseRealTimeService>(context, listen: false).getInforUser(uid);
    setState(() {
      user = userInfor;
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<DatabaseRealTimeService>(context);
    final userName = database.nameUser;
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
                      isOpenSearchBox ? searchBox() : Text('Ebook Reader',
                          style: GoogleFonts.portLligatSans(
                            textStyle: Theme.of(context).textTheme.headline1,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          )
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          print("Thai chay ne");
                          setState(() {
                            isOpenSearchBox = !isOpenSearchBox;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: loading ? Loading() : Container(
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
                                userName,
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
                          Text('Top truyện đọc nhiều',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TrendingBook(_trendingBooks)
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

  Widget searchBox(){
    final nameUser = TextEditingController();
    return Container(
      width: 200,
      height: 40,
      child: TextField(
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xfffbb448), width: 2.0),
                borderRadius: BorderRadius.circular(15)),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xfffbb448), width: 2.0),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Color(0xfff3f3f4),
            filled: true),
        controller:  nameUser,),
    );
  }
}