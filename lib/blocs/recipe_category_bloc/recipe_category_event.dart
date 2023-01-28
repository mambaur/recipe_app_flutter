part of 'recipe_category_bloc.dart';

@immutable
abstract class RecipeCategoryEvent {}

class GetRecipeByCategory extends RecipeCategoryEvent {
  final int limit, id;
  final bool isInit;
  GetRecipeByCategory(this.limit, this.isInit, this.id);
}
