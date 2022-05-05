import 'package:ebook_reader/service/database_service.dart';
import 'package:ebook_reader/utils/themes/theme.dart';
import 'package:ebook_reader/widget/chapter_book_widget.dart';
import 'package:ebook_reader/widget/pages/chapter_page.dart';
import 'package:ebook_reader/widget/pages/home_page.dart';
import 'package:ebook_reader/widget/pages/preview_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ebook_reader/widget/pages/welcome_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: DatabaseRealTimeService()),
      ],
      child: MaterialApp(
          title: 'Ebook-Reader ',
          theme: AppTheme.lightTheme.copyWith(
            textTheme: GoogleFonts.mulishTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: WelcomePage(),
          routes:{
            HomePage.routeName: (ctx) => HomePage(),
            PreviewPage.routeName: (ctx) => const PreviewPage(),
            ChapterPage.routeName: (ctx) => ChapterPage()
          }
      )
    );
  }
}
