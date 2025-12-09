import '../area_protegida.dart';

class FakeApi {
  static List<AreaProtegida> obtenerAreas() {
    return [
      AreaProtegida(
        id: 1,
        nombre: "Parque Nacional del Este",
        tipo: "II - Parque Nacional",
        lat: 18.3340,
        lng: -68.8080,
        descripcion:
            "Uno de los parques nacionales más importantes del país, hogar de una gran biodiversidad terrestre y marina.",
      ),
      AreaProtegida(
        id: 2,
        nombre: "Parque Nacional Valle Nuevo",
        tipo: "II - Parque Nacional",
        lat: 18.7611,
        lng: -70.6168,
        descripcion:
            "Conocido como ‘La Nevera del Caribe’, es un área protegida de clima frío ubicada en la cordillera Central.",
      ),
      AreaProtegida(
        id: 3,
        nombre: "Monumento Natural Laguna Redonda",
        tipo: "III - Monumento Natural",
        lat: 19.6333,
        lng: -69.9000,
        descripcion:
            "Laguna costera de alto valor ecológico rodeada de manglares y especies endémicas.",
      ),
      AreaProtegida(
        id: 4,
        nombre: "Reserva Natural Ébano Verde",
        tipo: "V - Reserva Natural",
        lat: 18.7597,
        lng: -70.5152,
        descripcion:
            "Área de conservación donde se protege el famoso árbol ébano verde y una rica flora endémica.",
      ),
      AreaProtegida(
        id: 5,
        nombre: "Paisaje Protegido Río Yuna",
        tipo: "VI - Paisaje Protegido",
        lat: 19.2000,
        lng: -70.3833,
        descripcion:
            "Una de las áreas de humedales más grandes del país con gran importancia para aves migratorias.",
      ),
    ];
  }
}
