import 'package:ebook_reader/service/authen.dart';
import 'package:ebook_reader/service/database_service.dart';
import 'package:ebook_reader/utils/themes/theme.dart';
import 'package:ebook_reader/viewmodels/preview_book_provider.dart';
import 'package:ebook_reader/widget/chapter_book_widget.dart';
import 'package:ebook_reader/widget/pages/chapter_page.dart';
import 'package:ebook_reader/widget/pages/edit_information_user_page.dart';
import 'package:ebook_reader/widget/pages/filter_kind_book_page.dart';
import 'package:ebook_reader/widget/pages/forgot_password_page.dart';
import 'package:ebook_reader/widget/pages/home_page.dart';
import 'package:ebook_reader/widget/pages/listening_page.dart';
import 'package:ebook_reader/widget/pages/preview_page.dart';
import 'package:ebook_reader/widget/pages/profile_page.dart';
import 'package:ebook_reader/widget/pages/reading_page.dart';
import 'package:ebook_reader/widget/pages/saved_book_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ebook_reader/widget/pages/welcome_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email') ?? "";
  var password = prefs.getString('pass') ?? "";
  print("SAve email $email");
  final AuthService _auth = AuthService();
  if(email != ""){
    await _auth.signInWithEmailAndPassword(email, password);
  }
  runApp(MyApp(email));
}

class MyApp extends StatelessWidget {
  final email;
  const MyApp(this.email);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => DatabaseRealTimeService(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PreviewBookProvider(),
        )
      ],
      child: MaterialApp(
          title: 'Ebook-Reader ',
          theme: AppTheme.lightTheme.copyWith(
            textTheme: GoogleFonts.mulishTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home:  email == "" ? WelcomePage() : HomePage(),
          routes:{
            ForgotPassword.routeName: (ctx) => ForgotPassword(),
            HomePage.routeName: (ctx) => HomePage(),
            PreviewPage.routeName: (ctx) => const PreviewPage(),
            ChapterPage.routeName: (ctx) => ChapterPage(),
            ReadingPage.routeName: (ctx) => ReadingPage(),
            ListeningPage.routeName: (ctx) => ListeningPage(),
            KindBookPage.routeName: (ctx) => KindBookPage(),
            ProfilePage.routeName: (ctx) => ProfilePage(),
            EditInformation.routeName: (ctx) => EditInformation(),
            SavedBookPage.routeName: (ctx) => SavedBookPage()
          }
      )
    );
  }
}
