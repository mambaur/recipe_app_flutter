import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/repositories/recipe_repository.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository _recipeRepo = RecipeRepository();
  List<RecipeModel> listRecipes = [];
  int page = 1;

  RecipeBloc() : super(RecipeInitial()) {
    on<GetRecipe>(_getRecipes);
  }

  Future _getRecipes(GetRecipe event, Emitter<RecipeState> emit) async {
    try {
      if (event.isInit) {
        page = 1;
        emit(GetRecipeLoading());
        List<RecipeModel>? data = await _recipeRepo.getRecipes(page: page);
        if (data != null) {
          listRecipes = data;
          data.length < event.limit
              ? emit(RecipeData(listRecipes, true))
              : emit(RecipeData(listRecipes, false));
        } else {
          emit(RecipeData(listRecipes, false));
        }
      } else {
        page++;
        List<RecipeModel>? data = await _recipeRepo.getRecipes(page: page);
        if (data != null) {
          listRecipes.addAll(data);
          data.length < event.limit
              ? emit(RecipeData(listRecipes, true))
              : emit(RecipeData(listRecipes, false));
        } else {
          emit(RecipeData(listRecipes, false));
        }
      }
    } catch (e) {
      emit(RecipeError('Terjadi kesalahan, silahkan coba kembali'));
    }
  }
}
