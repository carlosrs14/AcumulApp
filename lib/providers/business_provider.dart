import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/category.dart';
import 'package:acumulapp/models/link.dart';
import 'package:acumulapp/models/ubication.dart';

class BusinessProvider {
  // Lista interna de negocios
  final List<Business> _businesses = [];

  // Lista de categorías estáticas: puedes exponerla públicamente si la necesitas en UI
  final List<Category> _allCategories = [
    Category(0, "All", "Todos"),
    Category(
      1,
      "Restaurante",
      "Negocios de comida, restaurantes y similares",
    ),
    Category(2, "Café/Panadería", "Cafés, panaderías y reposterías"),
    Category(3, "Ropa", "Tiendas de ropa y moda"),
    Category(4, "Librería", "Librerías y papelerías"),
    Category(5, "Gimnasio", "Gimnasios y centros deportivos"),
    Category(6, "Agencia de Viajes", "Agencias de viajes y turismo"),
    Category(7, "Electrónica", "Tiendas de electrónica y tecnología"),
  ];

  // Contador interno para asignar nuevos IDs automáticamente si se desea
  int _nextBusinessId = 108;

  BusinessProvider() {
    // Inicializar 7 negocios de ejemplo, asignando categorías de _allCategories
    // 1. La Parrilla Bogotana — categoría Restaurante
    _businesses.add(
      Business(
        101,
        "La Parrilla Bogotana",
        "Calle 85 #12-34, Bogotá",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAw_UHRzFcfVBrK2mANMr6c9SY_y8CKxAxIw&s",
        [
          Link(1, "https://facebook.com/laparrillabogotana", "Facebook"),
          Link(2, "https://instagram.com/laparrillabogotana", "Instagram"),
          Link(3, "https://twitter.com/laparrillabogo", "Twitter"),
        ],
        Ubication(1, "Bogotá"),
        // categoría 1: Restaurante
        [_allCategories.firstWhere((c) => c.id == 1)],
        3.5,
      ),
    );

    // 2. Dulce Aroma — Café/Panadería
    _businesses.add(
      Business(
        102,
        "Dulce Aroma",
        "Carrera 7 #45-67, Medellín",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAw_UHRzFcfVBrK2mANMr6c9SY_y8CKxAxIw&s",
        [
          Link(4, "https://facebook.com/dulcearoma", "Facebook"),
          Link(5, "https://instagram.com/dulcearoma", "Instagram"),
        ],
        Ubication(2, "Medellín"),
        // categoría 2: Café/Panadería
        [_allCategories.firstWhere((c) => c.id == 2)],
        3.5,
      ),
    );

    // 3. Moda Urbana — Ropa
    _businesses.add(
      Business(
        103,
        "Moda Urbana",
        "Avenida El Poblado #10-20, Medellín",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAw_UHRzFcfVBrK2mANMr6c9SY_y8CKxAxIw&s",
        [
          Link(6, "https://instagram.com/modaurbana", "Instagram"),
          Link(7, "https://tiktok.com/@modaurbana", "TikTok"),
        ],
        Ubication(2, "Medellín"),
        // categoría 3: Ropa
        [_allCategories.firstWhere((c) => c.id == 3)],
        3.5,
      ),
    );

    // 4. Página y Pluma — Librería
    _businesses.add(
      Business(
        104,
        "Página y Pluma",
        "Calle 9 #16-30, Cali",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAw_UHRzFcfVBrK2mANMr6c9SY_y8CKxAxIw&s",
        [
          Link(8, "https://facebook.com/paginaypluma", "Facebook"),
          Link(9, "https://instagram.com/paginaypluma", "Instagram"),
        ],
        Ubication(3, "Cali"),
        // categoría 4: Librería
        [_allCategories.firstWhere((c) => c.id == 4)],
        3.5,
      ),
    );

    // 5. FitLife — Gimnasio
    _businesses.add(
      Business(
        105,
        "FitLife",
        "Av. Simón Bolívar #5-50, Barranquilla",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAw_UHRzFcfVBrK2mANMr6c9SY_y8CKxAxIw&s",
        [
          Link(10, "https://facebook.com/fitlifebaq", "Facebook"),
          Link(11, "https://instagram.com/fitlifebaq", "Instagram"),
        ],
        Ubication(4, "Barranquilla"),
        // categoría 5: Gimnasio
        [_allCategories.firstWhere((c) => c.id == 5)],
        4.0,
      ),
    );

    // 6. Rutas y Destinos — Agencia de Viajes
    _businesses.add(
      Business(
        106,
        "Rutas y Destinos",
        "Carrera 15 #8-90, Cartagena",
        "https://encrypted-tbgstatic.com/images?q=tbn:ANd9GcSAw_UHRzFcfVBrK2mANMr6c9SY_y8CKxAxIw&s",
        [
          Link(12, "https://facebook.com/rutasy_destinos", "Facebook"),
          Link(13, "https://instagram.com/rutasy_destinos", "Instagram"),
          Link(
            14,
            "https://linkedin.com/company/rutasy_destinos",
            "LinkedIn",
          ),
        ],
        Ubication(5, "Cartagena"),
        // categoría 6: Agencia de Viajes
        [_allCategories.firstWhere((c) => c.id == 6)],
        3.5,
      ),
    );

    // 7. TechConexión — Electrónica
    _businesses.add(
      Business(
        107,
        "TechConexión",
        "Diagonal 20 #30-15, Bucaramanga",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAw_UHRzFcfVBrK2mANMr6c9SY_y8CKxAxIw&s",
        [
          Link(15, "https://facebook.com/techconexion", "Facebook"),
          Link(16, "https://instagram.com/techconexion", "Instagram"),
          Link(17, "https://twitter.com/techconexion", "Twitter"),
        ],
        Ubication(6, "Bucaramanga"),
        // categoría 7: Electrónica
        [_allCategories.firstWhere((c) => c.id == 7)],
        3.5,
      ),
    );
  }

  /// Retorna la lista de todas las categorías disponibles.
  List<Category> getAllCategories() {
    // Devuelve copia si no quieres exponer la lista interna:
    return List<Category>.from(_allCategories);
  }

  /// Crea un nuevo negocio en memoria, asignándole un ID automáticamente.
  Business create(Business business) {
    // Asignar ID único
    business.id = _nextBusinessId;
    _nextBusinessId++;
    _businesses.add(business);
    return business;
  }

  /// Devuelve todos los negocios (copia).
  List<Business> getAll() {
    return List<Business>.from(_businesses);
  }

  /// Filtra negocios que tengan alguna categoría con nombre que contenga 'categoryName' (case-insensitive).
  List<Business> filterByCategoryName(String categoryName) {
    final key = categoryName.toLowerCase();
    if (categoryName == "All") {
      return _businesses;
    }
    return _businesses.where((b) {
      return b.categories.any((Category cat) => cat.name.toLowerCase().contains(key));
    }).toList();
  }

  /// Filtra negocios que tengan la categoría con el ID dado.
  List<Business> filterByCategoryId(int categoryId) {
    return _businesses.where((b) {
      return b.categories.any((Category cat) => cat.id == categoryId);
    }).toList();
  }

  /// Obtiene un negocio por ID. Lanza Exception si no existe.
  Business get(int id) {
    try {
      return _businesses.firstWhere((b) => b.id == id);
    } catch (e) {
      throw Exception('Business con id=$id no encontrado');
    }
  }

  /// Actualiza un negocio dado su ID. Retorna el negocio actualizado o lanza Exception.
  Business update(int id, Business business) {
    for (var i = 0; i < _businesses.length; i++) {
      if (_businesses[i].id == id) {
        business.id = id; // forzar que mantenga el mismo ID
        _businesses[i] = business;
        return business;
      }
    }
    throw Exception('No se pudo actualizar: Business con id=$id no encontrado');
  }

  /// Elimina un negocio por ID. Retorna true si se eliminó, false si no existía.
  bool delete(int id) {
    final index = _businesses.indexWhere((b) => b.id == id);
    if (index >= 0) {
      _businesses.removeAt(index);
      return true;
    }
    return false;
  }
}
