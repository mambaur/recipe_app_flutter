import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe_model.dart';

class RecipeRepository {
  final _baseUrl = dotenv.env['API_MAIN'].toString();

  Future<List<RecipeModel>?> getRecipes({int page = 1}) async {
    try {
      final response = await http.get(Uri.parse(_baseUrl + '/recipes?$page'));

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
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

  Future<RecipeModel?> getRecipeDetail(int id) async {
    try {
      final response = await http.get(Uri.parse(_baseUrl + '/recipe/$id'));
      // print(response.body);

      if (response.statusCode == 200) {
        return RecipeModel.fromJson(json.decode(response.body)['data']);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<List<RecipeCategoryModel>?> getRecipeCategory() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl + '/categories'));
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
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
      {int page = 1, int? id}) async {
    try {
      final response = await http.get(
          Uri.parse(_baseUrl + '/recipes?page=$page&categories[]=${id ?? ''}'));
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
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
          await http.get(Uri.parse(_baseUrl + '/recipes?q=$keyword'));
      // print(response.body);

      if (response.statusCode == 200) {
        Iterable iterable = json.decode(response.body)['data'];
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
