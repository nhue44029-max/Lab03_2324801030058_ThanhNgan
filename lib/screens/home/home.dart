import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),

      body: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHero(context),

                Transform.translate(
                  offset: const Offset(0, -20),
                  child: _buildServiceMenu(context),
                ),

                _buildSmartTrip(context),
                _buildPromotions(context),
                _buildCategories(context),
                _buildInspiration(context),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  // =========================================================
  // 1. HERO
  // =========================================================

  Widget _buildHero(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final double heroHeight;

    if (screenWidth >= 1200) {
      heroHeight = 430;
    } else if (screenWidth >= 700) {
      heroHeight = 400;
    } else {
      heroHeight = 360;
    }

    final double horizontalPadding =
        screenWidth < 500 ? 18 : screenWidth < 900 ? 28 : 42;

    return Container(
      height: heroHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(
            'assets/images/hero/hero_vietnam.jpg',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.18),
            BlendMode.darken,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            18,
            horizontalPadding,
            38,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo + notification + avatar
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vietway',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth < 500 ? 38 : 46,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Khám phá Việt Nam theo cách của bạn',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth < 500 ? 13 : 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 5),

                  CircleAvatar(
                    radius: screenWidth < 500 ? 20 : 23,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF007C73),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Search
              Container(
                width: screenWidth < 700
                    ? double.infinity
                    : screenWidth * 0.48,
                constraints: const BoxConstraints(
                  minWidth: 300,
                  maxWidth: 750,
                ),
                height: screenWidth < 500 ? 56 : 62,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(35),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 31,
                      color: Color(0xFF10233F),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        'Bạn muốn đi đâu hôm nay?',
                        style: TextStyle(
                          color: const Color(0xFF7C8498),
                          fontSize: screenWidth < 500 ? 15 : 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Filter buttons
              Wrap(
                spacing: 9,
                runSpacing: 9,
                children: [
                  _filterButton(
                    Icons.location_on_rounded,
                    'Điểm đến',
                  ),
                  _filterButton(
                    Icons.calendar_month_rounded,
                    'Thời gian',
                  ),
                  _filterButton(
                    Icons.group_rounded,
                    'Số người',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterButton(
    IconData icon,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 19,
            color: const Color(0xFF10233F),
          ),
          const SizedBox(width: 7),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF10233F),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // 2. MENU DỊCH VỤ
  // =========================================================

  Widget _buildServiceMenu(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final services = [
      [Icons.flight_rounded, 'Chuyến bay'],
      [Icons.hotel_rounded, 'Khách sạn'],
      [Icons.confirmation_num_rounded, 'Vé tham quan'],
      [Icons.train_rounded, 'Tàu/xe'],
      [Icons.directions_car_rounded, 'Thuê xe'],
      [Icons.beach_access_rounded, 'Tour du lịch'],
      [Icons.more_horiz_rounded, 'Xem thêm'],
    ];

    final double horizontalMargin =
        screenWidth < 600 ? 14 : screenWidth < 1000 ? 20 : 32;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: horizontalMargin,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            alignment: WrapAlignment.spaceAround,
            runSpacing: 18,
            children: services.map((service) {
              double itemWidth;

              if (constraints.maxWidth < 500) {
                itemWidth = constraints.maxWidth / 3.2;
              } else if (constraints.maxWidth < 900) {
                itemWidth = constraints.maxWidth / 4.2;
              } else {
                itemWidth = constraints.maxWidth / 7.2;
              }

              final bool isMobile =
                  constraints.maxWidth < 500;

              return SizedBox(
                width: itemWidth,
                child: Column(
                  children: [
                    Container(
                      height: isMobile ? 52 : 58,
                      width: isMobile ? 52 : 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9F8F5),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        service[0] as IconData,
                        color: const Color(0xFF00897B),
                        size: isMobile ? 27 : 30,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      service[1] as String,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        color: const Color(0xFF10233F),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // =========================================================
  // 3. VIETWAY AI
  // =========================================================

  Widget _buildSmartTrip(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final double horizontalMargin =
        screenWidth < 600 ? 14 : screenWidth < 1000 ? 20 : 32;

    final double contentPadding =
        screenWidth < 600 ? 18 : screenWidth < 1000 ? 22 : 28;

    final double titleSize =
        screenWidth < 500 ? 21 : screenWidth < 900 ? 25 : 29;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        horizontalMargin,
        0,
        horizontalMargin,
        24,
      ),
      padding: EdgeInsets.all(contentPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD8FFF5),
            Color(0xFFFFF7D9),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF20877A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Vietway AI ✦',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Lên kế hoạch chuyến đi thông minh',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF10233F),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Nhập ngân sách – Chọn sở thích – Vietway lo tất cả!',
            style: TextStyle(
              fontSize: screenWidth < 500 ? 14 : 16,
              color: const Color(0xFF315E5A),
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _featureChip(
                Icons.monetization_on_outlined,
                'Kiểm soát ngân sách',
              ),
              _featureChip(
                Icons.calendar_month,
                'Lịch trình linh hoạt',
              ),
              _featureChip(
                Icons.groups_rounded,
                'Chia sẻ cùng nhóm',
              ),
              _featureChip(
                Icons.auto_awesome,
                'Tự động điều chỉnh',
              ),
            ],
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/trip-detail',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007C73),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth < 500 ? 20 : 28,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tạo chuyến đi ngay',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureChip(
    IconData icon,
    String title,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFFE7EEEE),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF00897B),
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF263B4D),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // 4. ƯU ĐÃI
  // =========================================================

  Widget _buildPromotions(BuildContext context) {
    return _placeholderSection(
      context,
      Icons.local_fire_department_rounded,
      'Ưu đãi hôm nay',
      190,
    );
  }

  // =========================================================
  // 5. KHÁM PHÁ THEO CHỦ ĐỀ
  // =========================================================

  Widget _buildCategories(BuildContext context) {
    return _placeholderSection(
      context,
      Icons.explore_outlined,
      'Khám phá theo chủ đề',
      150,
    );
  }

  // =========================================================
  // 6. BANNER CUỐI
  // =========================================================

  Widget _buildInspiration(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final double margin =
        screenWidth < 600 ? 14 : screenWidth < 1000 ? 20 : 32;

    return Container(
      margin: EdgeInsets.fromLTRB(
        margin,
        0,
        margin,
        20,
      ),
      padding: EdgeInsets.all(
        screenWidth < 500 ? 20 : 28,
      ),
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: screenWidth < 500 ? 150 : 180,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF8EBD6),
            Color(0xFFFFF8EB),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Việt Nam còn nhiều nơi đẹp lắm\nĐi để cảm nhận! ♡',
              style: TextStyle(
                fontSize: screenWidth < 500 ? 20 : 25,
                height: 1.4,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF252525),
              ),
            ),
          ),

          if (screenWidth >= 700)
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.travel_explore_rounded,
                size: 85,
                color: Color(0xFF00897B),
              ),
            ),
        ],
      ),
    );
  }

  // =========================================================
  // SECTION DÙNG CHUNG
  // =========================================================

  Widget _placeholderSection(
    BuildContext context,
    IconData icon,
    String title,
    double height,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final double horizontalPadding =
        screenWidth < 600 ? 14 : screenWidth < 1000 ? 20 : 32;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 12,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: screenWidth < 500 ? 24 : 28,
                  color: const Color(0xFF00897B),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth < 500 ? 19 : 23,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF10233F),
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {},
                  child: Text(
                    screenWidth < 400
                        ? 'Xem thêm'
                        : 'Xem tất cả →',
                    style: const TextStyle(
                      color: Color(0xFF10233F),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            width: double.infinity,
            height: screenWidth < 500
                ? height * 0.82
                : height,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // 7. BOTTOM NAVIGATION
  // =========================================================

  Widget _buildBottomNavigation(
    BuildContext context,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return NavigationBar(
      selectedIndex: 0,
      height: screenWidth < 500 ? 68 : 75,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFD5F3EE),
      elevation: 8,

      onDestinationSelected: (index) {
        if (index == 1) {
          Navigator.pushNamed(
            context,
            '/trip-detail',
          );
        }

        if (index == 2) {
          Navigator.pushNamed(
            context,
            '/trip-detail',
          );
        }
      },

      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
          ),
          selectedIcon: Icon(
            Icons.home_rounded,
            color: Color(0xFF007C73),
          ),
          label: 'Trang chủ',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.luggage_outlined,
          ),
          label: 'Chuyến đi',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.add_circle_outline_rounded,
          ),
          label: 'Tạo chuyến đi',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.favorite_border_rounded,
          ),
          label: 'Yêu thích',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.person_outline_rounded,
          ),
          label: 'Cá nhân',
        ),
      ],
    );
  }
}