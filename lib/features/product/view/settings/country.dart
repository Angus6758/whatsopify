
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';

class Country {
  const Country({
    required this.id,
    required this.name,
    required this.code,
    required this.states,
  });

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
     id: map.parseInt('id')?? 56,
      name: map['name'] as String,
      code: map['code'] as String,
      states: CountryState.fromList(map['states']),
    );
  }

  final String code;
  final int id;
  final String name;
  final List<CountryState> states;

  static List<Country> fromList(Map<String, dynamic> map) {
    return List<Country>.from(map['data']?.map((x) => Country.fromMap(x)));
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

  static List<CountryState> fromList(Map<String, dynamic> map) {
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

class StateCity {
  const StateCity({
    required this.id,
    required this.name,
    required this.shippingFees,
  });

  factory StateCity.fromMap(Map<String, dynamic> map) {
    return StateCity(
     id: map.parseInt('id'),
      name: map['name'] as String,
      shippingFees: map.parseNum('shipping_fees'),
    );
  }

  final int id;
  final String name;
  final num shippingFees;

  static List<StateCity> fromList(Map<String, dynamic> map) {
    return List<StateCity>.from(map['data']?.map((x) => StateCity.fromMap(x)));
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'shipping_fees': shippingFees};
  }
}
