import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:recipe_app/blocs/recipe_bloc/recipe_bloc.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/repositories/recipe_repository.dart';
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
  final RecipeRepository _recipeRepo = RecipeRepository();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late RecipeBloc recipeBloc;
  final ScrollController _scrollController = ScrollController();
  String version = '';
  final String _urlGooglePlay =
      'https://play.google.com/store/apps/details?id=com.caraguna.recipe_apps';
  final String _recipeWebUrl = 'https://masakin.caraguna.com';
  final String _otherAppsUrl =
      'https://play.google.com/store/apps/dev?id=8918426189046119136&hl=en';

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
    if (!await launchUrl(Uri.parse(_url),
        mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $_url';
    }
  }

  final List<String> imgList = [
    'https://masakin.caraguna.com/storage/recipe_images/zEdB44aKqERJHWogplgbvxOxmv7jWirRBI6ELi21.jpg',
    'https://masakin.caraguna.com/storage/recipe_images/Su6BvbLaX4u4KqGeLmx8x2MqCGMSMlR4yVsOUS61.jpg',
    'https://masakin.caraguna.com/storage/recipe_images/SoTT0ZdG4DJ7iwp6OvX1SzEwmm0tvVGzs1Qow4Me.jpg'
  ];

  final CarouselController _controller = CarouselController();

  late Future<List<RecipeModel>?> topBookmarks;
  late Future<List<RecipeModel>?> topViews;

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

    topBookmarks = _recipeRepo.getTopBookmarkRecipes();
    topViews = _recipeRepo.getTopViewRecipes();
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
                ListTile(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                      _launchUrl(_recipeWebUrl);
                    },
                    title: const Text("Bagikan Resepmu")),
                ListTile(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                      _launchUrl(_otherAppsUrl);
                    },
                    title: const Text("Aplikasi Lainnya")),
                ListTile(onTap: () {}, title: Text("Versi $version")),
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
                child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                        FutureBuilder<List<RecipeModel>?>(
                            future: topBookmarks,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  width: MediaQuery.of(context).size.width,
                                  child: CarouselSlider(
                                    items: snapshot.data!
                                        .map((item) => GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return RecipeDetail(
                                                    recipeModel: item,
                                                  );
                                                }));
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(5.0),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        CachedNetworkImage(
                                                            imageUrl:
                                                                item.coverImage ??
                                                                    '',
                                                            fit: BoxFit.cover,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width),
                                                        Positioned(
                                                          bottom: 0.0,
                                                          left: 0.0,
                                                          right: 0.0,
                                                          child: Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Color
                                                                      .fromARGB(
                                                                          200,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  Color
                                                                      .fromARGB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          0)
                                                                ],
                                                                begin: Alignment
                                                                    .bottomCenter,
                                                                end: Alignment
                                                                    .topCenter,
                                                              ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10.0,
                                                                    horizontal:
                                                                        20.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  item.title ??
                                                                      '',
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 8.0),
                                                                  child: Wrap(
                                                                    crossAxisAlignment:
                                                                        WrapCrossAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            25,
                                                                        height:
                                                                            25,
                                                                        child:
                                                                            ClipOval(
                                                                          child:
                                                                              CachedNetworkImage(
                                                                            imageUrl:
                                                                                item.user?.photo ?? '',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                          item.user?.name ??
                                                                              '',
                                                                          style:
                                                                              const TextStyle(color: Colors.white))
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ))
                                        .toList(),
                                    carouselController: _controller,
                                    options: CarouselOptions(
                                      autoPlay: true,
                                      enlargeCenterPage: true,
                                      aspectRatio: 2,
                                      // onPageChanged: (index, reason) {
                                      //   setState(() {
                                      //     _current = index;
                                      //   });
                                      // }
                                    ),
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                      ])),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Resep Populer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        FutureBuilder<List<RecipeModel>?>(
                            future: topViews,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return RecipeDetail(
                                              recipeModel:
                                                  snapshot.data![index],
                                            );
                                          }));
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          margin: const EdgeInsets.only(
                                              right: 15, top: 10, bottom: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 3,
                                                  offset: const Offset(0,
                                                      1), // changes position of shadow
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          height: 100,
                                          child: Row(children: [
                                            SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(5),
                                                        bottomLeft:
                                                            Radius.circular(5)),
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl: snapshot
                                                          .data![index]
                                                          .coverImage ??
                                                      '',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    snapshot.data![index]
                                                            .title ??
                                                        '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8.5),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: 25,
                                                          height: 25,
                                                          child: ClipOval(
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: snapshot
                                                                      .data![
                                                                          index]
                                                                      .user
                                                                      ?.photo ??
                                                                  '',
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                              snapshot
                                                                      .data?[
                                                                          index]
                                                                      .user
                                                                      ?.name ??
                                                                  '',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ]),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            })
                      ])),
                      SliverList(
                          delegate: SliverChildListDelegate([
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 15, left: 10, right: 10),
                          child: Text(
                            'Semua Resep',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        BlocBuilder<RecipeBloc, RecipeState>(
                          builder: (context, state) {
                            if (state is RecipeData) {
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(10),
                                itemCount: state.hasReachMax
                                    ? state.listRecipes.length
                                    : state.listRecipes.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < state.listRecipes.length) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return RecipeDetail(
                                            recipeModel:
                                                state.listRecipes[index],
                                          );
                                        }));
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Card(
                                          child: Wrap(
                                            children: [
                                              SizedBox(
                                                width: size.width,
                                                height: size.height * 0.3,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          topRight:
                                                              Radius.circular(
                                                                  5)),
                                                  child:
                                                      CustomCachedImage.build(
                                                          context,
                                                          imgUrl: state
                                                              .listRecipes[
                                                                  index]
                                                              .coverImage),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .timer_outlined,
                                                            size: 20,
                                                            color: Colors.orange
                                                                .shade700),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                            state
                                                                    .listRecipes[
                                                                        index]
                                                                    .timeCooking ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12)),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                            Icons
                                                                .ramen_dining_outlined,
                                                            size: 20,
                                                            color: Colors.orange
                                                                .shade700),
                                                        const SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                            state
                                                                    .listRecipes[
                                                                        index]
                                                                    .portion ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12)),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      state.listRecipes[index]
                                                                  .title !=
                                                              null
                                                          ? state
                                                              .listRecipes[
                                                                  index]
                                                              .title!
                                                          : TextFormat
                                                              .slugToTitle(state
                                                                      .listRecipes[
                                                                          index]
                                                                      .slug ??
                                                                  ''),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      state.listRecipes[index]
                                                              .description ??
                                                          '',
                                                      style: const TextStyle(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 25,
                                                            height: 25,
                                                            child: ClipOval(
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: state
                                                                        .listRecipes[
                                                                            index]
                                                                        .user
                                                                        ?.photo ??
                                                                    '',
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(state
                                                                  .listRecipes[
                                                                      index]
                                                                  .user
                                                                  ?.name ??
                                                              '')
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
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
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Container();
                                },
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                    child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                      color: Colors.orange.shade600,
                                      strokeWidth: 3),
                                )),
                              );
                            }
                          },
                        )
                      ])),
                      SliverList(delegate: SliverChildListDelegate([])),
                    ]),
              ),
              Positioned(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: statusAd == StatusAd.loaded
                          ? Container(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
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
