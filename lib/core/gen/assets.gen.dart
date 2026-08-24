// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// Directory path: assets/images/envelopes
  $AssetsImagesEnvelopesGen get envelopes => const $AssetsImagesEnvelopesGen();

  /// Directory path: assets/images/frames
  $AssetsImagesFramesGen get frames => const $AssetsImagesFramesGen();

  /// Directory path: assets/images/ribbons
  $AssetsImagesRibbonsGen get ribbons => const $AssetsImagesRibbonsGen();

  /// Directory path: assets/images/seals
  $AssetsImagesSealsGen get seals => const $AssetsImagesSealsGen();

  /// Directory path: assets/images/texts
  $AssetsImagesTextsGen get texts => const $AssetsImagesTextsGen();

  /// Directory path: assets/images/textures
  $AssetsImagesTexturesGen get textures => const $AssetsImagesTexturesGen();
}

class $AssetsImagesEnvelopesGen {
  const $AssetsImagesEnvelopesGen();

  /// File path: assets/images/envelopes/blue.png
  AssetGenImage get blue =>
      const AssetGenImage('assets/images/envelopes/blue.png');

  /// File path: assets/images/envelopes/main.png
  AssetGenImage get main =>
      const AssetGenImage('assets/images/envelopes/main.png');

  /// File path: assets/images/envelopes/pink.png
  AssetGenImage get pink =>
      const AssetGenImage('assets/images/envelopes/pink.png');

  /// List of all assets
  List<AssetGenImage> get values => [blue, main, pink];
}

class $AssetsImagesFramesGen {
  const $AssetsImagesFramesGen();

  /// File path: assets/images/frames/white.png
  AssetGenImage get white =>
      const AssetGenImage('assets/images/frames/white.png');

  /// List of all assets
  List<AssetGenImage> get values => [white];
}

class $AssetsImagesRibbonsGen {
  const $AssetsImagesRibbonsGen();

  /// File path: assets/images/ribbons/blue.png
  AssetGenImage get blue =>
      const AssetGenImage('assets/images/ribbons/blue.png');

  /// File path: assets/images/ribbons/pink.png
  AssetGenImage get pink =>
      const AssetGenImage('assets/images/ribbons/pink.png');

  /// File path: assets/images/ribbons/pink_horizontal.png
  AssetGenImage get pinkHorizontal =>
      const AssetGenImage('assets/images/ribbons/pink_horizontal.png');

  /// List of all assets
  List<AssetGenImage> get values => [blue, pink, pinkHorizontal];
}

class $AssetsImagesSealsGen {
  const $AssetsImagesSealsGen();

  /// File path: assets/images/seals/wax_seal.png
  AssetGenImage get waxSeal =>
      const AssetGenImage('assets/images/seals/wax_seal.png');

  /// List of all assets
  List<AssetGenImage> get values => [waxSeal];
}

class $AssetsImagesTextsGen {
  const $AssetsImagesTextsGen();

  /// File path: assets/images/texts/envelope_title.svg
  SvgGenImage get envelopeTitle =>
      const SvgGenImage('assets/images/texts/envelope_title.svg');

  /// List of all assets
  List<SvgGenImage> get values => [envelopeTitle];
}

class $AssetsImagesTexturesGen {
  const $AssetsImagesTexturesGen();

  /// File path: assets/images/textures/flowers.png
  AssetGenImage get flowers =>
      const AssetGenImage('assets/images/textures/flowers.png');

  /// File path: assets/images/textures/flowers_transparent.png
  AssetGenImage get flowersTransparent =>
      const AssetGenImage('assets/images/textures/flowers_transparent.png');

  /// List of all assets
  List<AssetGenImage> get values => [flowers, flowersTransparent];
}

abstract final class Assets {
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
