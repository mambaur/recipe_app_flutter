import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:readmore/readmore.dart';
import 'package:recipe_app/blocs/recipe_detail_bloc/recipe_detail_bloc.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/utils/custom_cached_image.dart';
import 'package:recipe_app/utils/image_viewer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum StatusAd { initial, loaded }

class RecipeDetail extends StatefulWidget {
  final RecipeModel recipeModel;
  const RecipeDetail({Key? key, required this.recipeModel}) : super(key: key);

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  final PanelController _panelController = PanelController();
  late RecipeDetailBloc recipeDetailBloc;

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

  String removeFirstWord(String word) {
    List<String> listWord = word.split(' ');
    listWord.removeAt(0);
    return listWord.join(" ");
  }

  Widget stepWidget(List<String> steps) {
    List<Widget> children = [];
    for (var i = 0; i < steps.length; i++) {
      children.add(ListTile(
        leading: Container(
          width: 30,
          height: 30,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
          child: Center(
            child: Text(
              (i + 1).toString(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(removeFirstWord(steps[i])),
      ));
    }
    return Column(
      children: children,
    );
  }

  @override
  void initState() {
    recipeDetailBloc = BlocProvider.of<RecipeDetailBloc>(context);
    recipeDetailBloc.add(GetRecipeDetail(widget.recipeModel.key!));
    myBanner = BannerAd(
      // test banner
      // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      //
      adUnitId: 'ca-app-pub-2465007971338713/4428371035',
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
    return Scaffold(
      body: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
        builder: (context, state) {
          if (state is RecipeDetailData) {
            return SlidingUpPanel(
              controller: _panelController,
              minHeight: size.height * 0.5,
              maxHeight: size.height,
              boxShadow: const [
                BoxShadow(blurRadius: 8.0, color: Color.fromRGBO(0, 0, 0, 0.1))
              ],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              panelBuilder: (controller) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: SingleChildScrollView(
                        controller: controller,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.recipeModel.title ?? '',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.account_circle_rounded,
                                      color: Colors.grey.shade400),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(state.recipeModel.user ?? '',
                                      style: TextStyle(
                                          color: Colors.grey.shade400)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.date_range,
                                      color: Colors.grey.shade400),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(state.recipeModel.datePublished ?? '',
                                      style: TextStyle(
                                          color: Colors.grey.shade400)),
                                ],
                              ),
                            ),
                            ReadMoreText(
                              state.recipeModel.desc ?? '',
                              trimLines: 5,
                              style: const TextStyle(color: Colors.black),
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Lihat Selengkapnya',
                              trimExpandedText: 'Sembunyikan',
                              delimiter: '\n',
                              lessStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                              moreStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 0.5,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timer_outlined,
                                    color: Colors.orange.shade700),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(state.recipeModel.times ?? '',
                                    style:
                                        const TextStyle(color: Colors.black)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.contact_support_outlined,
                                    color: Colors.orange.shade700),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(state.recipeModel.dificulty ?? '',
                                    style:
                                        const TextStyle(color: Colors.black)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.ramen_dining_outlined,
                                    color: Colors.orange.shade700),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(state.recipeModel.servings ?? '',
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 0.5,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Bahan",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            for (String ingredient
                                in state.recipeModel.ingredients ?? [])
                              Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    const Icon(Icons.radio_button_unchecked),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(ingredient),
                                    )
                                  ],
                                ),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 0.5,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text("Langkah - langkah",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 10,
                            ),
                            stepWidget(state.recipeModel.steps ?? []),
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: statusAd == StatusAd.loaded
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      alignment: Alignment.center,
                                      child: AdWidget(ad: myBanner!),
                                      width: myBanner!.size.width.toDouble(),
                                      height: myBanner!.size.height.toDouble(),
                                    )
                                  : Container(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 7,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              body: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ImageViewer(
                            imageURL: state.recipeModel.thumb ??
                                widget.recipeModel.thumb!);
                      }));
                    },
                    child: Container(
                      color: Colors.grey.shade300,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: size.width,
                          height: size.height * 0.55,
                          child: CustomCachedImage.build(context,
                              imgUrl: state.recipeModel.thumb ??
                                  widget.recipeModel.thumb),
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Detail Resep",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
    );
  }
}
