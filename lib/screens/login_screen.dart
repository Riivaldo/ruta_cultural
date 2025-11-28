import 'package:flutter/material.dart';
import '../services/almacenamiento.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  bool cargando = false;
  bool mostrarContrasena = false;

  @override
  void dispose() {
    usuarioController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  Future<void> intentarLogin() async {
    if (cargando) return;
    final String usuario = usuarioController.text.trim();
    final String pass = contrasenaController.text.trim();

    if (usuario.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    setState(() => cargando = true);

    try {
      // Cargar usuarios registrados
      final List usuarios = await UserStorage.cargarUsuarios();

      // Buscar coincidencia de credenciales
      final encontrado = usuarios.cast<dynamic>().firstWhere(
        (u) {
          try {
            return u != null && u['user'] == usuario && u['pass'] == pass;
          } catch (_) {
            return false;
          }
        },
        orElse: () => null,
      );

      if (encontrado == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos')),
        );
        return;
      }

      // Guardar la sesión (clave: usuario_logueado)
      await SessionStorage.guardarSesion(usuario);

      // Ir al home (reemplazando)
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home', arguments: usuario);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('INICIAR SESIÓN', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: size.width > 600 ? 520 : size.width),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 44, color: Color(0xFF1976D2)),
                      ),
                      const SizedBox(height: 12),
                      const Text('Bienvenido', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      const SizedBox(height: 18),

                      // Usuario
                      TextField(
                        controller: usuarioController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Usuario',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Contraseña
                      TextField(
                        controller: contrasenaController,
                        obscureText: !mostrarContrasena,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(mostrarContrasena ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => mostrarContrasena = !mostrarContrasena),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Botón iniciar
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          icon: cargando
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.login),
                          label: Text(cargando ? 'Iniciando...' : 'Iniciar sesión'),
                          onPressed: intentarLogin,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Enlace para registro
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('¿No tienes cuenta?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/registro');
                            },
                            child: const Text('Regístrate'),
                          )
                        ],
                      ),

                      const SizedBox(height: 6),

                      const Text('Demo local — No uses contraseñas reales', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
