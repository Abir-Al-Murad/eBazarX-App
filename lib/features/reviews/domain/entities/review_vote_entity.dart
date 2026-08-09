import 'package:equatable/equatable.dart';

class ReviewVoteEntity extends Equatable {
  final String reviewId;
  final String voteType;

  const ReviewVoteEntity({
    required this.reviewId,
    required this.voteType,
  });

  @override
  List<Object?> get props => [
    reviewId,
    voteType,
  ];
}