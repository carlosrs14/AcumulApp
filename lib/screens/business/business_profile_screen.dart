import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/screens/business/update_info_screen.dart';
import 'package:acumulapp/screens/category_business_screen.dart';
import 'package:acumulapp/screens/login_screen.dart';
import 'package:acumulapp/screens/qr_scaneer.dart';
import 'package:acumulapp/screens/theme_provider.dart';
import 'package:acumulapp/utils/categories_icons.dart';
import 'package:acumulapp/utils/jwt.dart';
import 'package:acumulapp/utils/redes_icons.dart';
import 'package:acumulapp/utils/theme_mode_dialog.dart';
import 'package:acumulapp/widgets/links_form.dart';
import 'package:acumulapp/widgets/links_redes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:localstorage/localstorage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class BusinessProfileScreen extends StatefulWidget {
  final Collaborator user;
  final int selectedIndex;
  const BusinessProfileScreen({
    super.key,
    required this.user,
    required this.selectedIndex,
  });

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  final BusinessProvider _businessProvider = BusinessProvider();
  late Future<Business?> _businessFuture;
  int indexSelected = 0;

  @override
  void initState() {
    super.initState();
    _businessFuture = _businessProvider.get(
      widget.user.business[indexSelected].id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mi negocio')),
      body: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<Business?>(
              future: _businessFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Error al cargar el perfil del negocio.'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _businessFuture = _businessProvider.get(
                                widget.user.business[indexSelected].id,
                              );
                            });
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                } else {
                  final business = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 60),
                              Center(child: imagenUser(business)),
                              const SizedBox(height: 20),
                              Center(
                                child: Text(
                                  business.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      business.direction ?? "Sin dirección",
                                      style: const TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 5),

                                  Flexible(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      business.ratingAverage.toString(),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              //const Divider(),
                              //_buildLinks(business.links!),
                              const Divider(),
                              CategoryGrid(categories: business.categories!),
                              SizedBox(height: 30),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(business.descripcion ?? " "),
                                      ],
                                    ),
                                  ),

                                  SocialButtonsColumn(
                                    buttons: business.links!
                                        .map(
                                          (l) => SocialButton(
                                            icon:
                                                iconosRedes[normalize(
                                                  l.redSocial,
                                                )] ??
                                                MdiIcons.web,
                                            url: l.url,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 75),
                    ],
                  );
                }
              },
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: SpeedDial(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              direction: SpeedDialDirection.right,
              icon: MdiIcons.pencil,
              children: [
                SpeedDialChild(
                  child: Icon(MdiIcons.palette),
                  onTap: customizeTheme,
                ),
                SpeedDialChild(
                  child: Icon(MdiIcons.accountEdit),
                  onTap: () async {
                    final business = await _businessFuture;
                    if (!mounted || business == null) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => UpdateInfoScreen(
                          user: widget.user,
                          business: business,
                        ),
                      ),
                    );
                    setState(() {
                      _businessFuture = _businessProvider.get(
                        widget.user.business[indexSelected].id,
                      );
                    });
                  },
                ),
                SpeedDialChild(
                  child: Icon(MdiIcons.paletteAdvanced),
                  onTap: () async {
                    await showThemeModeDialog(context);
                  },
                ),
                SpeedDialChild(
                  child: Icon(MdiIcons.link),
                  onTap: () async {
                    final business = await _businessFuture;
                    if (!mounted || business == null) return;
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SocialLinksForm(business: business),
                      ),
                    );
                    setState(() {
                      _businessFuture = _businessProvider.get(
                        widget.user.business[indexSelected].id,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: SpeedDial(
              direction: SpeedDialDirection.up,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              icon: MdiIcons.qrcodeScan,
              children: [
                SpeedDialChild(
                  child: Icon(MdiIcons.stamper),
                  label: 'Add Stamps',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            QRScannerPage(funcionalidad: "Add Stamps"),
                      ),
                    );
                  },
                ),
                SpeedDialChild(
                  child: Icon(MdiIcons.walletGiftcard),
                  label: 'Redeem Card',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            QRScannerPage(funcionalidad: "Redeem Card"),
                      ),
                    );
                  },
                ),
                SpeedDialChild(
                  child: Icon(MdiIcons.toggleSwitch),
                  label: 'Activate Card',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            QRScannerPage(funcionalidad: "Activate Card"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(top: 16, right: 16, child: buttomSignOut()),
        ],
      ),
    );
  }

  Widget imagenUser(Business business) {
    return SizedBox(
      width: 120,
      height: 120,
      child: ClipOval(
        child: Image.network(
          business.logoIconoUrl ?? ' ',
          fit: BoxFit.cover,
          width: 120,
          height: 120,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // si falla, mostramos círculo con borde y letra inicial
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  business.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 40,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void customizeTheme() {
    Color selectedColor = Theme.of(context).colorScheme.primary;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecciona un color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
              enableAlpha: false,
              displayThumbColor: true,
              showLabel: true,
              pickerAreaHeightPercent: 0.7,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Aplicar'),
              onPressed: () {
                final brightness = Theme.of(context).brightness;
                final currentMode = brightness == Brightness.dark
                    ? ThemeMode.dark
                    : ThemeMode.light;
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).setPrimaryColor(selectedColor, currentMode);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buttomSignOut() {
    return TextButton.icon(
      onPressed: () {
        JwtController(localStorage).clearCache();

        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => InicioLogin()),
          (Route<dynamic> route) => false,
        );
      },
      icon: Icon(
        MdiIcons.logout,
        color: Theme.of(context).colorScheme.primary,
        size: 20,
      ),
      iconAlignment: IconAlignment.end,
      label: Text(
        "Sign out",
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
