class Estudiante {
  final String id;
  final String nombre;
  final String email;
  final String programa;
  final DateTime createdAt;

  Estudiante({
    required this.id,
    required this.nombre,
    required this.email,
    required this.programa,
    required this.createdAt,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      programa: json['programa'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'programa': programa,
    };
  }
}