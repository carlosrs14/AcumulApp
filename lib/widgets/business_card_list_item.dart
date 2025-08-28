import 'package:acumulapp/models/card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BusinessCardListItem extends StatelessWidget {
  final BusinessCard card;
  final VoidCallback onEdit;
  final VoidCallback onArchive;  const BusinessCardListItem({super.key, required this.card, required this.onEdit, required this.onArchive,});
  @override  
  Widget build(BuildContext context) {    
    String archivarText = card.isActive ? "Archivar" : "Desarchivar";
    return Card(      
      elevation: 4,      
      margin: const EdgeInsets.symmetric(        
        horizontal: 12,        
        vertical: 8,      
      ),      
      shape: RoundedRectangleBorder(        
        borderRadius: BorderRadius.circular(12),        
        side: BorderSide(          
          color: Theme.of(context).colorScheme.primary,        
        ),      
      ),      
      child: Column(        
        crossAxisAlignment: CrossAxisAlignment.center,        
        children: [          
          Padding(            
            padding: const EdgeInsets.only(              
              top: 15,              
              bottom: 6,            
            ),           
            child: Text(              
              card.name,              
              style: TextStyle(                
                fontSize: 18,                
                fontWeight: FontWeight.bold,                
                color: Theme.of(context).colorScheme.primary,              
                ),            
              ),         
          ),          
          const SizedBox(height: 12),          
          _buildDetailRow(            
            context,            
            Icons.stars,            
            "Bounty: ${card.reward}",          
          ),          
          const SizedBox(height: 12),         
          _buildDetailRow(            
            context,            
            MdiIcons.stamper,            
            "MaxStamp: ${card.maxStamp}",          
          ),          
          const SizedBox(height: 12),          
          _buildDetailRow(            
              context,            
              Icons.info_outline,            
              "Restricciones: ${card.restrictions}",          
          ),          
          const SizedBox(height: 12),          
          _buildDetailRow(            
              context,            
              MdiIcons.comment,            
              "Descripcion: \n${card.description}",          
          ),          
          const SizedBox(height: 16),          
          _buildActionButtons(context, "Editar", archivarText),        
        ],     
      ),    
    );  
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String text) {    
    return Padding(      
      padding: const EdgeInsets.symmetric(        
        horizontal: 15,      
      ),      
      child: Row(        
        crossAxisAlignment: CrossAxisAlignment.start,        
        children: [          
          Icon(            
            icon,            
            size: 18,            
            color: Colors.grey[700],          
          ),          
          const SizedBox(width: 4),          
          Expanded(            
            child: Text(              
              text,              
              style: const TextStyle(fontSize: 14),            
            ),          
          ),        
        ],      
      ),    
      );  
    }  

  Widget _buildActionButtons(      
    BuildContext context, String editText, String archiveText) {    
    return Row(      
      children: [        
        Expanded(          
          child: ElevatedButton.icon(            
            onPressed: onEdit,            
            style: ElevatedButton.styleFrom(              
              minimumSize: const Size.fromHeight(48),              
              backgroundColor: Theme.of(context).colorScheme.primary,              
              foregroundColor: Theme.of(context).colorScheme.onPrimary,              
              shape: const RoundedRectangleBorder(                
                borderRadius: BorderRadius.only(                  
                  bottomLeft: Radius.circular(12),                
                ),              
              ),              
              textStyle: const TextStyle(                
                fontSize: 16,                
                fontWeight: FontWeight.bold,              
              ),              
              elevation: 0,           
            ),            
            icon: const Icon(Icons.edit),            
            label: Text(editText),          
          ),        
        ),        
        Container(         
          width: 1,          
          height: 48,          
          color: Theme.of(context).colorScheme.onPrimary,        
        ),        
        Expanded(          
          child: ElevatedButton.icon(            
            onPressed: onArchive,            
            style: ElevatedButton.styleFrom(              
              minimumSize: const Size.fromHeight(48),              
              backgroundColor: Theme.of(context).colorScheme.primary,              
              foregroundColor: Theme.of(context).colorScheme.onPrimary,              
              shape: const RoundedRectangleBorder(                
                borderRadius: BorderRadius.only(                  
                  bottomRight: Radius.circular(12),                
                ),
              ),
              textStyle: const TextStyle(               
                fontSize: 16,                
                fontWeight: FontWeight.bold,              
              ), 
              elevation: 0,            
            ),         
            icon: const Icon(Icons.archive),            
            label: Text(archiveText),          
            ),
          ),
      ],
    );
  }
}