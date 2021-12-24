part of 'recipe_category_bloc.dart';

@immutable
abstract class RecipeCategoryEvent {}

class GetRecipeByCategory extends RecipeCategoryEvent {
  final String key;
  final int limit;
  final bool isInit;
  GetRecipeByCategory(this.limit, this.isInit, this.key);
}
