import 'package:latlong2/latlong.dart';

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
  final String mes;
  final String tipo;
  final String? descripcion;
  // para imagenes
  final String? fecha;
  final List<String> imagenes;
  final LatLng? coordenada;

  Festividad({
    required this.id,
    required this.nombre,
    required this.mes,
    required this.tipo,
    this.descripcion,
    this.fecha,
    this.imagenes = const [],
    this.coordenada,
  });
}

List<Departamento> departamentosEjemplo = [
  Departamento(
    id: 'lp',
    nombre: 'La Paz',
    imagenAsset: 'assets/images/lapaz.jpg',
    festividades: [
      Festividad(
        id: 'lp1',
        nombre: 'Feria de Alasitas',
        mes: 'enero',
        tipo: 'Feria',
        descripcion:
            'La Feria de la Alasita es una feria anual tradicional de miniaturas artesanales con la finalidad ritual de que las mismas se conviertan en realidad. La deidad aimara Ekeko, dios de la abundancia, es considerada la deidad de la feria.​',
        fecha: '2025-01-24',
        imagenes: [
          'assets/images/festividades/lp1_1.jpg',
          'assets/images/festividades/lp1_2.jpg',
          'assets/images/festividades/lp1_3.jpg',
        ],
        coordenada: null,
      ),
      Festividad(
        id: 'lp2',
        nombre: 'Gran Poder',
        mes: 'mayo',
        tipo: 'folklore',
        descripcion: 'La Fiesta de Jesús del Gran Poder o La Fiesta de la Santísima Trinidad del Señor Jesús del Gran Poder en la Ciudad de La Paz es una fiesta religiosa que se celebra en la ciudad de Nuestra Señora de La Paz, Bolivia.',
        imagenes: [
          'assets/images/festividades/lp2_1.jpg',
          'assets/images/festividades/lp2_2.jpg',
        ],
      ),
    ],
  ),

  Departamento(
    id: 'cb',
    nombre: 'Cochabamba',
    imagenAsset: 'assets/images/cochabamba.jpg',
    festividades: [
      Festividad(
        id: 'cb1',
        nombre: 'Carnaval de Cochabamba',
        mes: 'febrero',
        tipo: 'folklore',
        descripcion: 'El carnaval de Cochabamba tiene el llamado "Corso de corsos" en el que se muestra la cultura boliviana y extranjera el cual inicia con un desfile de comparsas a lo largo del Prado de Cochabamba. al que también le siguen El corso en la zona sud el cual pasa por la av.',
        fecha: null,
        imagenes: [
          'assets/images/festividades/cb1_1.jpg',
          'assets/images/festividades/cb1_2.jpg',
        ],
      ),
      Festividad(
        id: 'cb2',
        nombre: 'Fiesta de la Virgen de Urkupiña (Quillacollo)',
        mes: 'agosto',
        tipo: 'religioso',
        descripcion:
            'Peregrinación y festejos en honor a la Virgen de Urkupiña.',
        fecha: null,
        imagenes: ['assets/images/festividades/cb2_1.jpg'],
      ),
      Festividad(
        id: 'cb3',
        nombre: 'Semana Santa',
        mes: 'marzo',
        tipo: 'religioso',
        descripcion: 'Procesiones y ceremonias religiosas de la Semana Santa.',
        fecha: null,
        imagenes: ['assets/images/festividades/cb3_1.jpg'],
      ),
      Festividad(
        id: 'cb4',
        nombre: 'Fiesta del Señor del Gran Poder (actos locales)',
        mes: 'mayo',
        tipo: 'religioso/folklore',
        descripcion: 'Celebraciones locales ligadas a la devoción y folclore.',
        fecha: null,
        imagenes: ['assets/images/festividades/cb4_1.jpg'],
      ),
      Festividad(
        id: 'cb5',
        nombre: 'Fiesta de la Virgen de Chiquinquirá (actos locales)',
        mes: 'julio',
        tipo: 'religioso',
        descripcion: 'Actos locales y procesiones en honor a la Virgen.',
        fecha: null,
        imagenes: ['assets/images/festividades/cb5_1.jpg'],
      ),
    ],
  ),

  Departamento(
    id: 'sc',
    nombre: 'Santa Cruz',
    imagenAsset: 'assets/images/santacruz.jpg',
    festividades: [
      Festividad(
        id: 'sc1',
        nombre: 'Carnaval cruceño',
        mes: 'febrero',
        tipo: 'folklore',
        descripcion: 'Carnaval tradicional con música y comparsas cruceñas.',
        fecha: null,
        imagenes: ['assets/images/festividades/sc1_1.jpg'],
      ),
      Festividad(
        id: 'sc2',
        nombre: 'Fexpocruz (Feria Exposición)',
        mes: 'septiembre',
        tipo: 'feria',
        descripcion: 'Feria comercial y cultural de gran escala.',
        fecha: null,
        imagenes: ['assets/images/festividades/sc2_1.jpg'],
      ),
      Festividad(
        id: 'sc3',
        nombre: 'Fiesta de la Cruz',
        mes: 'mayo',
        tipo: 'religioso',
        descripcion: 'Celebraciones religiosas locales.',
        fecha: null,
        imagenes: ['assets/images/festividades/sc3_1.jpg'],
      ),
      Festividad(
        id: 'sc4',
        nombre: 'Festival Gastronómico Regional',
        mes: 'septiembre',
        tipo: 'gastronómico',
        descripcion: 'Evento gastronómico con platos típicos de la región.',
        fecha: null,
        imagenes: ['assets/images/festividades/sc4_1.jpg'],
      ),
      Festividad(
        id: 'sc5',
        nombre: 'Fiesta de la Virgen de Cotoca (celebraciones regionales)',
        mes: 'may-octubre',
        tipo: 'religioso',
        descripcion: 'Celebraciones religiosas en Cotoca.',
        fecha: null,
        imagenes: ['assets/images/festividades/sc5_1.jpg'],
      ),
    ],
  ),

  Departamento(
    id: 'or',
    nombre: 'Oruro',
    imagenAsset: 'assets/images/oruro.jpg',
    festividades: [
      Festividad(
        id: 'or1',
        nombre: 'Carnaval de Oruro',
        mes: 'febrero',
        tipo: 'folklore',
        descripcion: 'Uno de los carnavales más emblemáticos de Bolivia.',
        fecha: null,
        imagenes: ['assets/images/festividades/or1_1.jpg'],
      ),
      Festividad(
        id: 'or2',
        nombre: 'Virgen del Socavón (actividades principales del carnaval)',
        mes: 'febrero',
        tipo: 'religioso/folklore',
        descripcion: 'Actos religiosos y manifestaciones del carnaval.',
        fecha: null,
        imagenes: ['assets/images/festividades/or2_1.jpg'],
      ),
      Festividad(
        id: 'or3',
        nombre: 'Semana Santa',
        mes: 'marzo',
        tipo: 'religioso',
        descripcion: 'Procesiones y celebraciones de Semana Santa en Oruro.',
        fecha: null,
        imagenes: ['assets/images/festividades/or3_1.jpg'],
      ),
      Festividad(
        id: 'or4',
        nombre: 'Fiesta del Carnaval Andino',
        mes: 'febrero',
        tipo: 'folklore',
        descripcion: 'Celebraciones andinas del carnaval.',
        fecha: null,
        imagenes: ['assets/images/festividades/or4_1.jpg'],
      ),
    ],
  ),

  Departamento(
    id: 'pt',
    nombre: 'Potosí',
    imagenAsset: 'assets/images/potosi.jpg',
    festividades: [
      Festividad(
        id: 'pt1',
        nombre: 'Carnaval potosino',
        mes: 'febrero',
        tipo: 'folklore',
        descripcion: 'Carnaval tradicional en Potosí.',
        fecha: null,
        imagenes: ['assets/images/festividades/pt1_1.jpg'],
      ),
      Festividad(
        id: 'pt2',
        nombre: 'Fiesta de la Virgen de Guadalupe (celebraciones locales)',
        mes: 'septiembre',
        tipo: 'religioso',
        descripcion: 'Celebraciones locales religiosas.',
        fecha: null,
        imagenes: ['assets/images/festividades/pt2_1.jpg'],
      ),
      Festividad(
        id: 'pt3',
        nombre: 'Semana Santa',
        mes: 'marzo',
        tipo: 'religioso',
        descripcion: 'Procesiones y actos religiosos tradicionales.',
        fecha: null,
        imagenes: ['assets/images/festividades/pt3_1.jpg'],
      ),
      Festividad(
        id: 'pt4',
        nombre:
            'Festividades mineras y aniversarios de Potosí (actos culturales)',
        mes: 'mayo',
        tipo: 'cultural',
        descripcion: 'Eventos culturales relacionados con la historia minera.',
        fecha: null,
        imagenes: ['assets/images/festividades/pt4_1.jpg'],
      ),
    ],
  ),

  Departamento(
    id: 'tj',
    nombre: 'Tarija',
    imagenAsset: 'assets/images/tarija.jpg',
    festividades: [
      Festividad(
        id: 'tj1',
        nombre: 'Vendimia (Fiesta de la Vendimia y del Vino)',
        mes: 'marzo',
        tipo: 'gastronómico/feria',
        descripcion: 'Celebración de la cosecha de la uva y el vino.',
        fecha: null,
        imagenes: ['assets/images/festividades/tj1_1.jpg'],
      ),
      Festividad(
        id: 'tj2',
        nombre: 'Carnaval tarijeño',
        mes: 'febrero',
        tipo: 'folklore',
        descripcion: 'Carnaval local con tradiciones tarijeñas.',
        fecha: null,
        imagenes: ['assets/images/festividades/tj2_1.jpg'],
      ),
      Festividad(
        id: 'tj3',
        nombre: 'Fiestas patronales locales',
        mes: 'septiembre',
        tipo: 'religioso/cultural',
        descripcion: 'Fiestas patronales y celebraciones comunitarias.',
        fecha: null,
        imagenes: ['assets/images/festividades/tj3_1.jpg'],
      ),
      Festividad(
        id: 'tj4',
        nombre: 'Festival de la Cosecha y Tradiciones',
        mes: 'abril',
        tipo: 'cultural',
        descripcion: 'Eventos ligados a la cosecha y tradiciones rurales.',
        fecha: null,
        imagenes: ['assets/images/festividades/tj4_1.jpg'],
      ),
    ],
  ),

  Departamento(
    id: 'ch',
    nombre: 'Chuquisaca (Sucre)',
    imagenAsset: 'assets/images/chuquisaca.jpg',
    festividades: [
      Festividad(
        id: 'ch1',
        nombre: 'Aniversario de Sucre (fiestas cívicas y culturales)',
        mes: 'mayo',
        tipo: 'cultural',
        descripcion: 'Celebraciones cívicas y culturales de la ciudad.',
        fecha: null,
        imagenes: ['assets/images/festividades/ch1_1.jpg'],
      ),
      Festividad(
        id: 'ch2',
        nombre: 'Semana Santa (procesiones y actividades religiosas)',
        mes: 'marzo',
        tipo: 'religioso',
        descripcion: 'Actos religiosos y procesiones de Semana Santa.',
        fecha: null,
        imagenes: ['assets/images/festividades/ch2_1.jpg'],
      ),
      Festividad(
        id: 'ch3',
        nombre: 'Fiestas patronales y actos universitarios',
        mes: 'varios',
        tipo: 'cultural',
        descripcion: 'Eventos patronales y celebraciones universitarias.',
        fecha: null,
        imagenes: ['assets/images/festividades/ch3_1.jpg'],
      ),
      Festividad(
        id: 'ch4',
        nombre: 'Festival de música y danza tradicional',
        mes: 'agosto',
        tipo: 'folklore',
        descripcion: 'Festival de música y danzas típicas.',
        fecha: null,
        imagenes: ['assets/images/festividades/ch4_1.jpg'],
      ),
    ],
  ),

  Departamento(
    id: 'bn',
    nombre: 'Beni',
    imagenAsset: 'assets/images/beni.jpg',
    festividades: [
      Festividad(
        id: 'bn1',
        nombre: 'Carnaval de Trinidad',
        mes: 'febrero',
        tipo: 'folklore',
        descripcion: 'Carnaval tradicional en Trinidad con comparsas locales.',
        fecha: null,
        imagenes: ['assets/images/festividades/bn1_1.jpg'],
      ),
      Festividad(
        id: 'bn2',
        nombre: 'Fiesta de San Ignacio y celebraciones misioneras',
        mes: 'julio',
        tipo: 'religioso/cultural',
        descripcion: 'Celebraciones misioneras y festividades religiosas.',
        fecha: null,
        imagenes: ['assets/images/festividades/bn2_1.jpg'],
      ),
      Festividad(
        id: 'bn3',
        nombre: 'Festividad de la Amazonía y ferias regionales',
        mes: 'agosto',
        tipo: 'feria/cultural',
        descripcion: 'Ferias y eventos en la región amazónica.',
        fecha: null,
        imagenes: ['assets/images/festividades/bn3_1.jpg'],
      ),
      Festividad(
        id: 'bn4',
        nombre: 'Festival de la Chiquitanía (eventos culturales)',
        mes: 'septiembre',
        tipo: 'cultural',
        descripcion:
            'Festival cultural que celebra la región de la Chiquitanía.',
        fecha: null,
        imagenes: ['assets/images/festividades/bn4_1.jpg'],
      ),
    ],
  ),

  Departamento(
    id: 'pd',
    nombre: 'Pando',
    imagenAsset: 'assets/images/pando.jpg',
    festividades: [
      Festividad(
        id: 'pd1',
        nombre: 'Feria de la Castaña',
        mes: 'agosto',
        tipo: 'gastronómico/feria',
        descripcion: 'Feria enfocada en la castaña y productos regionales.',
        fecha: null,
        imagenes: ['assets/images/festividades/pd1_1.jpg'],
      ),
      Festividad(
        id: 'pd2',
        nombre: 'Fiestas regionales de la Amazonía',
        mes: 'julio',
        tipo: 'cultural',
        descripcion: 'Celebraciones culturales de la región amazónica.',
        fecha: null,
        imagenes: ['assets/images/festividades/pd2_1.jpg'],
      ),
      Festividad(
        id: 'pd3',
        nombre: 'Celebraciones por la diversidad cultural y feria artesanal',
        mes: 'septiembre',
        tipo: 'cultural/feria',
        descripcion: 'Feria artesanal y celebración de la diversidad cultural.',
        fecha: null,
        imagenes: ['assets/images/festividades/pd3_1.jpg'],
      ),
    ],
  ),
];
