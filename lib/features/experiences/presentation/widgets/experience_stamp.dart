import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/experience.dart';
import 'stamp_painter.dart';

/// Experience stamp widget with serrated edges
class ExperienceStamp extends StatelessWidget {
  final Experience experience;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;
  final double rotation; // Rotation angle in degrees

  const ExperienceStamp({
    super.key,
    required this.experience,
    required this.isSelected,
    this.isDisabled = false,
    required this.onTap,
    this.rotation = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Transform.rotate(
          angle: rotation * (3.14159 / 180), // Convert degrees to radians
          child: Container(
            width: 100,
            margin: const EdgeInsets.only(right: 20), // Increased gap between stamps
            child: _buildStampContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildStampContent() {
    // If imageUrl is available, use it directly (complete stamp image from API)
    if (experience.imageUrl != null && experience.imageUrl!.isNotEmpty) {
      final imageWidget = Image.network(
        experience.imageUrl!,
        width: 100,
        height: 140,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to custom painter if image fails to load
          return _buildCustomStamp();
        },
      );

      // Apply grayscale filter only when not selected
      if (!isSelected) {
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2126, 0.7152, 0.0722, 0, 0, // Red channel
            0.2126, 0.7152, 0.0722, 0, 0, // Green channel
            0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
            0, 0, 0, 1, 0, // Alpha channel
          ]), // Grayscale filter
          child: imageWidget,
        );
      }

      return imageWidget;
    }
    
    // Fallback to custom painter if no imageUrl
    return _buildCustomStamp();
  }

  Widget _buildCustomStamp() {
    // Stamps have solid black background with white border
    // Selected stamps can have accent color, unselected are pure black
    final stampColor = isSelected
        ? AppColors.primaryAccent // Accent color when selected
        : AppColors.base1; // Pure black when not selected

    return CustomPaint(
      painter: StampPainter(
        color: stampColor,
        borderColor: AppColors.text1,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon (using iconUrl if available, otherwise fallback)
            if (experience.iconUrl != null &&
                experience.iconUrl!.isNotEmpty)
              Builder(
                builder: (context) {
                  final iconWidget = Image.network(
                    experience.iconUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultIcon(experience.name);
                    },
                  );

                  // Apply grayscale filter only when not selected
                  if (!isSelected) {
                    return ColorFiltered(
                      colorFilter: const ColorFilter.matrix([
                        0.2126, 0.7152, 0.0722, 0, 0, // Red channel
                        0.2126, 0.7152, 0.0722, 0, 0, // Green channel
                        0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
                        0, 0, 0, 1, 0, // Alpha channel
                      ]), // Grayscale filter
                      child: iconWidget,
                    );
                  }

                  return iconWidget;
                },
              )
            else
              _buildDefaultIcon(experience.name),
            const SizedBox(height: 8),
            // Name - white text
            Text(
              experience.name.toUpperCase(),
              style: const TextStyle(
                color: AppColors.text1,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultIcon(String name) {
    IconData iconData;
    bool useCircle = false;
    
    switch (name.toUpperCase()) {
      case 'PARTY':
        iconData = Icons.music_note;
        useCircle = true; // Circular icon for PARTY
        break;
      case 'DINNER':
        iconData = Icons.restaurant;
        break;
      case 'BRUNCH':
        iconData = Icons.breakfast_dining;
        break;
      case 'PICNIC':
        iconData = Icons.park;
        break;
      case 'HOUSE PARTY':
        iconData = Icons.home;
        break;
      default:
        iconData = Icons.star;
    }
    
    if (useCircle) {
      // For PARTY, use a solid white circle
      return Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.text1,
          shape: BoxShape.circle,
        ),
      );
    } else {
      // For other icons, use filled white icons
      return Icon(
        iconData,
        color: AppColors.text1,
        size: 40,
        fill: 1.0, // Use filled version if available
      );
    }
  }
}

