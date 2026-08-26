import "package:flutter/material.dart";
import "package:flutter_common_classes/extensions/theme_extension.dart";
import "package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart";
import "package:responsive_builder/responsive_builder.dart";

import "../../../../../core/gen/adobe_fonts.dart";
import "../../../../../core/gen/assets.gen.dart";
import "../invitation/sections/invitation_header.dart";

/// Widget that displays a masonry grid of images of the couple.
class HistoryMasonryImagesSection extends StatelessWidget {
  /// Creates an [HistoryMasonryImagesSection] instance.
  const HistoryMasonryImagesSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          image: DecorationImage(
            image: Assets.images.couple.hug.provider(),
            fit: BoxFit.cover,
            alignment: Alignment.center,
            opacity: 0.3,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: getValueForScreenType<double>(
            context: context,
            mobile: 16,
            tablet: 32,
            desktop: 48,
          ),
          vertical: getValueForScreenType<double>(
            context: context,
            mobile: 24,
            tablet: 36,
            desktop: 48,
          ),
        ),
        child: Column(
          children: [
            Center(
              child: StaggeredGrid.count(
                crossAxisCount: 10,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  StaggeredGridTile.count(
                    crossAxisCellCount: 6,
                    mainAxisCellCount: 3,
                    child: _buildImage(Assets.images.couple.view),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 4,
                    mainAxisCellCount: 4.8,
                    child: _buildImage(Assets.images.couple.masonry.masonry5),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 3,
                    mainAxisCellCount: 4,
                    child: _buildImage(Assets.images.couple.masonry.masonry3),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 3,
                    mainAxisCellCount: 4,
                    child: _buildImage(Assets.images.couple.masonry.masonry2),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 4,
                    mainAxisCellCount: 2.2,
                    child: _buildImage(Assets.images.couple.masonry.masonry4),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 4,
                    mainAxisCellCount: 5,
                    child: _buildImage(Assets.images.couple.masonry.masonry1),
                  ),
                  StaggeredGridTile.count(
                    crossAxisCellCount: 6,
                    mainAxisCellCount: 5,
                    child: _buildImage(Assets.images.couple.masonry.masonry6),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getValueForScreenType<double>(
                context: context,
                mobile: 16,
                tablet: 32,
                desktop: 48,
              ),
            ),
            const InvitationHeader(
              alternativeImage: true,
            ),
            SizedBox(
              height: getValueForScreenType<double>(
                context: context,
                mobile: 16,
                tablet: 32,
                desktop: 48,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 700,
              ),
              child: Text(
                "Un pequeño pedacito de nuestra historia, antes de comenzar juntos un nuevo capítulo.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getValueForScreenType<double>(
                    context: context,
                    mobile: 28,
                    tablet: 60,
                    desktop: 60,
                  ),
                  fontFamily: AdobeFonts.altesse,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildImage(AssetGenImage asset) => ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: asset.image(
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
      );
}
