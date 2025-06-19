class Article {
  String description;
  int quantity;
  double priceHT;

  Article({
    this.description = '',
    this.quantity = 0,
    this.priceHT = 0.0,
  });

  double get totalHT => quantity * priceHT;
}
