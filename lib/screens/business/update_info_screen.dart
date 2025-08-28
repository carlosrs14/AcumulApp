import 'dart:developer';

import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/category.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/models/image_upload.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/providers/category_provider.dart';
import 'package:acumulapp/screens/business/business_main_screen.dart';
import 'package:acumulapp/widgets/category_selector_screen.dart';
import 'package:acumulapp/widgets/custom_text_form_field.dart';
import 'package:acumulapp/widgets/image_picker_button.dart';
import 'package:acumulapp/widgets/logo_app.dart';
import 'package:acumulapp/widgets/section_title.dart';
import 'package:acumulapp/widgets/submit_button.dart';
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
  final CategoryProvider categoryProvider = CategoryProvider();
  final BusinessProvider businessProvider = BusinessProvider();
  List<Category> _allCategories = [];
  List<Category> _selectedIds = [];
  bool _isLoadingCategories = true;
  bool _errorCategories = false;

  final TextEditingController nameTextEditting = TextEditingController();
  final TextEditingController emailTextEditting = TextEditingController();
  final TextEditingController addressTextEditting = TextEditingController();
  final TextEditingController descripcionTextEdittig = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.business != null) {
      nameTextEditting.text = widget.business!.name;
      emailTextEditting.text = widget.business!.email ?? "";
      addressTextEditting.text = widget.business!.direction ?? "";
      descripcionTextEdittig.text = widget.business!.descripcion ?? "";

      if (widget.business!.categories != null) {
        _selectedIds = (widget.business!.categories) ?? [];
      }
    }
  }

  Future<void> _seleccionarImagen(int i) async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
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
      ).showSnackBar(const SnackBar(content: Text("Permiso denegado")));
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

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
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
      if (widget.business == null) {
        businessRequest = Business(
          colab.business[indice].id,
          nameTextEditting.text,
          email: emailTextEditting.text,
          descripcion: descripcionTextEdittig.text,
          logoIconoUrl: imageLogoResponse?.url ?? " ",
          logoBannerImage: imageBannerResponse?.url ?? " ",
          direction: addressTextEditting.text,
          categories: _selectedIds,
        );
      } else {
        businessRequest = Business(
          colab.business[indice].id,
          nameTextEditting.text,
          email: emailTextEditting.text,
          descripcion: descripcionTextEdittig.text,
          logoIconoUrl:
              imageLogoResponse?.url ?? widget.business!.logoIconoUrl,
          logoBannerImage:
              imageBannerResponse?.url ?? widget.business!.logoIconoUrl,
          direction: addressTextEditting.text,
          categories: _selectedIds,
        );
      }

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
            const SnackBar(
              content: Text(
                'Update sucefull',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          if (widget.business == null) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => BusinessMainScreen(user: widget.user),
              ),
              (route) => false,
            );
          } else {
            Navigator.pop(context);
          }
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
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
          const SnackBar(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingCategories
          ? const Center(child: CircularProgressIndicator())
          : _errorCategories
              ? const Center(child: Text("Error de conexion"))
              : _buildBody(),
    );
  }

  Widget _buildBody() {
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
                      const SizedBox(height: 20),
                      const Center(child: LogoApp()),
                      const SizedBox(height: 40),
                      const SectionTitle(title: "Business name"),
                      CustomTextFormField(
                        controller: nameTextEditting,
                        minimumQuantity: 3,
                      ),
                      const SectionTitle(title: "Email"),
                      CustomTextFormField(
                        controller: emailTextEditting,
                        minimumQuantity: 2,
                        email: true,
                      ),
                      const SectionTitle(title: "Direccion"),
                      CustomTextFormField(
                        controller: addressTextEditting,
                        minimumQuantity: 5,
                      ),
                      const SectionTitle(title: "Descripcion"),
                      CustomTextFormField(
                        controller: descripcionTextEdittig,
                        minimumQuantity: 10,
                      ),
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
                      const SizedBox(height: 20),
                      Center(
                        child: ImagePickerButton(
                          onPressed: () => _seleccionarImagen(1),
                          text: "Seleccionar logo",
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildImagePreview(_imagenLogo),
                      const SizedBox(height: 20),
                      Center(
                        child: ImagePickerButton(
                          onPressed: () => _seleccionarImagen(2),
                          text: "Seleccionar banner",
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildImagePreview(_imagenBanner, isBanner: true),
                      const SizedBox(height: 20),
                      SubmitButton(
                        onPressed: _submitForm,
                        text: "Update info",
                      ),
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

  Widget _buildImagePreview(File? image, {bool isBanner = false}) {
    return Center(
      child: image != null
          ? Image.file(
              image,
              width: isBanner ? 300 : 200,
              height: 200,
              fit: BoxFit.cover,
            )
          : Text(
              textAlign: TextAlign.center,
              widget.business == null
                  ? "No hay imagen seleccionada"
                  : "No hay imagen seleccionada\n(se mantendrá la actual si no eliges otra)",
            ),
    );
  }
}
