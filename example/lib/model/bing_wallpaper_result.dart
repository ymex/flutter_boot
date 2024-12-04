import 'package:json_annotation/json_annotation.dart';

part 'bing_wallpaper_result.g.dart';

@JsonSerializable()
class BingWallpaperResult {
  @JsonKey(defaultValue: [])
  final List<Images> images;
  final Tooltips? tooltips;

  const BingWallpaperResult({
    required this.images,
    this.tooltips,
  });

  factory BingWallpaperResult.fromJson(Map<String, dynamic> json) =>
      _$BingWallpaperResultFromJson(json);

  Map<String, dynamic> toJson() => _$BingWallpaperResultToJson(this);
}

@JsonSerializable()
class Images {
  @JsonKey(defaultValue: '')
  final String startdate;
  @JsonKey(defaultValue: '')
  final String fullstartdate;
  @JsonKey(defaultValue: '')
  final String enddate;
  @JsonKey(defaultValue: '')
  final String url;
  @JsonKey(defaultValue: '')
  final String urlbase;
  @JsonKey(defaultValue: '')
  final String copyright;
  @JsonKey(defaultValue: '')
  final String copyrightlink;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String quiz;
  @JsonKey(defaultValue: false)
  final bool wp;
  @JsonKey(defaultValue: '')
  final String hsh;
  @JsonKey(defaultValue: 0)
  final int drk;
  @JsonKey(defaultValue: 0)
  final int top;
  @JsonKey(defaultValue: 0)
  final int bot;
  @JsonKey(defaultValue: [])
  final List<dynamic> hs;

  const Images({
    required this.startdate,
    required this.fullstartdate,
    required this.enddate,
    required this.url,
    required this.urlbase,
    required this.copyright,
    required this.copyrightlink,
    required this.title,
    required this.quiz,
    required this.wp,
    required this.hsh,
    required this.drk,
    required this.top,
    required this.bot,
    required this.hs,
  });

  factory Images.fromJson(Map<String, dynamic> json) =>
      _$ImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class Tooltips {
  @JsonKey(defaultValue: '')
  final String loading;
  @JsonKey(defaultValue: '')
  final String previous;
  @JsonKey(defaultValue: '')
  final String next;
  @JsonKey(defaultValue: '')
  final String walle;
  @JsonKey(defaultValue: '')
  final String walls;

  const Tooltips({
    required this.loading,
    required this.previous,
    required this.next,
    required this.walle,
    required this.walls,
  });

  factory Tooltips.fromJson(Map<String, dynamic> json) =>
      _$TooltipsFromJson(json);

  Map<String, dynamic> toJson() => _$TooltipsToJson(this);
}
