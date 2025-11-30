import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/registro.dart';
import 'models/departamento.dart';
import 'services/almacenamiento.dart';
import 'screens/map_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('es'));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // .env para cargar la API de ORS
  runApp(const RutaCulturalApp());
}

class RutaCulturalApp extends StatelessWidget {
  const RutaCulturalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        return MaterialApp(
          title: 'RUTA CULTURAL',
          theme: ThemeData(primarySwatch: Colors.deepOrange),
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: const [Locale('es'), Locale('en'), Locale('zh')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => const RootChecker(),
            '/login': (context) => const LoginScreen(),
            '/registro': (context) => const RegisterScreen(),
            '/home': (context) => const PantallaPrincipal(),
            '/map': (context) => const MapScreen(),
          },
        );
      },
    );
  }
}

// Comprueba sesión guardada
class RootChecker extends StatefulWidget {
  const RootChecker({super.key});

  @override
  State<RootChecker> createState() => _RootCheckerState();
}

class _RootCheckerState extends State<RootChecker> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    setState(() => _checking = true);
    try {
      final usuario = await SessionStorage.obtenerSesion();

      if (usuario != null && usuario.isNotEmpty) {
        if (mounted) {
          Navigator.of(
            context,
          ).pushReplacementNamed('/home', arguments: usuario);
        }
      } else {
        // Ir a login
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: _checking
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(loc.t('verificando_sesion')),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

// PANTALLA PRINCIPAL

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  String usuario = 'Usuario';
  late List<Departamento> departamentos;
  Departamento? departamentoSeleccionado;

  String textoBusqueda = '';
  String filtroMes = 'Todos';
  String filtroTipo = 'Todos';

  final List<String> meses = [
    'Todos',
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];
  final List<String> tipos = ['Todos', 'religioso', 'folklore', 'gastronómico'];

  @override
  void initState() {
    super.initState();
    departamentos = departamentosEjemplo;
    departamentoSeleccionado = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      usuario = args;
    }
  }

  List<Festividad> obtenerFestividadesMostradas() {
    if (departamentoSeleccionado == null) {
      final all = departamentos.expand((d) => d.festividades).toList();
      return aplicarFiltrosALaLista(all);
    } else {
      return aplicarFiltrosALaLista(departamentoSeleccionado!.festividades);
    }
  }

  List<Festividad> aplicarFiltrosALaLista(List<Festividad> lista) {
    return lista.where((f) {
      final matchesBusqueda =
          textoBusqueda.isEmpty ||
          f.nombre.toLowerCase().contains(textoBusqueda.toLowerCase());
      final matchesMes =
          filtroMes == 'Todos' ||
          f.mes.toLowerCase() == filtroMes.toLowerCase();
      final matchesTipo =
          filtroTipo == 'Todos' ||
          f.tipo.toLowerCase() == filtroTipo.toLowerCase();
      return matchesBusqueda && matchesMes && matchesTipo;
    }).toList();
  }

  String obtenerImagenMostrada() {
    if (departamentoSeleccionado == null) {
      return 'assets/images/bolivia.jpg';
    } else {
      return departamentoSeleccionado!.imagenAsset;
    }
  }

  Future<void> cerrarSesion() async {
    await SessionStorage.cerrarSesion();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final festividades = obtenerFestividadesMostradas();

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.t('title')),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Text(usuario, style: const TextStyle(fontSize: 14)),
            ),
          ),
          IconButton(
            tooltip: loc.t('logout_tooltip'),
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(loc.t('logout_dialog_title')),
                  content: Text(loc.t('logout_dialog_content')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(loc.t('cancel')),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(loc.t('logout_confirm')),
                    ),
                  ],
                ),
              );
              if (confirmar == true) {
                await cerrarSesion();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Dropdown departamentos + idioma + analítica
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: DropdownButtonFormField<Departamento?>(
                      initialValue: departamentoSeleccionado,
                      decoration: InputDecoration(
                        labelText: loc.t('departamento_label'),
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<Departamento?>(
                          value: null,
                          child: Text(loc.t('todo_bolivia')),
                        ),
                        ...departamentos.map(
                          (d) =>
                              DropdownMenuItem(value: d, child: Text(d.nombre)),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => departamentoSeleccionado = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ValueListenableBuilder<Locale>(
                          valueListenable: localeNotifier,
                          builder: (context, currentLocale, _) {
                            String flagOf(String code) {
                              switch (code) {
                                case 'es':
                                  return '🇪🇸';
                                case 'en':
                                  return '🇺🇸';
                                case 'zh':
                                  return '🇨🇳';
                                default:
                                  return '🏳️';
                              }
                            }

                            String nameOf(String code) {
                              switch (code) {
                                case 'es':
                                  return 'Español';
                                case 'en':
                                  return 'English';
                                case 'zh':
                                  return '中文';
                                default:
                                  return code;
                              }
                            }

                            final currentCode = currentLocale.languageCode;
                            final currentFlag = flagOf(currentCode);
                            final currentName = nameOf(currentCode);

                            return PopupMenuButton<String>(
                              onSelected: (v) {
                                // cambia locale globalmente
                                localeNotifier.value = Locale(v);

                                final idiomaNombre = nameOf(v);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      loc.tWithArgs('language_selected', {
                                        'lang': idiomaNombre,
                                      }),
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  value: 'es',
                                  child: Row(
                                    children: const [
                                      Text(
                                        '🇪🇸',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Español'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'en',
                                  child: Row(
                                    children: const [
                                      Text(
                                        '🇺🇸',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(width: 8),
                                      Text('Inglés'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'zh',
                                  child: Row(
                                    children: const [
                                      Text(
                                        '🇨🇳',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(width: 8),
                                      Text('中文 (Chino)'),
                                    ],
                                  ),
                                ),
                              ],
                              // El botón que se muestra cuando no se ha abierto el menú
                              child: OutlinedButton(
                                onPressed: null,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  side: const BorderSide(width: 1.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      currentFlag,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(currentName),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.expand_more, size: 18),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(loc.t('analytics_title')),
                                content: Text(
                                  departamentoSeleccionado == null
                                      ? loc.t('analytics_all')
                                      : loc.tWithArgs('analytics_dept', {
                                          'dept':
                                              departamentoSeleccionado!.nombre,
                                        }),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(loc.t('close')),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text(loc.t('analytics_button')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Buscador + filtros
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: loc.t('buscar_label'),
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (v) => setState(() => textoBusqueda = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      initialValue: filtroMes,
                      decoration: InputDecoration(
                        labelText: loc.t('mes_label'),
                        border: const OutlineInputBorder(),
                      ),
                      items: meses
                          .map(
                            (m) => DropdownMenuItem(value: m, child: Text(m)),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => filtroMes = v ?? 'Todos'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      initialValue: filtroTipo,
                      decoration: InputDecoration(
                        labelText: loc.t('tipo_label'),
                        border: const OutlineInputBorder(),
                      ),
                      items: tipos
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => filtroTipo = v ?? 'Todos'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Contenido principal
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                departamentoSeleccionado?.nombre ??
                                    loc.t('all_festivities'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    obtenerImagenMostrada(),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                departamentoSeleccionado == null
                                    ? loc.t('image_general')
                                    : loc.tWithArgs('image_dept', {
                                        'dept':
                                            departamentoSeleccionado!.nombre,
                                      }),
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                loc.t('festividades'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: festividades.isEmpty
                                    ? Center(
                                        child: Text(loc.t('no_festividades')),
                                      )
                                    : ListView.separated(
                                        itemCount: festividades.length,
                                        separatorBuilder: (_, _) =>
                                            const SizedBox(height: 6),
                                        itemBuilder: (context, index) {
                                          final f = festividades[index];
                                          return ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pushNamed(
                                                '/map',
                                                arguments: {
                                                  'festividad': f,
                                                  'departamento':
                                                      departamentoSeleccionado,
                                                },
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(child: Text(f.nombre)),
                                                Text(
                                                  '${f.mes} • ${f.tipo}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text(loc.t('expositor_title')),
                                      content: Text(loc.t('expositor_content')),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(loc.t('close')),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.map),
                                label: Text(loc.t('expositor_button')),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'es': {
      'title': 'RUTA CULTURAL',
      'verificando_sesion': 'Verificando sesión...',
      'departamento_label': 'Departamento (Bolivia)',
      'todo_bolivia': '--- Todo Bolivia ---',
      'idioma_button': 'Idioma',
      'analytics_title': 'Analítica (a futuro)',
      'analytics_all': 'Mostrará los lugares más visitados en toda Bolivia.',
      'analytics_dept': 'Mostrará los lugares más visitados en {dept}.',
      'analytics_button': 'Analítica',
      'buscar_label': 'Buscar festividad...',
      'mes_label': 'Mes',
      'tipo_label': 'Tipo',
      'all_festivities': 'Bolivia - Todas las festividades',
      'image_general': 'Imagen general de Bolivia',
      'image_dept': 'Imagen de {dept}',
      'festividades': 'Festividades',
      'no_festividades': 'No hay festividades con estos filtros.',
      'expositor_title': 'Expositor',
      'expositor_content': 'Llevará al "Mapa en tiempo real" (a futuro).',
      'expositor_button': 'EXPOSITOR',
      'logout_tooltip': 'Cerrar sesión',
      'logout_dialog_title': 'Cerrar sesión',
      'logout_dialog_content': '¿Deseas cerrar la sesión y volver al login?',
      'cancel': 'Cancelar',
      'logout_confirm': 'Cerrar sesión',
      'close': 'Cerrar',
      'language_selected': 'Idioma seleccionado: {lang} (a futuro)',
    },
    'en': {
      'title': 'CULTURAL ROUTE',
      'verificando_sesion': 'Checking session...',
      'departamento_label': 'Department (Bolivia)',
      'todo_bolivia': '--- All Bolivia ---',
      'idioma_button': 'Language',
      'analytics_title': 'Analytics',
      'analytics_all': 'Will show most visited places across Bolivia.',
      'analytics_dept': 'Will show most visited places in {dept}.',
      'analytics_button': 'Analytics',
      'buscar_label': 'Search festival...',
      'mes_label': 'Month',
      'tipo_label': 'Type',
      'all_festivities': 'Bolivia - All festivities',
      'image_general': 'General image of Bolivia',
      'image_dept': 'Image of {dept}',
      'festividades': 'Festivities',
      'no_festividades': 'No festivities with these filters.',
      'expositor_title': 'Exhibitor',
      'expositor_content': 'Will lead to the "Real-time Map".',
      'expositor_button': 'EXHIBITOR',
      'logout_tooltip': 'Log out',
      'logout_dialog_title': 'Log out',
      'logout_dialog_content':
          'Do you want to end the session and return to login?',
      'cancel': 'Cancel',
      'logout_confirm': 'Log out',
      'close': 'Close',
      'language_selected': 'Selected language: {lang}',
    },
    'zh': {
      'title': '文化路线',
      'verificando_sesion': '正在验证会话…',
      'departamento_label': '省/州 (玻利维亚)',
      'todo_bolivia': '--- 整个玻利维亚 ---',
      'idioma_button': '语言',
      'analytics_title': '分析（未来）',
      'analytics_all': '将显示玻利维亚各地最受欢迎的地点。',
      'analytics_dept': '将显示 {dept} 最受欢迎的地点。',
      'analytics_button': '分析',
      'buscar_label': '搜索节日...',
      'mes_label': '月份',
      'tipo_label': '类型',
      'all_festivities': '玻利维亚 - 所有节日',
      'image_general': '玻利维亚总体图片',
      'image_dept': '{dept} 的图片',
      'festividades': '节日',
      'no_festividades': '没有符合这些筛选的节日。',
      'expositor_title': '展览',
      'expositor_content': '将转到“实时地图”（未来）。',
      'expositor_button': '展览者',
      'logout_tooltip': '登出',
      'logout_dialog_title': '登出',
      'logout_dialog_content': '您想结束会话并返回登录吗？',
      'cancel': '取消',
      'logout_confirm': '登出',
      'close': '关闭',
      'language_selected': '所选语言：{lang}（未来）',
    },
  };

  String t(String key) {
    final lang = locale.languageCode;
    final map = _localizedValues[lang] ?? _localizedValues['es']!;
    return map[key] ?? key;
  }

  String tWithArgs(String key, Map<String, String> args) {
    var txt = t(key);
    args.forEach((k, v) {
      txt = txt.replaceAll('{$k}', v);
    });
    return txt;
  }
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['es', 'en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
