enum GeneralContentType { term_condition, privacy_policy }

enum RequestType { GET, POST, PUT, DELETE }

enum BrowserType { search_user, link_profile }

enum MyCallEvent {
  actionDidUpdateDevicePushTokenVoip,
  actionCallIncoming,
  actionCallStart,
  actionCallAccept,
  actionCallDecline,
  actionCallEnded,
  actionCallTimeout,
  actionCallCallback,
  actionCallToggleHold,
  actionCallToggleMute,
  actionCallToggleDmtf,
  actionCallToggleGroup,
  actionCallToggleAudioSession,
  actionCallCustom,
}

enum NotificationsType {
  video_call,
}
