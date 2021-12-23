import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/repositories/recipe_repository.dart';
import 'package:recipe_app/screens/recipes/recipe_category_result.dart';

class RecipeCategory extends StatefulWidget {
  const RecipeCategory({Key? key}) : super(key: key);

  @override
  _RecipeCategoryState createState() => _RecipeCategoryState();
}

class _RecipeCategoryState extends State<RecipeCategory> {
  RecipeRepository recipeRepo = RecipeRepository();

  List<RecipeCategoryModel> listRecipeCategory = [];

  Future getRecipeCategory() async {
    try {
      List<RecipeCategoryModel>? data = await recipeRepo.getRecipeCategory();
      if (data != null) {
        listRecipeCategory = data;
        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      listRecipeCategory = [];
    });
    getRecipeCategory();
  }

  @override
  void initState() {
    getRecipeCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Masakan'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.orangeAccent.shade700,
        displacement: 20,
        onRefresh: () => _refresh(),
        child: listRecipeCategory.isNotEmpty
            ? ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RecipeCategoryResult(
                          recipeCategory: listRecipeCategory[index],
                        );
                      }));
                    },
                    leading: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.orange),
                        child:
                            const Icon(Icons.restaurant, color: Colors.white)),
                    title: Text(listRecipeCategory[index].category ?? ''),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                  );
                },
                itemCount: listRecipeCategory.length)
            : Center(
                child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                    color: Colors.orange.shade600, strokeWidth: 3),
              )),
      ),
    );
  }
}
