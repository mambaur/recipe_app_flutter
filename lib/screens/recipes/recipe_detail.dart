import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:recipe_app/blocs/recipe_detail_bloc/recipe_detail_bloc.dart';
import 'package:recipe_app/utils/custom_cached_image.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RecipeDetail extends StatefulWidget {
  final String keyRecipe;
  const RecipeDetail({Key? key, required this.keyRecipe}) : super(key: key);

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  final PanelController _panelController = PanelController();
  late RecipeDetailBloc recipeDetailBloc;

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
        title: Text(steps[i]),
      ));
    }
    return Column(
      children: children,
    );
  }

  @override
  void initState() {
    recipeDetailBloc = BlocProvider.of<RecipeDetailBloc>(context);
    recipeDetailBloc.add(GetRecipeDetail(widget.keyRecipe));
    super.initState();
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
                                  const Icon(Icons.account_circle_rounded,
                                      color: Colors.grey),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(state.recipeModel.user ?? '',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(Icons.date_range,
                                      color: Colors.grey),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(state.recipeModel.datePublished ?? '',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            ReadMoreText(
                              state.recipeModel.desc ?? '',
                              trimLines: 5,
                              style: const TextStyle(color: Colors.black),
                              // colorClickableText: Colors.pink,
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
                                const Icon(Icons.timer, color: Colors.orange),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(state.recipeModel.times ?? '',
                                    style:
                                        const TextStyle(color: Colors.black)),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.contact_support,
                                    color: Colors.orange),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(state.recipeModel.dificulty ?? '',
                                    style:
                                        const TextStyle(color: Colors.black)),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.ramen_dining,
                                    color: Colors.orange),
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
                  Container(
                    color: Colors.grey.shade300,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: size.width,
                        height: size.height * 0.55,
                        child: CustomCachedImage.build(context,
                            imgUrl: state.recipeModel.thumb),
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
                        const Text(
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
