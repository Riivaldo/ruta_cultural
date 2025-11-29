// lib/models/departamento.dart
class Departamento {
  final String id;
  final String nombre;
  final String imagenAsset;
  final List<Festividad> festividades;

  Departamento({
    required this.id,
    required this.nombre,
    required this.imagenAsset,
    required this.festividades,
  });
}

class Festividad {
  final String id;
  final String nombre;
  final String mes; // mes en minúsculas
  final String tipo; // "religioso", "folclore", "gastronómico", "feria", "cultural", etc.

  Festividad({
    required this.id,
    required this.nombre,
    required this.mes,
    required this.tipo,
  });
}

/// Datos de ejemplo — revisa/ajusta según necesites
List<Departamento> departamentosEjemplo = [
  Departamento(
    id: 'lp',
    nombre: 'La Paz',
    imagenAsset: 'assets/images/lapaz.jpg',
    festividades: [
      Festividad(id: 'lp1', nombre: 'Feria de Alasitas', mes: 'enero', tipo: 'folclore'),
      Festividad(id: 'lp2', nombre: 'Gran Poder', mes: 'mayo', tipo: 'folclore'),
      Festividad(id: 'lp3', nombre: 'Anata (Carnaval Andino)', mes: 'febrero', tipo: 'folclore'),
      Festividad(id: 'lp4', nombre: 'Todos Santos', mes: 'noviembre', tipo: 'religioso'),
      Festividad(id: 'lp5', nombre: 'Fiesta de la Virgen de Copacabana (evento asociado)', mes: 'agosto', tipo: 'religioso'),
    ],
  ),

  Departamento(
    id: 'cb',
    nombre: 'Cochabamba',
    imagenAsset: 'assets/images/cochabamba.jpg',
    festividades: [
      Festividad(id: 'cb1', nombre: 'Carnaval de Cochabamba', mes: 'febrero', tipo: 'folclore'),
      Festividad(id: 'cb2', nombre: 'Fiesta de la Virgen de Urkupiña (Quillacollo)', mes: 'agosto', tipo: 'religioso'),
      Festividad(id: 'cb3', nombre: 'Semana Santa', mes: 'marzo', tipo: 'religioso'),
      Festividad(id: 'cb4', nombre: 'Fiesta del Señor del Gran Poder (actos locales)', mes: 'mayo', tipo: 'religioso/folclore'),
      Festividad(id: 'cb5', nombre: 'Fiesta de la Virgen de Chiquinquirá (actos locales)', mes: 'julio', tipo: 'religioso'),
    ],
  ),

  Departamento(
    id: 'sc',
    nombre: 'Santa Cruz',
    imagenAsset: 'assets/images/santacruz.jpg',
    festividades: [
      Festividad(id: 'sc1', nombre: 'Carnaval cruceño', mes: 'febrero', tipo: 'folclore'),
      Festividad(id: 'sc2', nombre: 'Fexpocruz (Feria Exposición)', mes: 'septiembre', tipo: 'feria'),
      Festividad(id: 'sc3', nombre: 'Fiesta de la Cruz', mes: 'mayo', tipo: 'religioso'),
      Festividad(id: 'sc4', nombre: 'Festival Gastronómico Regional', mes: 'septiembre', tipo: 'gastronómico'),
      Festividad(id: 'sc5', nombre: 'Fiesta de la Virgen de Cotoca (celebraciones regionales)', mes: 'may-octubre', tipo: 'religioso'),
    ],
  ),

  Departamento(
    id: 'or',
    nombre: 'Oruro',
    imagenAsset: 'assets/images/oruro.jpg',
    festividades: [
      Festividad(id: 'or1', nombre: 'Carnaval de Oruro', mes: 'febrero', tipo: 'folclore'),
      Festividad(id: 'or2', nombre: 'Virgen del Socavón (actividades principales del carnaval)', mes: 'febrero', tipo: 'religioso/folclore'),
      Festividad(id: 'or3', nombre: 'Semana Santa', mes: 'marzo', tipo: 'religioso'),
      Festividad(id: 'or4', nombre: 'Fiesta del Carnaval Andino', mes: 'febrero', tipo: 'folclore'),
    ],
  ),

  Departamento(
    id: 'pt',
    nombre: 'Potosí',
    imagenAsset: 'assets/images/potosi.jpg',
    festividades: [
      Festividad(id: 'pt1', nombre: 'Carnaval potosino', mes: 'febrero', tipo: 'folclore'),
      Festividad(id: 'pt2', nombre: 'Fiesta de la Virgen de Guadalupe (celebraciones locales)', mes: 'septiembre', tipo: 'religioso'),
      Festividad(id: 'pt3', nombre: 'Semana Santa', mes: 'marzo', tipo: 'religioso'),
      Festividad(id: 'pt4', nombre: 'Festividades mineras y aniversarios de Potosí (actos culturales)', mes: 'mayo', tipo: 'cultural'),
    ],
  ),

  Departamento(
    id: 'tj',
    nombre: 'Tarija',
    imagenAsset: 'assets/images/tarija.jpg',
    festividades: [
      Festividad(id: 'tj1', nombre: 'Vendimia (Fiesta de la Vendimia y del Vino)', mes: 'marzo', tipo: 'gastronómico/feria'),
      Festividad(id: 'tj2', nombre: 'Carnaval tarijeño', mes: 'febrero', tipo: 'folclore'),
      Festividad(id: 'tj3', nombre: 'Fiestas patronales locales', mes: 'septiembre', tipo: 'religioso/cultural'),
      Festividad(id: 'tj4', nombre: 'Festival de la Cosecha y Tradiciones', mes: 'abril', tipo: 'cultural'),
    ],
  ),

  Departamento(
    id: 'ch',
    nombre: 'Chuquisaca (Sucre)',
    imagenAsset: 'assets/images/chuquisaca.jpg',
    festividades: [
      Festividad(id: 'ch1', nombre: 'Aniversario de Sucre (fiestas cívicas y culturales)', mes: 'mayo', tipo: 'cultural'),
      Festividad(id: 'ch2', nombre: 'Semana Santa (procesiones y actividades religiosas)', mes: 'marzo', tipo: 'religioso'),
      Festividad(id: 'ch3', nombre: 'Fiestas patronales y actos universitarios', mes: 'varios', tipo: 'cultural'),
      Festividad(id: 'ch4', nombre: 'Festival de música y danza tradicional', mes: 'agosto', tipo: 'folclore'),
    ],
  ),

  Departamento(
    id: 'bn',
    nombre: 'Beni',
    imagenAsset: 'assets/images/beni.jpg',
    festividades: [
      Festividad(id: 'bn1', nombre: 'Carnaval de Trinidad', mes: 'febrero', tipo: 'folclore'),
      Festividad(id: 'bn2', nombre: 'Fiesta de San Ignacio y celebraciones misioneras', mes: 'julio', tipo: 'religioso/cultural'),
      Festividad(id: 'bn3', nombre: 'Festividad de la Amazonía y ferias regionales', mes: 'agosto', tipo: 'feria/cultural'),
      Festividad(id: 'bn4', nombre: 'Festival de la Chiquitanía (eventos culturales)', mes: 'septiembre', tipo: 'cultural'),
    ],
  ),

  Departamento(
    id: 'pd',
    nombre: 'Pando',
    imagenAsset: 'assets/images/pando.jpg',
    festividades: [
      Festividad(id: 'pd1', nombre: 'Feria de la Castaña', mes: 'agosto', tipo: 'gastronómico/feria'),
      Festividad(id: 'pd2', nombre: 'Fiestas regionales de la Amazonía', mes: 'julio', tipo: 'cultural'),
      Festividad(id: 'pd3', nombre: 'Celebraciones por la diversidad cultural y feria artesanal', mes: 'septiembre', tipo: 'cultural/feria'),
    ],
  ),
];
