enum Category {
  manufacturing,
  customizedDesignWork,
  electricalWork,
  homemadeFood,
  interiorDesign,
  garments
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.manufacturing:
        return 'Manufacturing';
      case Category.customizedDesignWork:
        return 'Customized Work';
      case Category.electricalWork:
        return 'Electrical Work';
      case Category.homemadeFood:
        return 'Homemade Food';
      case Category.interiorDesign:
        return 'Interior Design';
      case Category.garments:
        return 'Garments';
    }
  }

  static List<Category> getCategories() {
    return [
      Category.manufacturing,
      Category.customizedDesignWork,
      Category.electricalWork,
      Category.homemadeFood,
      Category.interiorDesign,
      Category.garments
    ];
  }

  static Category fromString(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'manufacturing':
        return Category.manufacturing;
      case 'customized work':
        return Category.customizedDesignWork;
      case 'electrical work':
        return Category.electricalWork;
      case 'homemade food':
        return Category.homemadeFood;
      case 'interior design':
        return Category.interiorDesign;
      case 'garments':
        return Category.garments;
      default:
        throw ArgumentError('Invalid category name');
    }
  }
}