class NetworkEndPoints {
  /// Customer End
  static String login = 'customer/login';
  static String register = 'customer/register';
  static String verifyOTP = 'customer/verify/otp';
  static String changepassword = 'customer/change/password';
  static String getProfile = "customer/profile";
  static String getCatergories = "customer/categories";
  static String getForms = "customer/categories/form";
  static String getReports = "customer/reports";
  static String showReports = "customer/reports/show";
  static String createReport = "customer/categories/report";
  static String getStats = 'customer/statistics';
  static String socialLogin = 'customer/social/login';
  static String getSupplements = 'customer/supplements';
  static String getDoctors = 'customer/doctors';
  static String getDoctorDetail = 'customer/doctors/show';
  static String getRecommendations = 'customer/reports/recommendation';

/////
  static String resendOTP = 'customer/resend/otp';
  static String logoutCustomer = 'customer/logout';
  static String deleteAccount = 'customer/delete/account';
  static String exploreFeeds = 'customer/explore-feeds';
  static String editProfile = 'customer/profile/update';
  static String getAllMatches = 'customer/matches';
  static String unmatch = 'customer/matches/un-match';
  static String follow = 'customer/follow';
  static String updateAnswers = 'customer/question-answers/upload';
  static String getVenues = 'customer/venues';
  static String bookTable = 'customer/venues/book-table';
  static String forgotPassword = "customer/forgot";
  static String addCard = "customer/cards/add";
  static String cardList = "customer/cards";
  static String defaultCard = "customer/cards/default";
  static String deleteCard = "customer/cards/delete";
  static String getQuestions = 'customer/question-answers';
  static String getAllChats = 'customer/chats';
  static String getNotifications = 'customer/notifications';
  static String blockUser = 'customer/blocks/add';
  static String getBlockUsers = 'customer/blocks';
  static String unblockUser = 'customer/blocks/unblock';
  static String uploadMsgFile = 'customer/messages/upload';
  static String unblockAllUsers = 'customer/blocks/unblock-all';
}
