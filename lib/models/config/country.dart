import 'package:seller_management/main.export.dart';

class Country {
  const Country({
    required this.id,
    required this.name,
    required this.code,
    required this.states,
  });

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
     id: map.parseInt('id'),
      name: map['name'] as String,
      code: map['code'] as String,
      states: CountryState.fromList(map['states']),
    );
  }

  final String code;
  final int id;
  final String name;
  final List<CountryState> states;

  static List<Country> fromList(QMap map) {
    return List<Country>.from(map['data']?.map((c) => Country.fromMap(c)));
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'code': code});
    result.addAll({
      'states': {'data': states.map((x) => x.toMap()).toList()},
    });
    return result;
  }
}
