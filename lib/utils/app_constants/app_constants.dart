class AppConstants {
  static const String baseUrl = 'https://coin.codedebuggers.com/api';

  // static const String baseUrl = 'http://192.168.1.15:5000/api';

  static const String signup = '$baseUrl/signup';

  static const String signin = '$baseUrl/signin';
  static const String logout = '$baseUrl/logout';
  static const String profile = '$baseUrl/profile';

  static const String myReferrals = '$baseUrl/myreferrals';
  static const String claimReferralReward = '$baseUrl/claimreferral';
  static const String getreferrals = '$baseUrl/getreferrals';

  static const String userLevel = '$baseUrl/userlevel';
  static const String levelReward = '$baseUrl/levelclaim';

  static const String getDailyReward = '$baseUrl/getdailyreward';
  static const String dailyReward = '$baseUrl/claimdailyreward';
  static const String weeklyReward = '$baseUrl/claimweeklyreward';

  static const String coinTransfer = '$baseUrl/cointransfer';
  static const String wallet = '$baseUrl/Wallet';
  static const String transferHistory = '$baseUrl/transferhistory';

  static const String zicPool = '$baseUrl/zicpool';

  static const String mine = '$baseUrl/mine';

  static const String streakReward = '$baseUrl/claimstreak';
  static const String getStreakStatus = '$baseUrl/getdays';

  static const String spinWheel = '$baseUrl/claimspin';
  static const String spinwheelReward = '$baseUrl/getreward';

  static const String feedback = '$baseUrl/feedback';

  static const String tokenKey = 'token';
  static const String userKey = 'user';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String miningTimerKey = 'mining_timer_remaining';
}
