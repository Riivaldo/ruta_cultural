// lib/screens/map_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models/departamento.dart';
import 'package:avanzado_ruta_cultural/data/ubicaciones.dart';
import '../services/favoritos.dart';
import '../services/almacenamiento.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late Festividad festividad;
  Departamento? departamento;
  LatLng? ubicacion;

  String usuarioActual = 'Usuario';
  Set<String> favoritos = {};
  LatLng? puntoA;
  LatLng? puntoB;
  List<Polyline> rutasCalculadas = [];
  bool cargandoRuta = false;

  double? ultimaDistanciaMetros;
  double? ultimaDuracionSegundos;
  String? ultimoModo;
  String estadoSeleccion = '';

  bool modoSeleccionA = false;
  bool modoSeleccionB = false;

  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _cargarUsuarioYFavoritos();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _cargarUsuarioYFavoritos() async {
    try {
      final u = await SessionStorage.obtenerSesion();
      final fav = await FavoritosService.obtenerFavoritos();
      if (!mounted) return;
      setState(() {
        usuarioActual = (u != null && u.isNotEmpty) ? u : 'Usuario';
        favoritos = fav;
      });
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map) {
      final dynamic f = args['festividad'];
      final dynamic d = args['departamento'];
      if (f is Festividad) festividad = f;
      if (d is Departamento) departamento = d;
      ubicacion = ubicacionesFestividades[festividad.id];
      _currentImageIndex = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(0);
        }
      });
    }
  }

  Future<void> _toggleFavorito() async {
    final ahoraEsFav = favoritos.contains(festividad.id);
    setState(() {
      if (ahoraEsFav) {
        favoritos.remove(festividad.id);
      } else {
        favoritos.add(festividad.id);
      }
    });

    await FavoritosService.alternarFavorito(festividad.id);
    final s = await FavoritosService.obtenerFavoritos();
    if (!mounted) return;
    setState(() => favoritos = s);
  }

  void _mostrarFavoritosPanel() async {
    final favIds = await FavoritosService.obtenerFavoritos();
    if (!mounted) return;

    // Obtener lista de Festividad 
    final allFest = departamentosEjemplo.expand((d) => d.festividades).toList();
    final listaFav = favIds.map((id) {
      final encontrado = allFest.firstWhere(
        (f) => f.id == id,
        orElse: () => Festividad(
          id: id,
          nombre: id,
          mes: '',
          tipo: '',
          imagenes: const [],
        ),
      );
      return encontrado;
    }).toList();

    showModalBottomSheet(
      context: context,
      builder: (_) => SizedBox(
        height: 360,
        child: Column(
          children: [
            ListTile(
              title: const Text('Favoritos'),
              trailing: Text('${listaFav.length}'),
            ),
            const Divider(),
            Expanded(
              child: listaFav.isEmpty
                  ? const Center(child: Text('No hay favoritos'))
                  : ListView.builder(
                      itemCount: listaFav.length,
                      itemBuilder: (context, i) {
                        final f = listaFav[i];
                        return ListTile(
                          leading: f.imagenes.isNotEmpty
                              ? SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Image.asset(
                                    f.imagenes.first,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.event),
                          title: Text(f.nombre),
                          subtitle: Text(
                            f.mes.isNotEmpty ? '${f.mes} • ${f.tipo}' : f.id,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            final latlng = ubicacionesFestividades[f.id];
                            if (latlng != null) {
                              Navigator.of(context).pushReplacementNamed(
                                '/map',
                                arguments: {
                                  'festividad': f,
                                  'departamento': null,
                                },
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'No hay ubicación para este favorito.',
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<LatLng> _coordsGeoJsonToLatLng(List<dynamic> coords) {
    return coords.map<LatLng>((c) {
      final lon = (c[0] as num).toDouble();
      final lat = (c[1] as num).toDouble();
      return LatLng(lat, lon);
    }).toList();
  }

  Future<void> _calcularRutaORS({required String profile}) async {
    if (puntoA == null || puntoB == null) {
      _mostrarError('Selecciona punto A y punto B en el mapa.');
      return;
    }
    final apiKey = dotenv.env['ORS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      _mostrarError('No hay API key ORS. Añade ORS_API_KEY en .env');
      return;
    }

    setState(() => cargandoRuta = true);
    try {
      final url = Uri.parse(
        'https://api.openrouteservice.org/v2/directions/$profile/geojson',
      );
      final body = json.encode({
        'coordinates': [
          [puntoA!.longitude, puntoA!.latitude],
          [puntoB!.longitude, puntoB!.latitude],
        ],
      });

      final resp = await http.post(
        url,
        headers: {'Authorization': apiKey, 'Content-Type': 'application/json'},
        body: body,
      );

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        _mostrarError('Error en ORS: ${resp.statusCode}. ${resp.body}');
        return;
      }

      final data = json.decode(resp.body);
      final coords =
          data['features'][0]['geometry']['coordinates'] as List<dynamic>;
      final puntos = _coordsGeoJsonToLatLng(coords);

      final distancia =
          (data['features'][0]['properties']?['summary']?['distance']) ?? 0;
      final duracion =
          (data['features'][0]['properties']?['summary']?['duration']) ?? 0;

      final poly = Polyline(
        points: puntos,
        strokeWidth: 6.0,
        color: profile == 'foot-walking'
            ? Colors.orange.withValues(alpha: 0.9)
            : Colors.purple.withValues(alpha: 0.9),
      );

      setState(() {
        rutasCalculadas = [poly];
        ultimaDistanciaMetros = (distancia is num)
            ? distancia.toDouble()
            : null;
        ultimaDuracionSegundos = (duracion is num) ? duracion.toDouble() : null;
        ultimoModo = profile;
        estadoSeleccion =
            'Ruta calculada (${ultimoModo == 'foot-walking' ? 'A Pie' : 'En Auto'})';
      });

      if (!mounted) return;
      _mostrarDialogoRuta(
        distancia: distancia,
        duracion: duracion,
        modo: profile,
      );
    } catch (e) {
      _mostrarError('Error calculando ruta: $e');
    } finally {
      if (mounted) setState(() => cargandoRuta = false);
    }
  }

  void _mostrarError(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _mostrarDialogoRuta({
    required dynamic distancia,
    required dynamic duracion,
    required String modo,
  }) {
    if (!mounted) return;
    final km = (distancia is num) ? (distancia / 1000.0) : null;
    final min = (duracion is num) ? (duracion / 60.0) : null;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detalles de la ruta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Modo: ${modo == 'foot-walking' ? 'A Pie' : 'En Auto'}'),
            if (km != null) Text('Distancia: ${km.toStringAsFixed(2)} km'),
            if (min != null)
              Text('Duración estimada: ${min.toStringAsFixed(0)} min'),
            const SizedBox(height: 12),
            Text(
              'Puntos A: ${puntoA?.latitude.toStringAsFixed(5)}, ${puntoA?.longitude.toStringAsFixed(5)}',
            ),
            Text(
              'Puntos B: ${puntoB?.latitude.toStringAsFixed(5)}, ${puntoB?.longitude.toStringAsFixed(5)}',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<String> fotos) {
    if (fotos.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset('assets/images/bolivia.jpg', fit: BoxFit.cover),
      );
    }
    if (fotos.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          fotos[0],
          fit: BoxFit.cover,
          width: double.infinity,
          height: 180,
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: fotos.length,
                onPageChanged: (index) =>
                    setState(() => _currentImageIndex = index),
                itemBuilder: (context, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    fotos[i],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    fotos.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentImageIndex == i ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentImageIndex == i
                            ? Colors.white
                            : Colors.white54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 64,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            scrollDirection: Axis.horizontal,
            itemCount: fotos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final selected = _currentImageIndex == i;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                  setState(() => _currentImageIndex = i);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: selected ? 84 : 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected ? Colors.white : Colors.white24,
                      width: selected ? 2 : 1,
                    ),
                    boxShadow: [
                      if (selected)
                        const BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(fotos[i], fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final fotos = (festividad.imagenes.isNotEmpty)
        ? festividad.imagenes
        : ['assets/images/bolivia.jpg'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          festividad.nombre,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6F6F), Color(0xFFFF8A80)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
        actions: [
          IconButton(
            tooltip: 'Favoritos',
            icon: Icon(
              favoritos.contains(festividad.id)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: favoritos.contains(festividad.id)
                  ? Colors.red
                  : Colors.white,
            ),
            onPressed: _toggleFavorito,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  child: Text(
                    usuarioActual.isNotEmpty
                        ? usuarioActual[0].toUpperCase()
                        : 'U',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text('Usuario: $usuarioActual')),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _toggleFavorito,
                  icon: Icon(
                    favoritos.contains(festividad.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favoritos.contains(festividad.id)
                        ? Colors.red
                        : Colors.white,
                  ),
                  label: Text(
                    favoritos.contains(festividad.id)
                        ? 'Quitar favorito'
                        : 'Marcar favorito',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: favoritos.contains(festividad.id)
                        ? Colors.white
                        : null,
                    foregroundColor: favoritos.contains(festividad.id)
                        ? Colors.black
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _mostrarFavoritosPanel,
                  icon: const Icon(Icons.list),
                  label: const Text('Ver favoritos'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${festividad.nombre} — ${festividad.mes} • ${festividad.tipo}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                if (festividad.fecha != null)
                  Text('Fecha: ${festividad.fecha}'),
                if (festividad.descripcion != null)
                  Text(
                    festividad.descripcion!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                _buildImageCarousel(fotos),
              ],
            ),
          ),

          Expanded(
            child: ubicacion == null
                ? Center(
                    child: Text(
                      'No hay ubicación definida para ${festividad.nombre}',
                    ),
                  )
                : FlutterMap(
                    options: MapOptions(
                      initialCenter: ubicacion!,
                      initialZoom: 13.0,
                      onTap: (tapPos, latlng) {
                        if (modoSeleccionA) {
                          setState(() {
                            puntoA = latlng;
                            modoSeleccionA = false;
                            estadoSeleccion = 'Punto A seleccionado';
                          });
                          return;
                        }
                        if (modoSeleccionB) {
                          setState(() {
                            puntoB = latlng;
                            modoSeleccionB = false;
                            estadoSeleccion = 'Punto B seleccionado';
                          });
                          return;
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName:
                            'com.example.avanzado_ruta_cultural',
                      ),
                      MarkerLayer(
                        markers: [
                          if (ubicacion != null)
                            Marker(
                              point: ubicacion!,
                              width: 64,
                              height: 64,
                              child: const Icon(Icons.location_on, size: 40),
                            ),
                          if (puntoA != null)
                            Marker(
                              point: puntoA!,
                              width: 56,
                              height: 56,
                              child: const Icon(
                                Icons.adjust,
                                size: 34,
                                color: Colors.blue,
                              ),
                            ),
                          if (puntoB != null)
                            Marker(
                              point: puntoB!,
                              width: 56,
                              height: 56,
                              child: const Icon(
                                Icons.flag,
                                size: 34,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                      if (rutasCalculadas.isNotEmpty)
                        PolylineLayer(polylines: rutasCalculadas),
                    ],
                  ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            estadoSeleccion.isNotEmpty
                                ? estadoSeleccion
                                : 'Sin acciones recientes',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (rutasCalculadas.isNotEmpty &&
                        ultimaDistanciaMetros != null &&
                        ultimaDuracionSegundos != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Modo: ${ultimoModo == 'foot-walking' ? 'A Pie' : 'En Auto'}',
                          ),
                          Text(
                            '${(ultimaDistanciaMetros! / 1000).toStringAsFixed(2)} km',
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Duración aprox.: ${(ultimaDuracionSegundos! / 60).round()} min',
                          ),
                          Text(
                            'A: ${puntoA != null ? puntoA!.latitude.toStringAsFixed(4) : '-'} , B: ${puntoB != null ? puntoB!.latitude.toStringAsFixed(4) : '-'}',
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Punto A: ${puntoA != null ? '${puntoA!.latitude.toStringAsFixed(5)}, ${puntoA!.longitude.toStringAsFixed(5)}' : '—'}',
                          ),
                          Text(
                            'Punto B: ${puntoB != null ? '${puntoB!.latitude.toStringAsFixed(5)}, ${puntoB!.longitude.toStringAsFixed(5)}' : '—'}',
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.place),
                  label: const Text('Seleccionar Punto A'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      modoSeleccionA = true;
                      modoSeleccionB = false;
                      estadoSeleccion = 'Marcar Punto A';
                    });
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.flag),
                  label: const Text('Seleccionar Punto B'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      modoSeleccionB = true;
                      modoSeleccionA = false;
                      estadoSeleccion = 'Marcar Punto B';
                    });
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.directions_car),
                  label: cargandoRuta
                      ? const Text('Calculando...')
                      : const Text('Calcular ruta (Auto)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: (puntoA != null && puntoB != null && !cargandoRuta)
                      ? () => _calcularRutaORS(profile: 'driving-car')
                      : null,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.directions_walk),
                  label: cargandoRuta
                      ? const Text('Calculando...')
                      : const Text('Calcular ruta (Pie)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: (puntoA != null && puntoB != null && !cargandoRuta)
                      ? () => _calcularRutaORS(profile: 'foot-walking')
                      : null,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Limpiar puntos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      puntoA = null;
                      puntoB = null;
                      rutasCalculadas = [];
                      ultimaDistanciaMetros = null;
                      ultimaDuracionSegundos = null;
                      ultimoModo = null;
                      estadoSeleccion = '';
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
