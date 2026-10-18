class ApiService {
  // Alamat backend. Default untuk development lokal.
  // Saat build produksi: flutter build web --dart-define=API_URL=https://nama-app.onrender.com
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:3000',
  );
}
