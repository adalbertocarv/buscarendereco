class BusLine {
  int sequencial;
  String numero;
  String descricao;
  String sentido;
  FaixaTarifaria faixaTarifaria;

  BusLine({required this.sequencial, required this.numero, required this.descricao, required this.sentido, required this.faixaTarifaria});

  factory BusLine.fromJson(Map<String, dynamic> json) {
    return BusLine(
      sequencial: json['sequencial'],
      numero: json['numero'],
      descricao: json['descricao'],
      sentido: json['sentido'],
      faixaTarifaria: FaixaTarifaria.fromJson(json['faixaTarifaria']),
    );
  }
}

class FaixaTarifaria {
  int sequencial;
  String descricao;
  double tarifa;

  FaixaTarifaria({required this.sequencial, required this.descricao, required this.tarifa});

  factory FaixaTarifaria.fromJson(Map<String, dynamic> json) {
    return FaixaTarifaria(
      sequencial: json['sequencial'],
      descricao: json['descricao'],
      tarifa: json['tarifa'],
    );
  }
}
