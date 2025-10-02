# AI Merge Lab 🤖💰

A unique Android mobile game that combines addictive merge mechanics with AI technology themes. Build sophisticated AI systems by merging components in your futuristic lab while earning revenue through ads!

## 🎮 Game Features

- **Unique AI Theme**: Merge processors, neural networks, and AI components
- **Progressive Difficulty**: 8 different AI component levels to unlock
- **Futuristic Design**: Glowing effects and sci-fi aesthetics
- **Multiple Controls**: Swipe gestures, arrow keys, and tap controls
- **Score Tracking**: High score persistence with local storage
- **Smooth Animations**: Satisfying merge effects and transitions
- **Haptic Feedback**: Vibration support for enhanced gameplay

## 💰 Monetization Features

- **Banner Ads**: Displayed during gameplay
- **Interstitial Ads**: Shown after game over
- **Rewarded Video Ads**: Players can watch ads to get 5 extra moves
- **AdMob Integration**: Google AdMob for maximum revenue

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/kumarraviraj549/ai-game.git
   cd ai-game
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the app**:
   ```bash
   flutter run
   ```

## 🏪 Play Store Deployment

### 1. Setup App Signing

1. **Generate keystore**:
   ```bash
   keytool -genkey -v -keystore ai-merge-lab-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias ai-merge-lab-key
   ```

2. **Create key.properties**:
   ```bash
   cp android/key.properties.example android/key.properties
   ```
   
   Edit `android/key.properties` with your keystore details:
   ```properties
   storePassword=your_store_password
   keyPassword=your_key_password
   keyAlias=your_key_alias
   storeFile=../ai-merge-lab-keystore.jks
   ```

### 2. Setup AdMob

1. **Create AdMob Account**: Visit [AdMob Console](https://admob.google.com/)
2. **Create App**: Add your app to AdMob
3. **Get Ad Unit IDs**: Create banner, interstitial, and rewarded ad units
4. **Update Ad IDs**: Replace test IDs in `lib/utils/constants.dart`:
   ```dart
   // Replace with your actual Ad Unit IDs
   static const String bannerAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
   static const String interstitialAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
   static const String rewardedAdUnitId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
   ```
5. **Update App ID**: Replace in `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.gms.ads.APPLICATION_ID"
       android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
   ```

### 3. Build for Release

1. **Build App Bundle** (Recommended for Play Store):
   ```bash
   flutter build appbundle --release
   ```

2. **Build APK** (Alternative):
   ```bash
   flutter build apk --release
   ```

### 4. Play Store Upload

1. Go to [Google Play Console](https://play.google.com/console/)
2. Create a new app
3. Upload the app bundle (`build/app/outputs/bundle/release/app-release.aab`)
4. Fill in app details, screenshots, and descriptions
5. Set pricing (Free with ads)
6. Submit for review

## 🎯 How to Play

1. **Merge Components**: Swipe or use arrow keys to move tiles
2. **Combine Same Levels**: Merge identical AI components to create advanced systems
3. **Score Points**: Higher-level components give more points
4. **Avoid Filling**: Don't let the grid fill completely!
5. **Watch Ads**: Get extra moves by watching rewarded video ads
6. **Reach AGI**: Try to create the ultimate Super AI system!

## 🧩 AI Components

|Level|Component|Points|Description|
|--|--|--|--|
|1|Basic CPU|2|Simple processing unit|
|2|GPU Core|4|Graphics processing power|
|3|Neural Net|8|Basic neural network|
|4|Deep Learning|16|Advanced learning system|
|5|AI Assistant|32|Personal AI helper|
|6|Quantum AI|64|Quantum-powered intelligence|
|7|AGI System|128|Artificial General Intelligence|
|8|Super AI|256|Ultimate AI achievement|

## 🛠 Technical Stack

- **Framework**: Flutter 3.10+
- **State Management**: Provider pattern
- **Local Storage**: SharedPreferences
- **Ads**: Google Mobile Ads SDK
- **Analytics**: Firebase (optional)
- **Haptics**: Vibration package
- **Architecture**: MVVM with Provider

## 📱 Controls

- **Swipe Gestures**: Swipe in any direction to move tiles
- **Arrow Keys**: Use keyboard arrows (useful for testing)
- **Direction Buttons**: Tap on-screen directional controls
- **New Game**: Reset and start fresh anytime
- **Watch Ad**: Get extra moves when game over

## 💵 Revenue Optimization

### Ad Placement Strategy
- **Banner Ads**: Always visible during gameplay (non-intrusive)
- **Interstitial Ads**: Shown after game over (high engagement)
- **Rewarded Ads**: Optional for extra moves (high value)

### Best Practices
- Test ads extensively before publishing
- Monitor ad performance in AdMob console
- Optimize ad placement based on user behavior
- Consider seasonal ad campaigns

## 🔧 Development Phases

- **Phase 1**: Core game mechanics and basic UI ✅
- **Phase 2**: Ad integration and monetization ✅
- **Phase 3**: Play Store optimization ✅
- **Phase 4**: Analytics and performance tracking
- **Phase 5**: Social features and achievements

## 🚀 Building for Release

### Debug Build
```bash
flutter run --debug
```

### Release Build
```bash
flutter build appbundle --release
```

### Testing Release Build
```bash
flutter run --release
```

## 📊 Expected Revenue

With proper optimization, you can expect:
- **Banner Ads**: $0.50-$2.00 per 1000 impressions
- **Interstitial Ads**: $1.00-$5.00 per 1000 impressions
- **Rewarded Ads**: $2.00-$10.00 per 1000 views

*Revenue depends on user location, engagement, and ad optimization.*

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`feature/new-feature`)
3. Make your changes
4. Create a Pull Request to `develop` branch
5. After review, merge to `main` for releases

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🎯 Future Enhancements

- [ ] Daily challenges with bonus rewards
- [ ] Achievement system with ad rewards
- [ ] Multiple game modes
- [ ] Cloud save synchronization
- [ ] Leaderboards and social sharing
- [ ] In-app purchases for premium features
- [ ] Push notifications for re-engagement

## 📞 Support

For support or questions:
- Create an issue on GitHub
- Email: support@aimergelab.com
- AdMob help: [AdMob Help Center](https://support.google.com/admob/)

## 🏆 Success Tips

1. **Optimize Ad Placement**: Test different positions for maximum revenue
2. **User Experience**: Balance ads with gameplay enjoyment
3. **Analytics**: Track user behavior and ad performance
4. **Updates**: Regular updates keep users engaged
5. **Marketing**: Use social media and app store optimization

---

**Made with ❤️ using Flutter | Monetized AI Gaming for 2025** 🤖💰✨

*Ready to generate revenue from day one!*