import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:recipe_app/blocs/recipe_category_bloc/recipe_category_bloc.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/screens/recipes/recipe_detail.dart';
import 'package:recipe_app/utils/custom_cached_image.dart';
import 'package:recipe_app/utils/text_format.dart';

class RecipeCategoryResult extends StatefulWidget {
  final RecipeCategoryModel recipeCategory;
  const RecipeCategoryResult({Key? key, required this.recipeCategory})
      : super(key: key);

  @override
  _RecipeCategoryResultState createState() => _RecipeCategoryResultState();
}

class _RecipeCategoryResultState extends State<RecipeCategoryResult> {
  late RecipeCategoryBloc recipeCategoryBloc;

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    recipeCategoryBloc
        .add(GetRecipeByCategory(10, true, widget.recipeCategory.key ?? ''));
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
    recipeCategoryBloc = BlocProvider.of<RecipeCategoryBloc>(context);
    recipeCategoryBloc
        .add(GetRecipeByCategory(10, true, widget.recipeCategory.key ?? ''));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipeCategory.category ?? '',
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.orangeAccent.shade700,
        displacement: 20,
        onRefresh: () => _refresh(),
        child: Stack(
          children: [
            BlocBuilder<RecipeCategoryBloc, RecipeCategoryState>(
              builder: (context, state) {
                if (state is RecipeByCategoryData) {
                  return ListView.builder(
                      itemCount: state.listRecipes.length,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            state.listRecipes[index].title != null
                                ? state.listRecipes[index].title!
                                : TextFormat.slugToTitle(
                                    state.listRecipes[index].key ?? ''),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(Icons.timer,
                                  size: 14, color: Colors.grey.shade400),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(state.listRecipes[index].times ?? '',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade400)),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.contact_support,
                                  size: 14, color: Colors.grey.shade400),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(state.listRecipes[index].dificulty ?? '',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade400)),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.ramen_dining,
                                  size: 14, color: Colors.grey.shade400),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(state.listRecipes[index].portion ?? '',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade400)),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RecipeDetail(
                                recipeModel: state.listRecipes[index],
                              );
                            }));
                          },
                          leading: SizedBox(
                              width: 70,
                              height: 70,
                              child: CustomCachedImage.build(context,
                                  imgUrl: state.listRecipes[index].thumb ?? '',
                                  borderRadius: BorderRadius.circular(10))),
                        );
                      });
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
        ),
      ),
    );
  }
}
