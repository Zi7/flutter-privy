import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const String _imagePath = 'images';
const String _svgPath = 'icons';

final class AppImage {
  static const BaseImage _baseImage = BaseImage(_imagePath);

  static Image darkOr({
    BoxFit? fit,
    double? width,
    double? height,
    Color? color,
  }) => _baseImage.load(
    'darkOr.png',
    width: width,
    height: height,
    fit: fit,
    color: color,
  );
}

final class AppSvg {
  static const BaseSvg _baseSvg = BaseSvg(_svgPath);

  // Currency
  static SvgPicture icBtc({double? size, Color? color}) =>
      _baseSvg.load('btc.svg', width: size, height: size, colorFilter: color);
  static SvgPicture icEth({double? size, Color? color}) =>
      _baseSvg.load('eth.svg', width: size, height: size, colorFilter: color);
  static SvgPicture icUsd({double? size, Color? color}) =>
      _baseSvg.load('usd.svg', width: size, height: size, colorFilter: color);
  static SvgPicture icUsdt({double? size, Color? color}) =>
      _baseSvg.load('usdt.svg', width: size, height: size, colorFilter: color);
  static SvgPicture icUsdc({double? size, Color? color}) =>
      _baseSvg.load('usdc.svg', width: size, height: size, colorFilter: color);
  static SvgPicture icTrx({double? size, Color? color}) =>
      _baseSvg.load('trx.svg', width: size, height: size, colorFilter: color);
  static SvgPicture icBsc({double? size, Color? color}) =>
      _baseSvg.load('bsc.svg', width: size, height: size, colorFilter: color);
  static SvgPicture icSol({double? size, Color? color}) =>
      _baseSvg.load('sol.svg', width: size, height: size, colorFilter: color);
}

final class BaseImage {
  final String? _packageName;
  final String _imagePath;

  const BaseImage(this._imagePath, [this._packageName]);

  Image load(
    String fileName, {
    AssetBundle? bundle,
    Widget Function(BuildContext, Widget, int?, bool)? frameBuilder,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
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
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) => Image.asset(
    'assets/$_imagePath/$fileName',
    package: _packageName,
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
    filterQuality: filterQuality,
    cacheWidth: cacheWidth,
    cacheHeight: cacheHeight,
  );
}

final class BaseSvg {
  final String _svgPath;
  final String? _packageName;

  const BaseSvg(this._svgPath, [this._packageName]);

  SvgPicture load(
    String fileName, {
    bool matchTextDirection = false,
    AssetBundle? bundle,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    Widget Function(BuildContext)? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
    SvgTheme? theme,
    Color? colorFilter,
  }) => SvgPicture.asset(
    'assets/$_svgPath/$fileName',
    package: _packageName,
    matchTextDirection: matchTextDirection,
    bundle: bundle,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
    placeholderBuilder: placeholderBuilder,
    semanticsLabel: semanticsLabel,
    excludeFromSemantics: excludeFromSemantics,
    clipBehavior: clipBehavior,
    theme: theme,
    colorFilter:
        colorFilter != null
            ? ColorFilter.mode(colorFilter, BlendMode.srcIn)
            : null,
  );
}
