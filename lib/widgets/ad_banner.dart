import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../providers/ad_provider.dart';
import '../utils/constants.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdProvider>(
      builder: (context, adProvider, child) {
        if (adProvider.isBannerAdReady && adProvider.bannerAd != null) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: adProvider.bannerAd!.size.height.toDouble(),
            decoration: BoxDecoration(
              color: AppColors.adBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AdWidget(ad: adProvider.bannerAd!),
          );
        }
        
        // Show placeholder when ad is not ready
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.adBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text(
              'Ad Space',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
    );
  }
}