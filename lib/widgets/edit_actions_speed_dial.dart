import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditActionsSpeedDial extends StatelessWidget {
  final VoidCallback onCustomizeTheme;
  final VoidCallback onEditAccount;
  final VoidCallback onShowThemeModeDialog;
  final VoidCallback onEditLinks;

  const EditActionsSpeedDial({
    super.key,
    required this.onCustomizeTheme,
    required this.onEditAccount,
    required this.onShowThemeModeDialog,
    required this.onEditLinks,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      direction: SpeedDialDirection.right,
      icon: MdiIcons.pencil,
      children: [
        SpeedDialChild(
          child: Icon(MdiIcons.palette),
          onTap: onCustomizeTheme,
        ),
        SpeedDialChild(
          child: Icon(MdiIcons.accountEdit),
          onTap: onEditAccount,
        ),
        SpeedDialChild(
          child: Icon(MdiIcons.paletteAdvanced),
          onTap: onShowThemeModeDialog,
        ),
        SpeedDialChild(
          child: Icon(MdiIcons.link),
          onTap: onEditLinks,
        ),
      ],
    );
  }
}
