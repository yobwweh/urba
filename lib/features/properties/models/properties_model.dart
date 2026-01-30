class PropertyModel {
  final String id;
  final String name;
  final double price;
  final double incomePerSecond;
  bool isOwned;
  int quantity;
  int level;

  PropertyModel({
    required this.id,
    required this.name,
    required this.price,
    required this.incomePerSecond,
    this.isOwned = false,
    this.quantity = 0,
    this.level = 0,
  });

  // Convertit l'objet en JSON pour la sauvegarde
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'incomePerSecond': incomePerSecond,
    'isOwned': isOwned,
    'quantity': quantity,
    'level': level,
  };

  // Crée un objet à partir d'un JSON chargé
  factory PropertyModel.fromJson(Map<String, dynamic> json) => PropertyModel(
    id: json['id'],
    name: json['name'],
    price: json['price'].toDouble(),
    incomePerSecond: json['incomePerSecond'].toDouble(),
    isOwned: json['isOwned'],
    quantity: json['quantity'],
    level: json['level'],
  );
}