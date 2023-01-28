import 'package:recipe_app/models/user_model.dart';

class RecipeModel {
  int? id;
  String? slug,
      title,
      description,
      coverImage,
      portion,
      timeCooking,
      youtubeUrl,
      createdAt,
      updatedAt;
  List<String>? images, steps;
  RecipeCategoryModel? category;
  RecipeTypeModel? type;
  UserModel? user;
  List<RecipeIngredientModel>? ingredients;

  RecipeModel(
      {this.id,
      this.slug,
      this.title,
      this.description,
      this.coverImage,
      this.portion,
      this.timeCooking,
      this.youtubeUrl,
      this.createdAt,
      this.updatedAt,
      this.category,
      this.type,
      this.ingredients,
      this.images,
      this.user,
      this.steps});

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      coverImage: json['cover_image'],
      portion: json['portion'],
      timeCooking: json['time_cooking'],
      youtubeUrl: json['youtube_url'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      category: json['category'] != null
          ? RecipeCategoryModel.fromJson(json['category'])
          : null,
      type:
          json['type'] != null ? RecipeTypeModel.fromJson(json['type']) : null,
      ingredients: json['ingredients'] != null
          ? List<RecipeIngredientModel>.from(
              json['ingredients'].map((e) => RecipeIngredientModel.fromJson(e)))
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      steps: json["steps"] != null ? List<String>.from(json["steps"]) : null,
      images: json["images"] != null ? List<String>.from(json["images"]) : null,
    );
  }
}

class RecipeCategoryModel {
  int? id;
  String? name, description;

  RecipeCategoryModel({this.id, this.name, this.description});

  factory RecipeCategoryModel.fromJson(Map<String, dynamic> json) {
    return RecipeCategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class RecipeTypeModel {
  int? id;
  String? name, description;

  RecipeTypeModel({this.id, this.name, this.description});

  factory RecipeTypeModel.fromJson(Map<String, dynamic> json) {
    return RecipeTypeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class RecipeIngredientModel {
  String? key;
  List<String>? ingredients;

  RecipeIngredientModel({this.key, this.ingredients});

  factory RecipeIngredientModel.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientModel(
      key: json['key'],
      ingredients: json["ingredients"] != null
          ? List<String>.from(json["ingredients"])
          : null,
    );
  }
}
