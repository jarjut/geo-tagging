import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable(includeIfNull: false)
class Message extends Equatable {
  final String? id;
  final String name;
  final String message;
  final double latitude;
  final double longitude;
  final dynamic created;

  Message({
    this.id,
    String? name,
    required this.message,
    required this.latitude,
    required this.longitude,
    dynamic created,
  })  : created = created ?? FieldValue.serverTimestamp(),
        name = name ?? 'Anonim';

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  static CollectionReference<Message> ref({
    SnapshotOptions? snapshotOptions,
    SetOptions? setOptions,
  }) {
    return FirebaseFirestore.instance
        .collection('messages')
        .withConverter<Message>(
          fromFirestore: (snapshot, snapshotOptions) =>
              Message.fromJson(snapshot.data()!),
          toFirestore: (message, setOptions) => message.toJson(),
        );
  }

  @override
  List<Object?> get props => [id, message, latitude, longitude];

  Message copyWith({
    String? id,
    String? name,
    String? message,
    double? latitude,
    double? longitude,
    dynamic created,
  }) {
    return Message(
      id: id ?? this.id,
      name: name ?? this.name,
      message: message ?? this.message,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      created: created ?? this.created,
    );
  }
}
