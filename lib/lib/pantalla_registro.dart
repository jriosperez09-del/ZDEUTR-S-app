import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nombreCompleto = TextEditingController();
  final TextEditingController _telefono = TextEditingController();
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contraseña = TextEditingController();
  final TextEditingController _ruta = TextEditingController();
  
  bool _cargando = false;

  Future<void> _registrarUsuario() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _cargando = true;
      });

      try {
        // Guardar datos en Firebase Firestore
        await FirebaseFirestore.instance.collection('usuarios').add({
          'nombreCompleto': _nombreCompleto.text.trim(),
          'telefono': _telefono.text.trim(),
          'correo': _correo.text.trim(),
          'ruta': _ruta.text.trim(),
          'fechaRegistro': Timestamp.now(),
          'activo': true,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ ¡Registro exitoso! Bienvenido a ZDE UTRS'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          // Limpiar formulario
          _nombreCompleto.clear();
          _telefono.clear();
          _correo.clear();
          _contraseña.clear();
          _ruta.clear();
        }
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Error al registrar: $error'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _cargando = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.person_add, size: 80, color: Color(0xFF1A237E)),
              const SizedBox(height: 20),
              const Text(
                'Completa tus datos',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              // Nombre Completo
              TextFormField(
                controller: _nombreCompleto,
                decoration: InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor escribe tu nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Teléfono
              TextFormField(
                controller: _telefono,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor escribe tu teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Correo
              TextFormField(
                controller: _correo,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor escribe tu correo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Ruta
              TextFormField(
                controller: _ruta,
                decoration: InputDecoration(
                  labelText: 'Ruta / Grupo',
                  prefixIcon: const Icon(Icons.route),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor escribe tu ruta o grupo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Botón Registrar
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _cargando ? null : _registrarUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _cargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'REGISTRARME',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
