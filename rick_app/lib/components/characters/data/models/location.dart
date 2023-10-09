import 'package:json_annotation/json_annotation.dart';
import 'package:rick_app/components/common/data/location_dto.dart';

part 'location.g.dart';

@JsonSerializable()
class Location implements LocationDto {
  final String name;
  final String url;

  Location({
      required this.name,
      required this.url,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}