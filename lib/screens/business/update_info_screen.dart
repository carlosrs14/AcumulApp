import 'dart:developer';

import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/category.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/image_upload.dart';
import 'package:acumulapp/models/ubication.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/providers/category_provider.dart';
import 'package:acumulapp/screens/business/business_main_screen.dart';
import 'package:acumulapp/screens/category_selector_screen.dart';
import 'package:acumulapp/screens/logo_app.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateInfoScreen extends StatefulWidget {
  final Collaborator user;
  const UpdateInfoScreen({super.key, required this.user});

  @override
  State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  File? _imagen;
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  CategoryProvider categoryProvider = CategoryProvider();
  BusinessProvider businessProvider = BusinessProvider();
  List<Category> _allCategories = [];
  List<Category> _selectedIds = [];
  bool _isLoadingCategories = true;
  bool _errorCategories = false;

  @override
  void initState() {
    _loadCategories();
    super.initState();
  }

  TextEditingController nameTextEditting = TextEditingController();
  TextEditingController logoTextEditting = TextEditingController();
  TextEditingController emailTextEditting = TextEditingController();
  TextEditingController addressTextEditting = TextEditingController();

  Future<void> _seleccionarImagen() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      // Detectar la versión de Android
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13+

        status = await Permission.photos.request();
      } else {
        // Android 12 o menor
        status = await Permission.storage.request();
      }
    } else {
      // iOS y otros
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? imagenSeleccionada = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (imagenSeleccionada != null) {
        setState(() {
          _imagen = File(imagenSeleccionada.path);
        });
      }
    } else if (status.isDenied) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Permiso denegado")));
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _loadCategories() async {
    if (!mounted) return;
    setState(() {
      _isLoadingCategories = true;
      _errorCategories = false;
    });
    try {
      final lista = await categoryProvider.all();
      if (!mounted) return;
      setState(() {
        _allCategories = lista;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorCategories = true;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cuerpo());
  }

  Widget cuerpo() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Center(child: LogoApp()),

                      SizedBox(height: 40),
                      name("Business name"),
                      textFile(nameTextEditting, 3, false, false),
                      name("Email"),
                      textFile(emailTextEditting, 2, true, false),

                      name("Address"),
                      textFile(addressTextEditting, 5, false, false),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _isLoadingCategories
                            ? const Center(child: CircularProgressIndicator())
                            : CategorySelector(
                                categories: _allCategories,
                                selectedIds: _selectedIds,
                                onChanged: (newSelected) {
                                  setState(() {
                                    _selectedIds = newSelected;
                                  });
                                },
                              ),
                      ),
                      SizedBox(height: 20),
                      Center(child: botonSelectImage()),
                      SizedBox(height: 20),
                      _imagen != null
                          ? Center(
                              child: Image.file(
                                _imagen!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(child: Text("No hay imagen seleccionada")),
                      SizedBox(height: 20),
                      botonEntrar(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget name(String name) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(name, style: TextStyle(fontSize: 15)),
    );
  }

  Widget textFile(
    TextEditingController controller,
    int minimumQuantity,
    bool email,
    bool password,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: TextFormField(
        obscureText: password,
        controller: controller,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Este campo es obligatorio';
          } else if (value.length < minimumQuantity) {
            return 'Requiere una cantidad minima de $minimumQuantity caracteres';
          } else if (email &&
              !(value.contains("@") && value.contains(".com"))) {
            return 'Debe ser un correo';
          }
          return null;
        },
      ),
    );
  }

  Widget botonSelectImage() {
    return ElevatedButton(
      onPressed: _seleccionarImagen,
      child: Text("Seleccionar logo"),
    );
  }

  Widget botonEntrar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            await Future.delayed(Duration(milliseconds: 100));
            _scrollController.animateTo(
              0.0,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            return;
          }

          late Business businessRequest;
          Business? businessResponse;
          Ubication ubication = Ubication(2, "nose");
          Collaborator colab = widget.user;
          var indice = colab.roles.indexWhere(
            (roles) => "owner" == roles.toLowerCase(),
          );
          log(indice.toString());

          if (_imagen != null) {
            ImageUpload? imageUploadResponse;
            imageUploadResponse = await businessProvider.uploadImage(_imagen!);

            if (imageUploadResponse != null) {
              if (indice != -1) {
                businessRequest = Business(
                  colab.business[indice].id,
                  nameTextEditting.text,
                  email: emailTextEditting.text,
                  ubication: ubication,
                  logoUrl: imageUploadResponse.url,
                  direction: addressTextEditting.text,
                  categories: _selectedIds,
                );

                businessResponse = await businessProvider.update(
                  businessRequest,
                );
                if (!mounted) return;
                if (businessResponse != null) {
                  bool state = await businessProvider.updateCategories(
                    businessRequest,
                  );
                  if (state) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Update sucefull',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => BusinessMainScreen(user: widget.user),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error de conexion',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.redAccent,
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              }
            }
            ;
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Selecciona una imagen',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },

        child: Text("Update info", style: TextStyle(fontSize: 15)),
      ),
    );
  }
}
