import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketmaster_app/domain/entities/ticket_entity.dart';
import 'package:ticketmaster_app/presentation/page/image_preview.dart';

class TicketItem extends StatelessWidget {
  final Ticket ticket;

  const TicketItem({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(DateTime.parse(ticket.date));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = screenWidth < 360;
        final double fontSize = isSmallScreen ? 13 : 14;
        final double titleSize = isSmallScreen ? 16 : 18;

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: titleSize,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ticket.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: fontSize,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        ticket.location,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.calendar_today, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                if (ticket.attachmentUrl.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.attach_file, size: 18, color: colorScheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        "Attachment available",
                        style: TextStyle(
                          fontSize: fontSize,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
if (File(ticket.attachmentUrl).existsSync())
  GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImagePreviewPage(imagePath: ticket.attachmentUrl),
        ),
      );
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.file(
        File(ticket.attachmentUrl),
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    ),
  )
else
  Text(
    "Attachment not found.",
    style: TextStyle(
      fontSize: fontSize,
      color: colorScheme.error,
    ),
  ),

                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
