import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/repositories/recipe_repository.dart';

part 'recipe_category_event.dart';
part 'recipe_category_state.dart';

class RecipeCategoryBloc
    extends Bloc<RecipeCategoryEvent, RecipeCategoryState> {
  final RecipeRepository _recipeRepo = RecipeRepository();
  List<RecipeModel> listRecipes = [];

  RecipeCategoryBloc() : super(RecipeCategoryInitial()) {
    on<GetRecipeByCategory>(_getRecipesByCategory);
  }

  Future _getRecipesByCategory(
      GetRecipeByCategory event, Emitter<RecipeCategoryState> emit) async {
    try {
      emit(GetRecipeByCategoryLoading());
      List<RecipeModel>? data =
          await _recipeRepo.getListRecipesbyCategory(page: 1, key: event.key);
      if (data != null) {
        listRecipes = data;
        emit(RecipeByCategoryData(listRecipes, true));
      } else {
        emit(RecipeByCategoryError('Resep masakan tidak ditemukan'));
      }
    } catch (e) {
      emit(RecipeByCategoryError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
