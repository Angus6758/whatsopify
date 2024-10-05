import 'package:seller_management/main.export.dart';

class CountryState {
  const CountryState({
    required this.id,
    required this.name,
    required this.cities,
  });

  factory CountryState.fromMap(Map<String, dynamic> map) {
    return CountryState(
     id: map.parseInt('id'),
      name: map['name'] as String,
      cities: StateCity.fromList(map['cities']),
    );
  }

  final List<StateCity> cities;
  final int id;
  final String name;

  static List<CountryState> fromList(QMap map) {
    return List<CountryState>.from(
        map['data']?.map((v) => CountryState.fromMap(v)));
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({
      'cities': {'data': cities.map((x) => x.toMap()).toList()},
    });
    return result;
  }
}
