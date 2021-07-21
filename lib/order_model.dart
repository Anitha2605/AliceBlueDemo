class OrderModel {
  String? status;
  String? message;
  Data? data;

  OrderModel({this.status, this.message, this.data});

  OrderModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['Data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  String? orderId;
  String? userId;
  String? schemeCode;
  String? orderAmount;
  String? orderDate;

  Data(
      {this.orderId,
      this.userId,
      this.schemeCode,
      this.orderAmount,
      this.orderDate});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    userId = json['userId'];
    schemeCode = json['schemeCode'];
    orderAmount = json['orderAmount'];
    orderDate = json['orderDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['userId'] = this.userId;
    data['schemeCode'] = this.schemeCode;
    data['orderAmount'] = this.orderAmount;
    data['orderDate'] = this.orderDate;
    return data;
  }
}
