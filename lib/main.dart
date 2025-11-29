import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/registro.dart';
import 'models/departamento.dart';
import 'services/almacenamiento.dart';
import 'screens/map_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // .env para cargar la API de ORS 
  runApp(const RutaCulturalApp());
}


class RutaCulturalApp extends StatelessWidget {
  const RutaCulturalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RUTA CULTURAL',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const RootChecker(),
        '/login': (context) => const LoginScreen(),
        '/registro': (context) =>
            const RegisterScreen(),
        '/home': (context) => const PantallaPrincipal(),
        '/map': (context) => const MapScreen(),
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
    return Scaffold(
      body: Center(
        child: _checking
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Verificando sesión...'),
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
    final festividades = obtenerFestividadesMostradas();

    return Scaffold(
      appBar: AppBar(
        title: const Text('RUTA CULTURAL'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Text(usuario, style: const TextStyle(fontSize: 14)),
            ),
          ),
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cerrar sesión'),
                  content: const Text(
                    '¿Deseas cerrar la sesión y volver al login?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Cerrar sesión'),
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
                      decoration: const InputDecoration(
                        labelText: 'Departamento (Bolivia)',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<Departamento?>(
                          value: null,
                          child: Text('--- Todo Bolivia ---'),
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
                        PopupMenuButton<String>(
                          onSelected: (v) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Idioma seleccionado: $v (a futuro)',
                                ),
                              ),
                            );
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'es', child: Text('Español')),
                            PopupMenuItem(value: 'en', child: Text('Inglés')),
                            PopupMenuItem(value: 'zh', child: Text('Chino')),
                          ],
                          child: ElevatedButton(
                            onPressed: null,
                            child: const Text('Idioma'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Analítica (a futuro)'),
                                content: Text(
                                  departamentoSeleccionado == null
                                      ? 'Mostrará los lugares más visitados en toda Bolivia.'
                                      : 'Mostrará los lugares más visitados en ${departamentoSeleccionado!.nombre}.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cerrar'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Analítica'),
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
                      decoration: const InputDecoration(
                        labelText: 'Buscar festividad...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => setState(() => textoBusqueda = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: DropdownButtonFormField<String>(
                      initialValue: filtroMes,
                      decoration: const InputDecoration(
                        labelText: 'Mes',
                        border: OutlineInputBorder(),
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
                      decoration: const InputDecoration(
                        labelText: 'Tipo',
                        border: OutlineInputBorder(),
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
                                    'Bolivia - Todas las festividades',
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
                                    ? 'Imagen general de Bolivia'
                                    : 'Imagen de ${departamentoSeleccionado!.nombre}',
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
                              const Text(
                                'Festividades',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: festividades.isEmpty
                                    ? const Center(
                                        child: Text(
                                          'No hay festividades con estos filtros.',
                                        ),
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
                                      title: const Text('Expositor'),
                                      content: const Text(
                                        'Llevará al "Mapa en tiempo real" (a futuro).',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cerrar'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.map),
                                label: const Text('EXPOSITOR'),
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
