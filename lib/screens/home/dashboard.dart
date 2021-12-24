import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:recipe_app/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:recipe_app/screens/about/about_screen.dart';
import 'package:recipe_app/screens/recipes/recipe_category.dart';
import 'package:recipe_app/screens/recipes/recipe_detail.dart';
import 'package:recipe_app/screens/search/search_recipe.dart';
import 'package:recipe_app/utils/custom_cached_image.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late RecipeBloc recipeBloc;
  final ScrollController _scrollController = ScrollController();
  // AppUpdateInfo? _updateInfo;
  String version = '';

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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        // _updateInfo = info;
      });
    }).catchError((e) {
      if (kDebugMode) {
        print(e.toString());
      }
    });
  }

  Future getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    setState(() {});
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-2465007971338713/3844478337',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  loadAds() async {
    await myBanner.load();
    setState(() {});
  }

  @override
  void initState() {
    recipeBloc = BlocProvider.of<RecipeBloc>(context);
    recipeBloc.add(GetRecipe(10, true));
    checkForUpdate();
    getPackageInfo();
    loadAds();

    _scrollController.addListener(onScroll);
    super.initState();
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
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.timer, size: 20),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                  state.listRecipes[index]
                                                          .times ??
                                                      '',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Icon(Icons.contact_support,
                                                  size: 20),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Text(
                                                  state.listRecipes[index]
                                                          .dificulty ??
                                                      '',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Icon(Icons.ramen_dining,
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
                                            state.listRecipes[index].title ??
                                                '',
                                            style:
                                                const TextStyle(fontSize: 16),
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
                          // if (index == 3 || index % 6 == 0) {
                          //   return Positioned(
                          //       child: Align(
                          //     alignment: Alignment.bottomCenter,
                          //     child: Container(
                          //       width: size.width,
                          //       height: size.height * 0.3,
                          //       child: AdWidget(ad: myBanner),
                          //       // width: myBanner.size.width.toDouble(),
                          //       // height: myBanner.size.height.toDouble(),
                          //     ),
                          //   ));
                          // } else {
                          //   return Container();
                          // }
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
                child: Container(
                  child: AdWidget(ad: myBanner),
                  width: myBanner.size.width.toDouble(),
                  height: myBanner.size.height.toDouble(),
                ),
              ))
            ],
          )),
    );
  }
}
