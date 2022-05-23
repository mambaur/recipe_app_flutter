import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:recipe_app/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:recipe_app/screens/about/about_screen.dart';
import 'package:recipe_app/screens/recipes/recipe_category.dart';
import 'package:recipe_app/screens/recipes/recipe_detail.dart';
import 'package:recipe_app/screens/search/search_recipe.dart';
import 'package:recipe_app/utils/custom_cached_image.dart';
import 'package:recipe_app/utils/text_format.dart';
import 'package:url_launcher/url_launcher.dart';

enum StatusAd { initial, loaded }

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late RecipeBloc recipeBloc;
  final ScrollController _scrollController = ScrollController();
  String version = '';
  final String _urlGooglePlay =
      'https://play.google.com/store/apps/details?id=com.caraguna.recipe_apps';

  /// Set default hasReachMax value false
  /// Variabel ini digunakan untuk menangani agaer scrollController tidak-
  /// Berlangsung terus menerus.
  bool _hasReachMax = false;

  void onScroll() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;

    if (currentScroll == maxScroll && !_hasReachMax) {
      recipeBloc.add(GetRecipe(10, false));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    recipeBloc.add(GetRecipe(10, true));
  }

  Future getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {});
  }

  void _launchUrl(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
  }

  BannerAd? myBanner;

  StatusAd statusAd = StatusAd.initial;

  BannerAdListener listener() => BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          if (kDebugMode) {
            print('Ad Loaded.');
          }
          setState(() {
            statusAd = StatusAd.loaded;
          });
        },
      );

  @override
  void initState() {
    recipeBloc = BlocProvider.of<RecipeBloc>(context);
    recipeBloc.add(GetRecipe(10, true));
    getPackageInfo();

    _scrollController.addListener(onScroll);
    myBanner = BannerAd(
      // test banner
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      //
      adUnitId: 'ca-app-pub-2465007971338713/3844478337',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: listener(),
    );
    myBanner!.load();
    super.initState();
  }

  @override
  void dispose() {
    myBanner!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<RecipeBloc, RecipeState>(
      listener: (context, state) {
        if (state is RecipeData) {
          _hasReachMax = state.hasReachMax;
        }
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: SizedBox(
                width: 80, child: Image.asset('assets/images/icon_recipe.png')),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SearchRecipe();
                    }));
                  },
                  icon: const Icon(Icons.search))
            ],
            leading: IconButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.menu)),
            centerTitle: true,
          ),
          backgroundColor: Colors.white,
          drawer: Drawer(
            child: SafeArea(
              child: ListView(padding: EdgeInsets.zero, children: [
                DrawerHeader(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          "Resep Masakan Indo",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          "Coba rasakan nikmatnya",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  decoration: const BoxDecoration(color: Colors.orange),
                ),
                ListTile(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const RecipeCategory();
                      }));
                    },
                    title: const Text("Kategori")),
                ListTile(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AboutScreen();
                      }));
                    },
                    title: const Text("Tentang Aplikasi")),
                ListTile(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                      _launchUrl(_urlGooglePlay);
                    },
                    title: const Text("Cek Update")),
                ListTile(onTap: () {}, title: Text(version)),
              ]),
            ),
          ),
          body: Stack(
            children: [
              RefreshIndicator(
                backgroundColor: Colors.white,
                color: Colors.orangeAccent.shade700,
                displacement: 20,
                onRefresh: () => _refresh(),
                child: BlocBuilder<RecipeBloc, RecipeState>(
                  builder: (context, state) {
                    if (state is RecipeData) {
                      return ListView.separated(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: state.hasReachMax
                            ? state.listRecipes.length
                            : state.listRecipes.length + 1,
                        itemBuilder: (context, index) {
                          if (index < state.listRecipes.length) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return RecipeDetail(
                                    recipeModel: state.listRecipes[index],
                                  );
                                }));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Wrap(
                                  children: [
                                    SizedBox(
                                      width: size.width,
                                      height: size.height * 0.3,
                                      child: CustomCachedImage.build(context,
                                          imgUrl:
                                              state.listRecipes[index].thumb),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.timer_outlined,
                                                  size: 20),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                  state.listRecipes[index]
                                                          .times ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Icon(
                                                  Icons
                                                      .contact_support_outlined,
                                                  size: 20),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                  state.listRecipes[index]
                                                          .dificulty ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Icon(
                                                  Icons.ramen_dining_outlined,
                                                  size: 20),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                  state.listRecipes[index]
                                                          .portion ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 12)),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            state.listRecipes[index].title !=
                                                    null
                                                ? state
                                                    .listRecipes[index].title!
                                                : TextFormat.slugToTitle(state
                                                        .listRecipes[index]
                                                        .key ??
                                                    ''),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                    color: Colors.orange.shade600,
                                    strokeWidth: 2),
                              ),
                            );
                          }
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container();
                        },
                      );
                    } else {
                      return Center(
                          child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                            color: Colors.orange.shade600, strokeWidth: 3),
                      ));
                    }
                  },
                ),
              ),
              Positioned(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: statusAd == StatusAd.loaded
                          ? Container(
                              margin:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                              alignment: Alignment.center,
                              child: AdWidget(ad: myBanner!),
                              width: myBanner!.size.width.toDouble(),
                              height: myBanner!.size.height.toDouble(),
                            )
                          : Container()))
            ],
          )),
    );
  }
}
