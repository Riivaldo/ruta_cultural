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
        descripcion: 'El carnaval de Cochabamba tiene el llamado "Corso de corsos" en el que se muestra la cultura boliviana y extranjera el cual inicia con un desfile de comparsas a lo largo del Prado de Cochabamba. al que también le siguen El corso en la zona sud el cual pasa por la av. Guayacan y seguido a este En el Prado Suecia también en la zona sud de la ciudad.',
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
            'La festividad en honor a la Virgen de Urkupiña forma una serie de eventos que marcan la vida en Quillacollo en julio y agosto. Empiezan con la Fastuosa Entrada Folclórica el 14 de agosto, un desfile de cerca de diez mil bailarines disfrazados y acompañados por músicos, evento inspirado por el Carnaval de Oruro ',
        fecha: null,
        imagenes: ['assets/images/festividades/cb2_1.jpg'],
      ),
      Festividad(
        id: 'cb3',
        nombre: 'Semana Santa',
        mes: 'marzo',
        tipo: 'religioso',
        descripcion: 'n Cochabamba, la Semana Santa arrancará este 2 de abril, con el Domingo de Ramos, y contará con una amplia agenda de actividades que incluye celebraciones religiosas, viacrucis, visitas a templos y jornadas de meditación espiritual.',
        fecha: null,
        imagenes: ['assets/images/festividades/cb3_1.jpg'],
      ),
      Festividad(
        id: 'cb4',
        nombre: 'Fiesta del Señor del Gran Poder (actos locales)',
        mes: 'mayo',
        tipo: 'religioso/folklore',
        descripcion: 'El origen de la fiesta se remonta al 8 de diciembre de 1663 cuando se fundó el Convento de las Concebidas. Según la historia, en aquel entonces, las postulantes al convento debían llevar consigo una imagen. La monja Genoveva Carrión portó un lienzo de la Santísima Trinidad, consistente en una imagen de dios con tres rostros, representando así su carácter trinitario; padre, hijo y espíritu santo.',
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
        descripcion: 'El Carnaval de Santa Cruz de la Sierra, también conocido como la Fiesta Grande de los Cruceños, es una festividad cultural y religiosa de origen española, que se celebra en la ciudad de Santa Cruz de la Sierra, Bolivia. Se realiza oficialmente desde 1561, la celebración inicia con un gran desfile folklórico conocido como "el corso" en donde participan varias comparsas de la ciudad. Después del carnaval de Oruro, el Carnaval de Santa Cruz se posiciona como el segundo más importante de Bolivia.',
        fecha: null,
        imagenes: ['assets/images/festividades/sc1_1.jpg'],
      ),
      Festividad(
        id: 'sc2',
        nombre: 'Fexpocruz (Feria Exposición)',
        mes: 'septiembre',
        tipo: 'feria',
        descripcion: 'La Feria Exposición Internacional de Santa Cruz (conocida como Expocruz) es un evento anual multisectorial celebrado en Santa Cruz de la Sierra, Bolivia. Organizada por la entidad privada Fexpocruz, fundada en 1962 por la Cámara de Industria, Comercio, Servicios y Turismo de Santa Cruz (CAINCO) y la Cámara Agropecuaria del Oriente (CAO)',
        fecha: null,
        imagenes: ['assets/images/festividades/sc2_1.jpg'],
      ),
      Festividad(
        id: 'sc3',
        nombre: 'Fiesta de la Cruz',
        mes: 'mayo',
        tipo: 'religioso',
        descripcion: 'La Invención de la Santa Cruz, La Cruz de Mayo, Santa Cruz de Mayo o Fiesta de las Cruces (en algunos países, Día de la Cruz o Día de la Santa Cruz) es una de las fiestas dentro del rito romano para festejar el culto a la Cruz de Cristo.',
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
        descripcion: 'La Purísima Virgen de Cotoca, más conocida con el nombre de la Virgen de Cotoca, es una advocación de la Virgen María que se venera en la población boliviana de Cotoca, en el departamento de Santa Cruz.',
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
        descripcion: 'El carnaval de Oruro es una festividad religiosa, folclórica y cultural que se celebra anualmente en la ciudad de Oruro, Bolivia, entre febrero y principios de marzo. Es la principal expresión del carnaval boliviano y una de las manifestaciones culturales más importantes de la región.',
        fecha: null,
        imagenes: ['assets/images/festividades/or1_1.jpg'],
      ),
      Festividad(
        id: 'or2',
        nombre: 'Virgen del Socavón (actividades principales del carnaval)',
        mes: 'febrero',
        tipo: 'religioso/folklore',
        descripcion: 'La Virgen del Socavón es una advocación de la Virgen María que se venera en la ciudad de Oruro, Se celebra el sábado de carnaval, es la patrona de los mineros, además fue declarada "Patrona del Folklore Nacional" por ley de 12 de febrero de 1994.',
        fecha: null,
        imagenes: ['assets/images/festividades/or2_1.jpg'],
      ),
      Festividad(
        id: 'or3',
        nombre: 'Semana Santa',
        mes: 'marzo',
        tipo: 'religioso',
        descripcion: 'La Semana Santa en Oruro, Bolivia se caracteriza por varias tradiciones religiosas y culturales. Estas incluyen procesiones conmemorando la entrada de Jesús a Jerusalén, visitas a iglesias para rezar el Vía Crucis, y la preparación de doce platos tradicionales en Viernes Santo en memoria de la Última Cena.',
        fecha: null,
        imagenes: ['assets/images/festividades/or3_1.jpg'],
      ),
      Festividad(
        id: 'or4',
        nombre: 'Fiesta del Carnaval Andino',
        mes: 'febrero',
        tipo: 'folklore',
        descripcion: 'La anata aymara (que empieza y termina un domingo), más conocida como carnaval, es una de las festividades más difundidas en la comunidad andina. Esta celebración está íntimamente ligada a las chacras pues se rinde culto al padre de ella ispallanaka.',
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
        descripcion: 'El festejo por antonomasia en Potosí era el carnaval. El historiador Arzáns describe cómo fue el carnaval potosino en tiempos antiguos: “Eran cuadrillas de hombres y mujeres, animadas frecuentemente de una intención bélica; con sus banquetes, trajes pintorescos, bailes y juegos ‘deshonestos’; con sus saldos de muertos y heridos cruelmente porque ‘los agravios y venganzas de todo el año se guardaban para aquellos días’”.',
        fecha: null,
        imagenes: ['assets/images/festividades/pt1_1.jpg'],
      ),
      Festividad(
        id: 'pt2',
        nombre: 'Fiesta de la Virgen de Guadalupe (celebraciones locales)',
        mes: 'septiembre',
        tipo: 'religioso',
        descripcion: 'El cumpleaños de la Virgen de Guadalupe, patrona de los Chuquisaqueños es el 8 de Septiembre. De cariño, los bolivianos llaman a la virgen “Mamita Gualala”. Sucre alberga en la famosa Catedral a la Virgen de Guadalupe. La catedral se llena de flores y de cientos de visitantes que vienen a felicitar a la virgen en su día.',
        fecha: null,
        imagenes: ['assets/images/festividades/pt2_1.jpg'],
      ),
      Festividad(
        id: 'pt3',
        nombre: 'Semana Santa',
        mes: 'marzo',
        tipo: 'religioso',
        descripcion: 'En Potosí, la Semana Santa constituye una de las manifestaciones culturales y religiosas más representativas de Bolivia, donde lo sagrado y lo popular se fusionan en un mosaico de tradiciones que han perdurado desde la época colonial hasta nuestros días.',
        fecha: null,
        imagenes: ['assets/images/festividades/pt3_1.jpg'],
      ),
      Festividad(
        id: 'pt4',
        nombre:
            'Festividades mineras y aniversarios de Potosí (actos culturales)',
        mes: 'mayo',
        tipo: 'cultural',
        descripcion: 'El 10 de noviembre se celebra el aniversario cívico del departamento de Potosí, en homenaje a las gestas libertarias del 1810, cuando sus habitantes se levantaron y tomaron prisionero al gobernador español Francisco de Paula Sanz. Dos años después, las fuerzas libertarias fueron derrocadas y los promotores del levantamiento perseguidos y condenados a muertes.',
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
        descripcion: 'Celebración de la cosecha de la uva y el vino, inician en Junio y terminan en Septiembre.',
        fecha: null,
        imagenes: ['assets/images/festividades/tj1_1.jpg'],
      ),
      Festividad(
        id: 'tj2',
        nombre: 'Carnaval tarijeño',
        mes: 'febrero',
        tipo: 'folklore',
        descripcion: 'El Carnaval de Tarija Es Uno de Los Carnavales Más Importantes de Bolivia. El carnaval de Tarija dura más de un mes e incluye diversas tradiciones como la elección de la Reina del Carnaval, el desfile de comparsas con personas disfrazadas de diablo, y bailes populares.',
        fecha: null,
        imagenes: ['assets/images/festividades/tj2_1.jpg'],
      ),
      Festividad(
        id: 'tj3',
        nombre: 'Santa Anita',
        mes: 'septiembre',
        tipo: 'religioso/cultural',
        descripcion: 'La fiesta de los Niños: Es una festividad religiosa en homenaje y devoción a Santa Ana, comienza el día 26 de Julio y tiene la duración de una semana. Es una fiesta tradicional que se realiza en la antigua calle ancha o Cochabamba, cuyas características principales son: las miniaturas, la elaboración de pequeñas masas, dulces caseros, comidas regionales y artesanías.',
        fecha: null,
        imagenes: ['assets/images/festividades/tj3_1.jpg'],
      ),
      Festividad(
        id: 'tj4',
        nombre: 'Festival de la Cosecha y Tradiciones',
        mes: 'abril',
        tipo: 'cultural',
        descripcion: 'La Fiesta Grande de Tarija tiene lugar en la ciudad de este mismo nombre, situada al sudeste de Bolivia, y se celebra todos los años en los meses de agosto y septiembre con toda una serie de procesiones religiosas, festivales de música, bailes, competiciones y fuegos artificiales en honor de San Roque.',
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
        descripcion: 'El Aniversario de Sucre, celebrado cada 25 de mayo, conmemora un acontecimiento fundamental en la historia de Bolivia y de América Latina: la Revolución de Chuquisaca de 1809, conocida como el "Primer Grito Libertario" del continente.',
        fecha: null,
        imagenes: ['assets/images/festividades/ch1_1.jpg'],
      ),
      Festividad(
        id: 'ch2',
        nombre: 'Semana Santa (procesiones y actividades religiosas)',
        mes: 'marzo',
        tipo: 'religioso',
        descripcion: 'La Iglesia en Sucre invita a todo el pueblo de Dios a participar activamente de los actos litúrgicos de Semana Santa',
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
        descripcion: 'Festival de música y danzas típicas, esta forma personal de bailar se llama huayñusiña. Actualmente se da el nombre de huayñu a una singular mezcla de las antiguas danzas denominadas agua de nieve, moza mala, bolero, en ciertas figuras y en otras se nota la influencia manifiesta de la muñcira gallega..',
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
        descripcion: 'Los mascarados inundan las calles, vestidos con disfraces de todo tipo, y bailan al ritmo vibrante de la soca, el calipso y las bandas de steel pan. ¡Trinidad se convierte en la fiesta más grande del Caribe y todos son bienvenidos!',
        fecha: null,
        imagenes: ['assets/images/festividades/bn1_1.jpg'],
      ),
      Festividad(
        id: 'bn2',
        nombre: 'Fiesta de San Ignacio y celebraciones misioneras',
        mes: 'julio',
        tipo: 'religioso/cultural',
        descripcion: 'El 31 de julio es la fiesta de San Ignacio de Loyola, fundador de la Compañía de Jesús, conocida como los jesuitas, orden que desempeñó un importante papel en la contrarreforma. ',
        fecha: null,
        imagenes: ['assets/images/festividades/bn2_1.jpg'],
      ),
      Festividad(
        id: 'bn3',
        nombre: 'Festividad de la Amazonía y ferias regionales',
        mes: 'agosto',
        tipo: 'feria/cultural',
        descripcion: 'Ferias y eventos en homenaje al primer año de la victoria boliviana en la batalla de Ingavi del 18 de noviembre de 1841, se creó el departamento del Beni.',
        fecha: null,
        imagenes: ['assets/images/festividades/bn3_1.jpg'],
      ),
      Festividad(
        id: 'bn4',
        nombre: 'Festival de la Chiquitanía (eventos culturales)',
        mes: 'septiembre',
        tipo: 'cultural',
        descripcion:
            'Cada festival está acompañado por un “Encuentro Científico, Simposio Internacional de Musicología” (ECSIM), en el cual historiadores, investigadores y musicólogos discuten sobre algún tema referente a la música antigua. ',
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
        descripcion: 'Feria enfocada en la castaña, Beni es las principal region exportadora de castaña con el 76% de la producción nacional.',
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
        descripcion: 'Feria artesanal, fue un 24 de septiembre de 1938 que se creó el departamento de Pando, en memoria del ex Presidente de Bolivia, General José Manuel Pando, y como un justo homenaje de admiración y respeto',
        fecha: null,
        imagenes: ['assets/images/festividades/pd3_1.jpg'],
      ),
    ],
  ),
];
