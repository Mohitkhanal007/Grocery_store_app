import 'package:json_annotation/json_annotation.dart';
import 'package:grocerystore/features/notification/domain/entity/notification_entity.dart';

part 'notification_api_model.g.dart';

@JsonSerializable()
class NotificationApiModel {
  @JsonKey(name: '_id')
  final String id;

  @JsonKey(name: 'userId')
  final String userId;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'read')
  final bool read;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'metadata')
  final Map<String, dynamic>? metadata;

  @JsonKey(name: 'createdAt')
  final String createdAt;

  @JsonKey(name: 'updatedAt')
  final String updatedAt;

  const NotificationApiModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.read,
    required this.type,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationApiModelToJson(this);

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      userId: userId,
      message: message,
      read: read,
      type: type,
      metadata: metadata,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  factory NotificationApiModel.fromEntity(NotificationEntity entity) {
    return NotificationApiModel(
      id: entity.id,
      userId: entity.userId,
      message: entity.message,
      read: entity.read,
      type: entity.type,
      metadata: entity.metadata,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
    );
  }
}
