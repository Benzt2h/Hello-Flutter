import 'package:flutteronline/redux/profile/profileAction.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
class ProfileState extends Equatable {
  final Map<String, dynamic> profile;

  ProfileState(
      {/*this.profile = const {
        'email': "testemail",
        "name": "benz",
        "role": "test"
      }*/
      this.profile});

  ProfileState copyWith({final Map<String, dynamic> profile}) {
    return ProfileState(profile: profile ?? this.profile);
  }

  @override
  List<Object> get props => [profile];
}

profileReducer(ProfileState state, dynamic action) {
  if (action is GetProfileAction) {
    return state.copyWith(profile: action.profileState.profile);
  }
  return state;
}
