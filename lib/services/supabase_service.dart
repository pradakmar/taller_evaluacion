import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://zimpcufaeyczpmyhebkx.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InppbXBjdWZhZXljenBteWhlYmt4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzNzYxMzAsImV4cCI6MjA4MDk1MjEzMH0.NAgGChXRlopQTcbcWnbFXT7rPErgxAxQD0SURrtjfx8',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
