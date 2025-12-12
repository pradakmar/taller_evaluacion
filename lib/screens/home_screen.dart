
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';  // ← IMPORT OBLIGATORIO (arregla ActionPane y SlidableAction)
import '../models/estudiante.dart';
import '../services/supabase_service.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Estudiante> estudiantes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarEstudiantes();
  }

  Future<void> cargarEstudiantes() async {
    setState(() => isLoading = true);
    try {
      final response = await SupabaseService.client
          .from('estudiantes')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        estudiantes = (response as List)
            .map((json) => Estudiante.fromJson(json))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar: $e')),
        );
      }
    }
  }

  Future<void> eliminarEstudiante(String id) async {
    try {
      await SupabaseService.client.from('estudiantes').delete().eq('id', id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Estudiante eliminado')),
        );
      }
      cargarEstudiantes();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudiantes', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : estudiantes.isEmpty
              ? Center(
                  child: Text(
                    'No hay estudiantes\n¡Agrega el primero!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 20, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: estudiantes.length,
                  itemBuilder: (context, index) {
                    final est = estudiantes[index];
                    return Slidable(
                      key: ValueKey(est.id),
                      endActionPane: ActionPane(
                        // ← ARREGLADO: ScrollMotion() SÍ EXISTE en v4.0.3
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            // ← ARREGLADO: onPressed DEBE ser (BuildContext context) =>
                            onPressed: (BuildContext context) => eliminarEstudiante(est.id),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Borrar',
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(est.nombre, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(est.email),
                              Text(est.programa, style: const TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FormScreen(estudiante: est),
                              ),
                            );
                            cargarEstudiantes();
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormScreen()),
          );
          cargarEstudiantes();
        },
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Nuevo', style: GoogleFonts.poppins(color: Colors.white)),
      ),
    );
  }
}