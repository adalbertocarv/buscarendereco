class Address {
  final double lat;
  final double lon;
  final String displayName;

  Address({required this.lat, required this.lon, required this.displayName});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      lat: double.parse(json['lat']),
      lon: double.parse(json['lon']),
      displayName: json['display_name'],
    );
  }
}
