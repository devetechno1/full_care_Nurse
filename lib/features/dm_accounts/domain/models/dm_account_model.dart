import 'dart:convert';

class DmAccountPage {
  final List<DmAccountItem> items;
  final int totalSize;
  final int offset;

  DmAccountPage({
    required this.items,
    required this.totalSize,
    required this.offset,
  });

  factory DmAccountPage.fromJson(dynamic json) {
    if (json is String) json = jsonDecode(json);

    final List dataList = (json['transactions'] ?? []) as List;
    final int total = (json['total_size'] ?? dataList.length) as int;
    final int off = (json['offset'] ?? 1) as int;

    return DmAccountPage(
      items: dataList.map((e) => DmAccountItem.fromJson(e)).toList(),
      totalSize: total,
      offset: off,
    );
  }
}

class DmAccountItem {
  final int? id;
  final String? inOut;            // "in" | "out"
  final String? target;           // "wallet" | "debt" | null
  final String? payMethod;        // "cash_on_delivery" | "digital_payment" | "vc" | ...
  final String? orderPayType;     // قد تكون null
  final int? orderId;             // قد تكون null
  final double? orderTotal;       // قد تكون null
  final double? value;            // المبلغ الأساسي
  final double? debt;             // مديونية الحركة
  final String? date;             // raw
  final String? dateFormatted;    // localized string

  DmAccountItem({
    this.id,
    this.inOut,
    this.target,
    this.payMethod,
    this.orderPayType,
    this.orderId,
    this.orderTotal,
    this.value,
    this.debt,
    this.date,
    this.dateFormatted,
  });

  factory DmAccountItem.fromJson(Map<String, dynamic> json) {
    double? _d(v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    int? _i(v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    return DmAccountItem(
      id: _i(json['id']),
      inOut: json['in_out']?.toString(),
      target: json['target']?.toString(),
      payMethod: json['pay_method']?.toString(),
      orderPayType: json['order_pay_type']?.toString(),
      orderId: _i(json['order_id']),
      orderTotal: _d(json['order_total']),
      value: _d(json['value']),
      debt: _d(json['debt']),
      date: json['date']?.toString(),
      dateFormatted: json['date_formatted']?.toString(),
    );
  }
}
