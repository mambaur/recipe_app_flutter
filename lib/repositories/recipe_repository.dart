import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe_model.dart';

class RecipeRepository {
  final _baseUrl = dotenv.env['API_MAIN'].toString();

  Future<List<RecipeModel>?> getRecipes({int page = 1}) async {
    try {
      final response =
          await http.get(Uri.parse(_baseUrl + '/recipes/?page=$page'));
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['results'];
        List<RecipeModel> listRecipe =
            iterable.map((e) => RecipeModel.fromJson(e)).toList();
        return listRecipe;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<RecipeModel?> getRecipeDetail(String key) async {
    try {
      final response = await http.get(Uri.parse(_baseUrl + '/recipe/$key'));
      print(response.body);

      if (response.statusCode == 200) {
        return RecipeModel.fromJson(json.decode(response.body)['results']);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<RecipeCategoryModel>?> getRecipeCategory() async {
    try {
      final response =
          await http.get(Uri.parse(_baseUrl + '/categorys/recipes'));
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['results'];
        List<RecipeCategoryModel> listRecipeCategory =
            iterable.map((e) => RecipeCategoryModel.fromJson(e)).toList();
        return listRecipeCategory;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<RecipeModel>?> getListRecipesbyCategory(
      {int page = 1, String? key}) async {
    try {
      final response =
          await http.get(Uri.parse(_baseUrl + '/recipes/$key?page=$page'));
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['results'];
        List<RecipeModel> listRecipe =
            iterable.map((e) => RecipeModel.fromJson(e)).toList();
        return listRecipe;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<RecipeModel>?> getSearchRecipes({String? keyword}) async {
    try {
      final response =
          await http.get(Uri.parse(_baseUrl + '/search/?q=$keyword'));
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['results'];
        List<RecipeModel> listRecipe =
            iterable.map((e) => RecipeModel.fromJson(e)).toList();
        return listRecipe;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
