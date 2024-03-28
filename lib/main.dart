

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:v_card/models/contact_model.dart';
import 'package:v_card/pages/contacts_details_page.dart';
import 'package:v_card/pages/formpage.dart';
import 'package:v_card/pages/homePage.dart';
import 'package:v_card/pages/scan_page.dart';
import 'package:v_card/provider/contact_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ContactProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerConfig: _router,
      builder: EasyLoading.init(),
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
          useMaterial3: true),
    );
  }

  final _router = GoRouter(
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
          name: HomePage.routeName,
          path: HomePage.routeName,
          builder: (context, state) => HomePage(),
          routes: [
            GoRoute(
              name: ContactDetailsPage.routename,
              path: ContactDetailsPage.routename,
              builder: (context, state) => ContactDetailsPage(id: state.extra! as int),
            ),
            GoRoute(
                name: ScanPage.routeName,
                path: ScanPage.routeName,
                builder: (context, state) => ScanPage(),
                routes: [
                  GoRoute(
                    name: FormPage.routeName,
                    path: FormPage.routeName,
                    builder: (context, state) => FormPage(
                      contactModel: state.extra! as ContactModel,
                    ),
                  )
                ]),
          ]),
    ],
  );
}
