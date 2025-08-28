import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/collaborator.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/screens/business/update_info_screen.dart';
import 'package:acumulapp/utils/theme_mode_dialog.dart';
import 'package:acumulapp/widgets/links_form.dart';
import 'package:acumulapp/widgets/qr_scanner_speed_dial.dart';
import 'package:acumulapp/widgets/edit_actions_speed_dial.dart';
import 'package:acumulapp/widgets/business_profile_details.dart';
import 'package:acumulapp/widgets/sign_out_button.dart';
import 'package:acumulapp/utils/theme_utils.dart';
import 'package:flutter/material.dart';

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
                  return BusinessProfileDetails(business: business);
                }
              },
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: EditActionsSpeedDial(
              onCustomizeTheme: () => showColorPicker(context),
              onEditAccount: () async {
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
              onShowThemeModeDialog: () async {
                await showThemeModeDialog(context);
              },
              onEditLinks: () async {
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
          ),
          const Positioned(
            bottom: 16,
            right: 16,
            child: QrScannerSpeedDial(),
          ),
          Positioned(top: 16, right: 16, child: const SignOutButton()),
        ],
      ),
    );
  }
}
