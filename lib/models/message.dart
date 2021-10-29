import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message extends Equatable {
  final String? id;
  final String message;
  final double latitude;
  final double longitude;

  const Message({
    this.id,
    required this.message,
    required this.latitude,
    required this.longitude,
  });

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
}
