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
  final Business? business;
  const UpdateInfoScreen({
    super.key,
    required this.user,
    required this.business,
  });

  @override
  State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  File? _imagenLogo;
  File? _imagenBanner;
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
    if (widget.business != null) {
      nameTextEditting.text = widget.business!.name ?? "";
      emailTextEditting.text = widget.business!.email ?? "";
      addressTextEditting.text = widget.business!.direction ?? "";
      descripcionTextEdittig.text = widget.business!.descripcion ?? "";

      if (widget.business!.categories != null) {
        _selectedIds = (widget.business!.categories) ?? [];
      }
      super.initState();
    }
  }

  TextEditingController nameTextEditting = TextEditingController();
  TextEditingController logoTextEditting = TextEditingController();
  TextEditingController emailTextEditting = TextEditingController();
  TextEditingController addressTextEditting = TextEditingController();
  TextEditingController descripcionTextEdittig = TextEditingController();

  Future<void> _seleccionarImagen(int i) async {
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
    if (!mounted) return;

    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final XFile? imagenSeleccionada = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (imagenSeleccionada != null) {
        setState(() {
          if (i == 1) {
            _imagenLogo = File(imagenSeleccionada.path);
          } else if (i == 2) {
            _imagenBanner = File(imagenSeleccionada.path);
          }
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
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingCategories
          ? Center(child: CircularProgressIndicator())
          : _errorCategories
          ? Center(child: Text("Error de conexion"))
          : cuerpo(),
    );
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
                      textFile(nameTextEditting, 3, false, false, false),
                      name("Email"),
                      textFile(emailTextEditting, 2, true, false, false),

                      name("Direccion"),
                      textFile(addressTextEditting, 5, false, false, false),
                      name("Descripcion(Opcional)"),
                      textFile(descripcionTextEdittig, 0, false, false, true),
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
                      Center(child: botonSelectImage(1, "Seleccionar logo")),
                      SizedBox(height: 20),
                      _imagenLogo != null
                          ? Center(
                              child: Image.file(
                                _imagenLogo!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Center(child: Text("No hay imagen seleccionada")),
                      SizedBox(height: 20),
                      Center(child: botonSelectImage(2, "Seleccionar banner")),
                      SizedBox(height: 20),
                      _imagenBanner != null
                          ? Center(
                              child: Image.file(
                                _imagenBanner!,
                                width: 300,
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
    bool opcional,
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
          if (opcional) {
            return null;
          }
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

  Widget botonSelectImage(int i, String texto) {
    return ElevatedButton(
      onPressed: () => _seleccionarImagen(i),
      child: Text(texto),
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

          Collaborator colab = widget.user;
          var indice = colab.roles.indexWhere(
            (roles) => "owner" == roles.toLowerCase(),
          );
          log(indice.toString());
          ImageUpload? imageLogoResponse;
          ImageUpload? imageBannerResponse;
          if (_imagenLogo != null) {
            imageLogoResponse = await businessProvider.uploadImage(
              _imagenLogo!,
            );
          }

          if (_imagenBanner != null) {
            imageBannerResponse = await businessProvider.uploadImage(
              _imagenBanner!,
            );
          }

          if (indice != -1) {
            businessRequest = Business(
              colab.business[indice].id,
              nameTextEditting.text,
              email: emailTextEditting.text,
              descripcion: descripcionTextEdittig.text,
              logoIconoUrl: imageLogoResponse?.url,
              logoBannerImage: imageBannerResponse?.url,
              direction: addressTextEditting.text,
              categories: _selectedIds,
            );

            businessResponse = await businessProvider.update(businessRequest);
            if (!mounted) return;
            if (businessResponse != null) {
              bool state = await businessProvider.updateCategories(
                businessRequest,
              );
              if (!mounted) return;
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

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => BusinessMainScreen(user: widget.user),
                  ),
                  (route) => false,
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
        },

        child: Text("Update info", style: TextStyle(fontSize: 15)),
      ),
    );
  }
}
