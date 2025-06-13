import 'package:acumulapp/models/BusinessModel.dart';
import 'package:acumulapp/models/CategoryModel.dart';
import 'package:acumulapp/models/LinkModel.dart';
import 'package:acumulapp/models/UbicationModel.dart';

class BusinessService {
  // Lista interna de negocios
  final List<BusinessModel> _businesses = [];

  // Lista de categorías estáticas: puedes exponerla públicamente si la necesitas en UI
  final List<CategoryModel> _allCategories = [
    CategoryModel(
      1,
      "Restaurante",
      "Negocios de comida, restaurantes y similares",
    ),
    CategoryModel(2, "Café/Panadería", "Cafés, panaderías y reposterías"),
    CategoryModel(3, "Ropa", "Tiendas de ropa y moda"),
    CategoryModel(4, "Librería", "Librerías y papelerías"),
    CategoryModel(5, "Gimnasio", "Gimnasios y centros deportivos"),
    CategoryModel(6, "Agencia de Viajes", "Agencias de viajes y turismo"),
    CategoryModel(7, "Electrónica", "Tiendas de electrónica y tecnología"),
  ];

  // Contador interno para asignar nuevos IDs automáticamente si se desea
  int _nextBusinessId = 108;

  BusinessService() {
    // Inicializar 7 negocios de ejemplo, asignando categorías de _allCategories
    // 1. La Parrilla Bogotana — categoría Restaurante
    _businesses.add(
      BusinessModel(
        101,
        "La Parrilla Bogotana",
        "Calle 85 #12-34, Bogotá",
        "https://example.com/logos/la_parrilla_bogotana.png",
        [
          LinkModel(1, "https://facebook.com/laparrillabogotana", "Facebook"),
          LinkModel(2, "https://instagram.com/laparrillabogotana", "Instagram"),
          LinkModel(3, "https://twitter.com/laparrillabogo", "Twitter"),
        ],
        UbicationModel(1, "Bogotá"),
        // categoría 1: Restaurante
        [_allCategories.firstWhere((c) => c.id == 1)],
        3.5,
      ),
    );

    // 2. Dulce Aroma — Café/Panadería
    _businesses.add(
      BusinessModel(
        102,
        "Dulce Aroma",
        "Carrera 7 #45-67, Medellín",
        "https://example.com/logos/dulce_aroma.png",
        [
          LinkModel(4, "https://facebook.com/dulcearoma", "Facebook"),
          LinkModel(5, "https://instagram.com/dulcearoma", "Instagram"),
        ],
        UbicationModel(2, "Medellín"),
        // categoría 2: Café/Panadería
        [_allCategories.firstWhere((c) => c.id == 2)],
        3.5,
      ),
    );

    // 3. Moda Urbana — Ropa
    _businesses.add(
      BusinessModel(
        103,
        "Moda Urbana",
        "Avenida El Poblado #10-20, Medellín",
        "https://example.com/logos/moda_urbana.png",
        [
          LinkModel(6, "https://instagram.com/modaurbana", "Instagram"),
          LinkModel(7, "https://tiktok.com/@modaurbana", "TikTok"),
        ],
        UbicationModel(2, "Medellín"),
        // categoría 3: Ropa
        [_allCategories.firstWhere((c) => c.id == 3)],
        3.5,
      ),
    );

    // 4. Página y Pluma — Librería
    _businesses.add(
      BusinessModel(
        104,
        "Página y Pluma",
        "Calle 9 #16-30, Cali",
        "https://example.com/logos/pagina_pluma.png",
        [
          LinkModel(8, "https://facebook.com/paginaypluma", "Facebook"),
          LinkModel(9, "https://instagram.com/paginaypluma", "Instagram"),
        ],
        UbicationModel(3, "Cali"),
        // categoría 4: Librería
        [_allCategories.firstWhere((c) => c.id == 4)],
        3.5,
      ),
    );

    // 5. FitLife — Gimnasio
    _businesses.add(
      BusinessModel(
        105,
        "FitLife",
        "Av. Simón Bolívar #5-50, Barranquilla",
        "https://example.com/logos/fitlife.png",
        [
          LinkModel(10, "https://facebook.com/fitlifebaq", "Facebook"),
          LinkModel(11, "https://instagram.com/fitlifebaq", "Instagram"),
        ],
        UbicationModel(4, "Barranquilla"),
        // categoría 5: Gimnasio
        [_allCategories.firstWhere((c) => c.id == 5)],
        3.5,
      ),
    );

    // 6. Rutas y Destinos — Agencia de Viajes
    _businesses.add(
      BusinessModel(
        106,
        "Rutas y Destinos",
        "Carrera 15 #8-90, Cartagena",
        "https://example.com/logos/rutas_destinos.png",
        [
          LinkModel(12, "https://facebook.com/rutasy_destinos", "Facebook"),
          LinkModel(13, "https://instagram.com/rutasy_destinos", "Instagram"),
          LinkModel(
            14,
            "https://linkedin.com/company/rutasy_destinos",
            "LinkedIn",
          ),
        ],
        UbicationModel(5, "Cartagena"),
        // categoría 6: Agencia de Viajes
        [_allCategories.firstWhere((c) => c.id == 6)],
        3.5,
      ),
    );

    // 7. TechConexión — Electrónica
    _businesses.add(
      BusinessModel(
        107,
        "TechConexión",
        "Diagonal 20 #30-15, Bucaramanga",
        "https://example.com/logos/techconexion.png",
        [
          LinkModel(15, "https://facebook.com/techconexion", "Facebook"),
          LinkModel(16, "https://instagram.com/techconexion", "Instagram"),
          LinkModel(17, "https://twitter.com/techconexion", "Twitter"),
        ],
        UbicationModel(6, "Bucaramanga"),
        // categoría 7: Electrónica
        [_allCategories.firstWhere((c) => c.id == 7)],
        3.5,
      ),
    );
  }

  /// Retorna la lista de todas las categorías disponibles.
  List<CategoryModel> getAllCategories() {
    // Devuelve copia si no quieres exponer la lista interna:
    return List<CategoryModel>.from(_allCategories);
  }

  /// Crea un nuevo negocio en memoria, asignándole un ID automáticamente.
  BusinessModel create(BusinessModel business) {
    // Asignar ID único
    business.id = _nextBusinessId;
    _nextBusinessId++;
    _businesses.add(business);
    return business;
  }

  /// Devuelve todos los negocios (copia).
  List<BusinessModel> getAll() {
    return List<BusinessModel>.from(_businesses);
  }

  /// Filtra negocios que tengan alguna categoría con nombre que contenga 'categoryName' (case-insensitive).
  List<BusinessModel> filterByCategoryName(String categoryName) {
    final key = categoryName.toLowerCase();
    return _businesses.where((b) {
      return b.categories.any((cat) => cat.name.toLowerCase().contains(key));
    }).toList();
  }

  /// Filtra negocios que tengan la categoría con el ID dado.
  List<BusinessModel> filterByCategoryId(int categoryId) {
    return _businesses.where((b) {
      return b.categories.any((cat) => cat.id == categoryId);
    }).toList();
  }

  /// Obtiene un negocio por ID. Lanza Exception si no existe.
  BusinessModel get(int id) {
    try {
      return _businesses.firstWhere((b) => b.id == id);
    } catch (e) {
      throw Exception('Business con id=$id no encontrado');
    }
  }

  /// Actualiza un negocio dado su ID. Retorna el negocio actualizado o lanza Exception.
  BusinessModel update(int id, BusinessModel business) {
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
