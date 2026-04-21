import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zic/customization/app_colors.dart';
import 'package:zic/features/screens/home/screens/home/home.dart';

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({super.key});

  static const String _title = 'The Future of Digital Finance';

  static const List<String> _paragraphs = [
    'Cryptocurrency is rapidly reshaping the financial world. Born from the idea of decentralization and powered by cutting-edge blockchain technology, cryptocurrencies have sparked a financial revolution. But what exactly are they, how do they work, and why are they becoming increasingly important in the modern economy? Let\'s dive deep.',
    'The first and most well-known cryptocurrency is Bitcoin, which was introduced in 2009 by an anonymous entity known as Satoshi Nakamoto. The idea was revolutionary: create a peer-to-peer electronic cash system without the need for a central authority like a bank. Bitcoin demonstrated that digital value could be transferred safely and securely without trusting a third party.',
    'Since then, thousands of cryptocurrencies have emerged, each with its own use case and blockchain architecture. Ethereum, for example, introduced smart contracts -- self-executing contracts with code-based terms. This allowed for the development of decentralized applications (dApps) and gave rise to decentralized finance (DeFi), NFTs, and other innovations.',
    'Blockchain is the backbone of cryptocurrency. It\'s a chain of blocks, where each block contains a number of transactions. These blocks are linked and secured using cryptographic principles. Once recorded, the data in any given block cannot be altered without altering all subsequent blocks, which requires consensus from the majority of the network -- making it highly secure and tamper-resistant.',
    'One of the major benefits of cryptocurrency is decentralization. Traditional financial systems are controlled by centralized entities like banks or governments. Cryptocurrencies eliminate the need for intermediaries, allowing users to transact directly with one another. This not only reduces fees but also increases access for the unbanked population around the world.',
    'Cryptocurrency also promotes financial inclusion. With just a smartphone and internet connection, anyone can participate in the crypto economy -- saving, investing, or sending money across borders in minutes. This is especially impactful in developing countries where access to banking infrastructure is limited.',
    'Another defining feature is scarcity. Bitcoin, for instance, has a fixed supply of 21 million coins. This limited supply creates scarcity, much like gold, which can potentially protect against inflation -- unlike fiat currencies, which can be printed in unlimited amounts by central banks.',
    'The rise of Web3 -- the decentralized internet -- is deeply tied to cryptocurrency. In Web3, users own their data and digital assets, and cryptocurrencies are the fuel that powers this decentralized ecosystem. Blockchain ensures transparency, trust, and interoperability.',
    'Mining is the process through which new coins are generated and transactions are verified. In proof-of-work systems like Bitcoin, miners use powerful computers to solve complex mathematical problems. In proof-of-stake systems like Ethereum 2.0, validators are chosen based on how many coins they hold and are willing to "stake" as collateral.',
    'Cryptocurrency has also sparked a new wave of entrepreneurship and innovation. From creating decentralized autonomous organizations (DAOs) to building token-based economies, crypto empowers anyone with an idea to launch projects without traditional funding barriers.',
    'There are now entire ecosystems built around tokens. These tokens can represent anything -- currency, access to a platform, shares in a project, or voting power in decentralized governance models. This has redefined how startups raise capital and interact with their communities.',
    'In terms of investment, crypto has become a new asset class. Institutional investors, hedge funds, and retail traders are increasingly including digital assets in their portfolios, looking for diversification and higher returns -- despite the associated risks.',
    'Still, caution is advised. The crypto space is full of hype and speculation, and not every project is legitimate. It\'s important to do your own research (DYOR) and understand the fundamentals before investing in or using a cryptocurrency.',
    'Education and awareness are key. As the technology matures and becomes more user-friendly, mass adoption will likely follow. Just as the internet once seemed complicated, crypto too will become seamless and integrated into everyday life.',
    'Looking ahead, the future of cryptocurrency seems bright. As scalability improves, transaction fees decrease, and regulation becomes clearer, more people and businesses will likely adopt crypto in daily transactions and long-term planning.',
    'Some experts predict that cryptocurrencies may someday replace fiat currencies in certain use cases, especially in digital economies and cross-border payments. Others see them coexisting as part of a hybrid financial system -- centralized and decentralized elements working together.',
    'In conclusion, cryptocurrency is more than just digital money. It\'s a technological movement, a rethinking of how we store, transfer, and control value in the digital age. Whether you\'re a developer, investor, or curious user, understanding crypto is becoming an essential part of navigating the future.',
  ];

  static const String _disclaimer =
      'All content and images used are freely available from public sources. If you are the rightful owner of any material and wish to have it removed, please contact us. We will take immediate action.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: T.steelBorder,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 280.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/miningpic.jpg',
                      width: double.infinity,
                      height: 80.h,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 12.h,
                      left: 14.w,
                      child: InkWell(
                        onTap: () => Get.back(),
                        borderRadius: BorderRadius.circular(24.r),
                        child: Container(
                          height: 40.w,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: kPrimaryDark.withOpacity(0.55),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: kWhiteColor,
                            size: 24.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 18.h, 22.w, 30.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _title,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: T.gold,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ..._paragraphs.map(
                      (paragraph) => Padding(
                        padding: EdgeInsets.only(bottom: 20.h),
                        child: Text(
                          paragraph,
                          style: TextStyle(
                            fontSize: 16.sp,
                            height: 1.45,
                            color: T.gold,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Disclaimer:',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: T.cyan,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _disclaimer,
                      style: TextStyle(
                        fontSize: 14.sp,
                        height: 1.4,
                        color: T.cyan,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
