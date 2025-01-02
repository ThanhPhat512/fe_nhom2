class MealsListData {
  MealsListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String>? meals;
  int kacl;

  static List<MealsListData> tabIconsList = <MealsListData>[
    MealsListData(
      imagePath: 'assets/fitness_app/fruit.png',
      titleTxt: 'Trái Cây',
      meals: <String>['Táo,', 'Chuối'],
      startColor: '#FA7D82',
      endColor: '#FFB295',
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/vegetable.png',
      titleTxt: 'Rau Củ',
      kacl: 602,
      meals: <String>['Rau Má,', 'Cải Bẹ'],
      startColor: '#738AE6',
      endColor: '#5C5EDD',
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/water.png',
      titleTxt: 'Đồ Uống',
      kacl: 0,
      meals: <String>['Nước Lọc,', 'Siting'],
      startColor: '#FE95B6',
      endColor: '#FF5287',
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/dinner.png',
      titleTxt: 'Thịt',
      kacl: 0,
      meals: <String>['Thịt Gà', 'Thịt Heo'],
      startColor: '#6F72CA',
      endColor: '#1E1466',
    ),
  ];
}
