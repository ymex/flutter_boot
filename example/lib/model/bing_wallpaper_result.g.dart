// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bing_wallpaper_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BingWallpaperResult _$BingWallpaperResultFromJson(Map<String, dynamic> json) =>
    BingWallpaperResult(
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tooltips: json['tooltips'] == null
          ? null
          : Tooltips.fromJson(json['tooltips'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BingWallpaperResultToJson(
        BingWallpaperResult instance) =>
    <String, dynamic>{
      'images': instance.images,
      'tooltips': instance.tooltips,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) => Images(
      startdate: json['startdate'] as String? ?? '',
      fullstartdate: json['fullstartdate'] as String? ?? '',
      enddate: json['enddate'] as String? ?? '',
      url: json['url'] as String? ?? '',
      urlbase: json['urlbase'] as String? ?? '',
      copyright: json['copyright'] as String? ?? '',
      copyrightlink: json['copyrightlink'] as String? ?? '',
      title: json['title'] as String? ?? '',
      quiz: json['quiz'] as String? ?? '',
      wp: json['wp'] as bool? ?? false,
      hsh: json['hsh'] as String? ?? '',
      drk: (json['drk'] as num?)?.toInt() ?? 0,
      top: (json['top'] as num?)?.toInt() ?? 0,
      bot: (json['bot'] as num?)?.toInt() ?? 0,
      hs: json['hs'] as List<dynamic>? ?? [],
    );

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'startdate': instance.startdate,
      'fullstartdate': instance.fullstartdate,
      'enddate': instance.enddate,
      'url': instance.url,
      'urlbase': instance.urlbase,
      'copyright': instance.copyright,
      'copyrightlink': instance.copyrightlink,
      'title': instance.title,
      'quiz': instance.quiz,
      'wp': instance.wp,
      'hsh': instance.hsh,
      'drk': instance.drk,
      'top': instance.top,
      'bot': instance.bot,
      'hs': instance.hs,
    };

Tooltips _$TooltipsFromJson(Map<String, dynamic> json) => Tooltips(
      loading: json['loading'] as String? ?? '',
      previous: json['previous'] as String? ?? '',
      next: json['next'] as String? ?? '',
      walle: json['walle'] as String? ?? '',
      walls: json['walls'] as String? ?? '',
    );

Map<String, dynamic> _$TooltipsToJson(Tooltips instance) => <String, dynamic>{
      'loading': instance.loading,
      'previous': instance.previous,
      'next': instance.next,
      'walle': instance.walle,
      'walls': instance.walls,
    };
