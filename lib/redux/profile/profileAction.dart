import 'package:flutteronline/redux/profile/profileReducer.dart';
import 'package:meta/meta.dart';

@immutable
class GetProfileAction {
  final ProfileState profileState;

  GetProfileAction(this.profileState);
}

getProfileAction(Map profile) {
  return GetProfileAction(ProfileState(profile: profile));
}
