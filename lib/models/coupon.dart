
class Coupon {
  final String id;
  final String brand;
  final String code;
  final String description;
  final String logo;
  final String title;
  final int total_coupon;
  final int total_focus;
  final String createdAt;
  final String updatedAt;

  Coupon({
    this.id,
    this.brand,
    this.createdAt,
    this.updatedAt,
    this.code,
    this.logo,
    this.title,
    this.description,
    this.total_coupon,
    this.total_focus
  });

  factory Coupon.fromMap(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      brand: json['brand'],
      createdAt: json['created_at'],
      updatedAt: json['elapsed_time'],
      code: json['code'],
      logo: json['logo'],
      title: json['title'],
      description: json['description'],
      total_coupon: json['total_coupon'],
      total_focus: json['total_focus'],
    );
  }
}