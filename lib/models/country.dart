class Country {
  final int id;
  final String name;
  final String country_code;

  Country({required this.id, required this.name,required this.country_code});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['country_id'],
      name: json['country_name'],
      country_code: json['country_code']
    );
  }
}