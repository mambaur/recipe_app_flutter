import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipe_category_bloc/recipe_category_bloc.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/screens/recipes/recipe_detail.dart';
import 'package:recipe_app/utils/custom_cached_image.dart';

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

  @override
  void initState() {
    recipeCategoryBloc = BlocProvider.of<RecipeCategoryBloc>(context);
    recipeCategoryBloc
        .add(GetRecipeByCategory(10, true, widget.recipeCategory.key ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipeCategory.category ?? '',
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.orangeAccent.shade700,
        displacement: 20,
        onRefresh: () => _refresh(),
        child: BlocBuilder<RecipeCategoryBloc, RecipeCategoryState>(
          builder: (context, state) {
            if (state is RecipeByCategoryData) {
              return ListView.builder(
                  itemCount: state.listRecipes.length,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.listRecipes[index].title ?? ''),
                      subtitle: Wrap(
                        children: [
                          const Icon(Icons.timer, size: 14, color: Colors.grey),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(state.listRecipes[index].times ?? '',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(Icons.contact_support,
                              size: 14, color: Colors.grey),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(state.listRecipes[index].dificulty ?? '',
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(Icons.ramen_dining,
                              size: 14, color: Colors.grey),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(state.listRecipes[index].portion ?? '',
                              style: const TextStyle(fontSize: 14)),
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
      ),
    );
  }
}
