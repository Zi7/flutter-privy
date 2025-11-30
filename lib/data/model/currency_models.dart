class Currency {
  final int id;
  final String name;
  final String iconUrl;
  final String currency;
  final String coinGecko;
  final int divisor;
  final String createdAt;
  final String updatedAt;

  Currency({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.currency,
    required this.coinGecko,
    required this.divisor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        iconUrl: json['iconUrl'] ?? '',
        currency: json['currency'] ?? '',
        coinGecko: json['coinGecko'] ?? '',
        divisor: json['divisor'] ?? 0,
        createdAt: json['createdAt'] ?? '',
        updatedAt: json['updatedAt'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconUrl': iconUrl,
        'currency': currency,
        'coinGecko': coinGecko,
        'divisor': divisor,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
