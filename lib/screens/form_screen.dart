import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taller_estudiantes/models/estudiante.dart';
import 'package:taller_estudiantes/services/supabase_service.dart';

class FormScreen extends StatefulWidget {
  final Estudiante? estudiante;

  const FormScreen({super.key, this.estudiante});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController programaCtrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.estudiante?.nombre ?? '');
    emailCtrl = TextEditingController(text: widget.estudiante?.email ?? '');
    programaCtrl = TextEditingController(text: widget.estudiante?.programa ?? '');
  }

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final data = {
      'nombre': nombreCtrl.text,
      'email': emailCtrl.text,
      'programa': programaCtrl.text,
    };

    if (widget.estudiante == null) {
      // CREAR
      await SupabaseService.client.from('estudiantes').insert(data);
    } else {
      // ACTUALIZAR
      await SupabaseService.client
          .from('estudiantes')
          .update(data)
          .eq('id', widget.estudiante!.id);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.estudiante == null ? 'Nuevo Estudiante' : 'Editar Estudiante',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreCtrl,
                decoration: InputDecoration(
                  labelText: 'Nombre completo',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => v!.contains('@') ? null : 'Email inválido',
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: programaCtrl,
                decoration: InputDecoration(
                  labelText: 'Programa académico',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : guardar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.estudiante == null ? 'Guardar' : 'Actualizar',
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
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