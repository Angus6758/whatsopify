import 'package:seller_management/main.export.dart';

class Dashboard {
  const Dashboard({
    required this.seller,
    required this.overview,
    required this.graphData,
    required this.transactions,
  });

  factory Dashboard.fromMap(Map<String, dynamic> map) {
    return Dashboard(
      overview: Overview.fromMap(map['overview']),
      seller: Seller.fromMap(map['seller']),
      graphData: GraphData.fromMap(map['graph_data']),
      transactions: List<TransactionData>.from(
          map['transaction']['data'].map((x) => TransactionData.fromMap(x))),
    );
  }

  final GraphData graphData;
  final Overview overview;
  final Seller seller;
  final List<TransactionData> transactions;

  Map<String, dynamic> toMap() {
    return {
      'overview': overview.toMap(),
      'seller': seller.toMap(),
      'graph_data': graphData.toMap(),
      'transaction': {
        'data': transactions.map((x) => x.toMap()).toList(),
      }
    };
  }
}
