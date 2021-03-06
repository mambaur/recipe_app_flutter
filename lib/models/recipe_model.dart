class RecipeModel {
  String? title,
      thumb,
      servings,
      serving,
      times,
      dificulty,
      difficulty,
      user,
      datePublished,
      portion,
      key,
      desc;
  List<String>? ingredients, steps;

  RecipeModel(
      {this.title,
      this.servings,
      this.serving,
      this.times,
      this.thumb,
      this.dificulty,
      this.difficulty,
      this.user,
      this.datePublished,
      this.desc,
      this.portion,
      this.key,
      this.ingredients,
      this.steps});

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      key: json['key'],
      title: json['title'],
      servings: json['servings'],
      serving: json['serving'],
      times: json['times'],
      thumb: json['thumb'],
      dificulty: json['dificulty'],
      difficulty: json['difficulty'],
      portion: json['portion'],
      desc: json['desc'],
      user: json['author'] != null ? json['author']['user'] : null,
      datePublished:
          json['author'] != null ? json['author']['datePublished'] : null,
      steps: json["step"] != null ? List<String>.from(json["step"]) : null,
      ingredients: json["ingredient"] != null
          ? List<String>.from(json["ingredient"])
          : null,
    );
  }
}

class RecipeCategoryModel {
  String? key, url, category;

  RecipeCategoryModel({
    this.key,
    this.url,
    this.category,
  });

  factory RecipeCategoryModel.fromJson(Map<String, dynamic> json) {
    return RecipeCategoryModel(
      key: json['key'],
      url: json['url'],
      category: json['category'],
    );
  }
}
