import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:recipe_app/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:recipe_app/blocs/recipe_category_bloc/recipe_category_bloc.dart';
import 'package:recipe_app/blocs/recipe_detail_bloc/recipe_detail_bloc.dart';
import 'package:recipe_app/blocs/recipe_search_bloc/recipe_search_bloc.dart';
import 'package:recipe_app/screens/home/dashboard.dart';
import 'package:recipe_app/utils/http_overrides.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  await dotenv.load(fileName: "assets/env/.env_production");

  // Inisial http method untuk Android versi 6 atau kebawah
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecipeBloc>(
          create: (context) => RecipeBloc(),
        ),
        BlocProvider<RecipeDetailBloc>(
          create: (context) => RecipeDetailBloc(),
        ),
        BlocProvider<RecipeCategoryBloc>(
          create: (context) => RecipeCategoryBloc(),
        ),
        BlocProvider<RecipeSearchBloc>(
          create: (context) => RecipeSearchBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Resep Masakan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: GoogleFonts.poppinsTextTheme(
              Theme.of(context).textTheme,
            ),
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                iconTheme: IconThemeData(color: Colors.black),
                actionsIconTheme: IconThemeData(color: Colors.black),
                elevation: 1)),
        home: UpgradeAlert(
            upgrader: Upgrader(
                showIgnore: false,
                showLater: false,
                showReleaseNotes: false,
                canDismissDialog: false),
            child: const Dashboard()),
      ),
    );
  }
}
