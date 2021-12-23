import 'package:flutter/material.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/utils/custom_cached_image.dart';

class RecipeCategoryResult extends StatefulWidget {
  final RecipeCategoryModel recipeCategory;
  const RecipeCategoryResult({Key? key, required this.recipeCategory})
      : super(key: key);

  @override
  _RecipeCategoryResultState createState() => _RecipeCategoryResultState();
}

class _RecipeCategoryResultState extends State<RecipeCategoryResult> {
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    // print('Refresing...');
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
        child: ListView.builder(
            itemCount: 10,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              return ListTile(
                title: const Text(
                    'Masakan padang rendang nasi goreng mak nyus pokoke joged'),
                subtitle: Wrap(
                  children: const [
                    Icon(Icons.timer, size: 14, color: Colors.grey),
                    SizedBox(
                      width: 3,
                    ),
                    Text('2 Jam', style: TextStyle(fontSize: 14)),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.contact_support, size: 14, color: Colors.grey),
                    SizedBox(
                      width: 3,
                    ),
                    Text('Cukup Rumit', style: TextStyle(fontSize: 14)),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.ramen_dining, size: 14, color: Colors.grey),
                    SizedBox(
                      width: 3,
                    ),
                    Text('5 Porsi', style: TextStyle(fontSize: 14)),
                  ],
                ),
                onTap: () {},
                leading: SizedBox(
                    width: 70,
                    height: 70,
                    child: CustomCachedImage.build(context,
                        imgUrl:
                            'https://www.masakapahariini.com/wp-content/uploads/2020/11/pangsit-goreng-ayam-disajikan-400x240.jpg',
                        borderRadius: BorderRadius.circular(10))),
              );
            }),
      ),
    );
  }
}
