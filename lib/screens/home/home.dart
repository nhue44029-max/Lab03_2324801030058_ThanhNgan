import 'package:flutter/material.dart';

import '../../core/constants/routes.dart';
import '../../data/data.dart';
import '../../models/destination.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedNavigationIndex = 0;
  String? _selectedDestination;
  var _selectedTime = 'Thời gian';
  var _selectedPeople = 'Số người';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        top: false,
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
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildHero(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final heroHeight = screenWidth >= 1200
        ? 430.0
        : screenWidth >= 700
        ? 400.0
        : 360.0;
    final horizontalPadding = screenWidth < 500
        ? 18.0
        : screenWidth < 900
        ? 28.0
        : 42.0;

    return SizedBox(
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/hero/hero_vietnam.jpg', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x99005873), Color(0xD9002F4B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
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
                        tooltip: 'Thông báo',
                        onPressed: () => _showNotifications(context),
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        tooltip: 'Tài khoản',
                        onPressed: () => _showProfile(context),
                        icon: CircleAvatar(
                          radius: screenWidth < 500 ? 20 : 23,
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF007C73),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(35),
                    child: InkWell(
                      onTap: () => _pickDestination(context),
                      borderRadius: BorderRadius.circular(35),
                      child: Container(
                        width: screenWidth < 700
                            ? double.infinity
                            : screenWidth * 0.48,
                        constraints: const BoxConstraints(
                          minWidth: 0,
                          maxWidth: 750,
                        ),
                        height: screenWidth < 500 ? 56 : 62,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
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
                                _selectedDestination == null
                                    ? 'Bạn muốn đi đâu hôm nay?'
                                    : 'Khám phá $_selectedDestination',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: const Color(0xFF7C8498),
                                  fontSize: screenWidth < 500 ? 15 : 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 9,
                    runSpacing: 9,
                    children: [
                      _filterButton(
                        Icons.location_on_rounded,
                        _selectedDestination ?? 'Điểm đến',
                        onTap: () => _pickDestination(context),
                      ),
                      _filterButton(
                        Icons.calendar_month_rounded,
                        _selectedTime,
                        onTap: () => _pickOption(
                          context,
                          title: 'Chọn thời gian',
                          options: const ['Cuối tuần này', 'Tháng này', 'Tháng sau'],
                          onSelected: (value) =>
                              setState(() => _selectedTime = value),
                        ),
                      ),
                      _filterButton(
                        Icons.group_rounded,
                        _selectedPeople,
                        onTap: () => _pickOption(
                          context,
                          title: 'Số người tham gia',
                          options: const ['1 người', '2 người', '3–5 người', 'Trên 5 người'],
                          onSelected: (value) =>
                              setState(() => _selectedPeople = value),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(
    IconData icon,
    String title, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 19, color: const Color(0xFF10233F)),
              const SizedBox(width: 7),
              Text(title, style: const TextStyle(color: Color(0xFF10233F))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceMenu(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final services = <_ServiceItem>[
      const _ServiceItem(Icons.flight_rounded, 'Chuyến bay'),
      const _ServiceItem(Icons.hotel_rounded, 'Khách sạn'),
      const _ServiceItem(Icons.confirmation_num_rounded, 'Vé tham quan'),
      const _ServiceItem(Icons.train_rounded, 'Tàu/xe'),
      const _ServiceItem(Icons.directions_car_rounded, 'Thuê xe'),
      const _ServiceItem(Icons.beach_access_rounded, 'Tour du lịch'),
      const _ServiceItem(Icons.more_horiz_rounded, 'Xem thêm'),
    ];
    final horizontalMargin = screenWidth < 600
        ? 14.0
        : screenWidth < 1000
        ? 20.0
        : 32.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
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
          final isMobile = constraints.maxWidth < 500;
          final itemWidth = constraints.maxWidth < 500
              ? constraints.maxWidth / 3.2
              : constraints.maxWidth < 900
              ? constraints.maxWidth / 4.2
              : constraints.maxWidth / 7.2;
          return Wrap(
            alignment: WrapAlignment.spaceAround,
            runSpacing: 18,
            children: services.map((service) {
              return SizedBox(
                width: itemWidth,
                child: InkWell(
                  borderRadius: BorderRadius.circular(17),
                  onTap: () => _showServiceSheet(context, service),
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
                          service.icon,
                          color: const Color(0xFF00897B),
                          size: isMobile ? 27 : 30,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        service.label,
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
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildSmartTrip(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalMargin = screenWidth < 600
        ? 14.0
        : screenWidth < 1000
        ? 20.0
        : 32.0;
    final contentPadding = screenWidth < 600
        ? 18.0
        : screenWidth < 1000
        ? 22.0
        : 28.0;
    final titleSize = screenWidth < 500
        ? 21.0
        : screenWidth < 900
        ? 25.0
        : 29.0;

    return Container(
      margin: EdgeInsets.fromLTRB(horizontalMargin, 0, horizontalMargin, 24),
      padding: EdgeInsets.all(contentPadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD8FFF5), Color(0xFFFFF7D9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: screenWidth < 600 ? 120 : 168,
              width: double.infinity,
              child: Image.asset(
                'assets/images/banners/vietway.png',
                fit: BoxFit.cover,
                semanticLabel: 'Vietway - trải nghiệm du lịch Việt Nam',
              ),
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
              _featureChip(Icons.calendar_month, 'Lịch trình linh hoạt'),
              _featureChip(Icons.groups_rounded, 'Chia sẻ cùng nhóm'),
              _featureChip(Icons.auto_awesome, 'Tự động điều chỉnh'),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.tripDetail,
              arguments: TripData.demoTrip,
            ),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureChip(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFE7EEEE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF00897B)),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF263B4D)),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotions(BuildContext context) {
    return _section(
      context: context,
      icon: Icons.local_fire_department_rounded,
      title: 'Ưu đãi hôm nay',
      destinations: TripData.promotions,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return SizedBox(
              height: 210,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: TripData.promotions.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, index) => SizedBox(
                  width: 270,
                  child: _destinationCard(context, TripData.promotions[index]),
                ),
              ),
            );
          }
          final columns = constraints.maxWidth >= 1000 ? 3 : 2;
          final cardWidth =
              (constraints.maxWidth - (columns - 1) * 16) / columns;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: TripData.promotions.map((destination) {
              return SizedBox(
                width: cardWidth,
                height: 210,
                child: _destinationCard(context, destination),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _destinationCard(BuildContext context, Destination destination) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage(destination.imagePath),
        fit: BoxFit.cover,
        child: InkWell(
          onTap: () => _openTrip(context, destination),
          child: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Color(0xD9000000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.3, 1],
                    ),
                  ),
                ),
              ),
              if (destination.discountLabel != null)
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7043),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      destination.discountLabel!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              Positioned(
                left: 16,
                right: 14,
                bottom: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            destination.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            destination.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Color(0xFF007C73),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return _section(
      context: context,
      icon: Icons.explore_outlined,
      title: 'Khám phá theo chủ đề',
      destinations: TripData.categories,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: TripData.categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) => SizedBox(
                  width: 150,
                  child: _categoryCard(context, TripData.categories[index]),
                ),
              ),
            );
          }
          final columns = constraints.maxWidth >= 1100 ? 4 : 3;
          final cardWidth =
              (constraints.maxWidth - (columns - 1) * 14) / columns;
          return Wrap(
            spacing: 14,
            runSpacing: 14,
            children: TripData.categories.map((category) {
              return SizedBox(
                width: cardWidth,
                height: 165,
                child: _categoryCard(context, category),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _categoryCard(BuildContext context, Destination category) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage(category.imagePath),
        fit: BoxFit.cover,
        child: InkWell(
          hoverColor: Colors.white24,
          onTap: () => _showCategorySheet(context, category),
          child: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Color(0xDE10233F)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 13,
                child: Text(
                  category.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInspiration(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final margin = screenWidth < 600
        ? 14.0
        : screenWidth < 1000
        ? 20.0
        : 32.0;
    return Container(
      margin: EdgeInsets.fromLTRB(margin, 0, margin, 20),
      padding: EdgeInsets.all(screenWidth < 500 ? 18 : 26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF8EBD6), Color(0xFFFFF8EB)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Việt Nam còn nhiều nơi đẹp lắm\nĐi để cảm nhận! ♡',
                  style: TextStyle(
                    fontSize: screenWidth < 500 ? 20 : 25,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF252525),
                  ),
                ),
              ),
              if (screenWidth >= 700)
                const Icon(
                  Icons.travel_explore_rounded,
                  size: 62,
                  color: Color(0xFF00897B),
                ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: TripData.inspiration.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => SizedBox(
                      width: 170,
                        child: _inspirationCard(
                          context,
                          TripData.inspiration[index],
                        ),
                    ),
                  ),
                );
              }
              return Row(
                children: TripData.inspiration.asMap().entries.map((entry) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: entry.key == 0 ? 0 : 12),
                      child: SizedBox(
                        height: 180,
                        child: _inspirationCard(context, entry.value),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _inspirationCard(BuildContext context, Destination destination) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
        image: AssetImage(destination.imagePath),
        fit: BoxFit.cover,
        child: InkWell(
          onTap: () => _openTrip(context, destination),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Color(0xD9000000)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Text(
                  destination.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Destination> destinations,
    required Widget child,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 600
        ? 14.0
        : screenWidth < 1000
        ? 20.0
        : 32.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              12,
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
                  onPressed: () =>
                      _showDestinationList(context, title, destinations),
                  child: Text(
                    screenWidth < 400 ? 'Xem thêm' : 'Xem tất cả →',
                    style: const TextStyle(color: Color(0xFF10233F)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return NavigationBar(
      selectedIndex: _selectedNavigationIndex,
      height: screenWidth < 500 ? 68 : 75,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFD5F3EE),
      elevation: 8,
      onDestinationSelected: (index) {
        setState(() => _selectedNavigationIndex = index);
        switch (index) {
          case 0:
            return;
          case 1:
            _showMyTrips(context);
            return;
          case 2:
            Navigator.pushNamed(
              context,
              AppRoutes.tripDetail,
              arguments: TripData.demoTrip,
            );
            return;
          case 3:
            _showFavorites(context);
            return;
          case 4:
            _showProfile(context);
            return;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF007C73)),
          label: 'Trang chủ',
        ),
        NavigationDestination(
          icon: Icon(Icons.luggage_outlined),
          label: 'Chuyến đi',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline_rounded),
          label: 'Tạo chuyến đi',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border_rounded),
          label: 'Yêu thích',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Cá nhân',
        ),
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openTrip(BuildContext context, Destination destination) {
    Navigator.pushNamed(
      context,
      AppRoutes.tripDetail,
      arguments: TripData.tripForDestination(destination),
    );
  }

  void _pickDestination(BuildContext context) {
    final destinations = [...TripData.promotions, ...TripData.inspiration];
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn điểm đến',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              ...destinations.map(
                (destination) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipOval(
                    child: Image.asset(
                      destination.imagePath,
                      width: 42,
                      height: 42,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(destination.name),
                  subtitle: Text(destination.description),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    setState(() => _selectedDestination = destination.name);
                    Navigator.pop(sheetContext);
                    _showMessage(context, 'Đã chọn ${destination.name}.');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickOption(
    BuildContext context, {
    required String title,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              ...options.map(
                (option) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(option),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(sheetContext);
                    _showMessage(context, '$title: $option');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    const notifications = [
      ('Ưu đãi mới', 'Giảm thêm 10% cho chuyến đi Đà Nẵng.'),
      ('Lịch trình', 'Nhắc bạn xem lại lịch trình chuyến đi.'),
    ];
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thông báo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              ...notifications.map(
                (notification) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE7F6F3),
                    child: Icon(
                      Icons.notifications_rounded,
                      color: Color(0xFF007C73),
                    ),
                  ),
                  title: Text(notification.$1),
                  subtitle: Text(notification.$2),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _showMessage(context, 'Đã đánh dấu ${notification.$1} là đã đọc.');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showServiceSheet(BuildContext context, _ServiceItem service) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFE7F6F3),
                child: Icon(service.icon, color: const Color(0xFF007C73)),
              ),
              const SizedBox(height: 12),
              Text(
                service.label,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Dữ liệu mẫu đã sẵn sàng. Bạn có thể thêm dịch vụ này vào kế hoạch chuyến đi.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF526273)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    Navigator.pushNamed(
                      context,
                      AppRoutes.tripDetail,
                      arguments: TripData.demoTrip,
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Thêm vào kế hoạch'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCategorySheet(BuildContext context, Destination category) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  category.imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                category.name,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(category.description),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _openTrip(context, category);
                  },
                  child: const Text('Lập kế hoạch theo chủ đề'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDestinationList(
    BuildContext context,
    String title,
    List<Destination> destinations,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              ...destinations.map(
                (destination) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(destination.name),
                  subtitle: Text(destination.description),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _openTrip(context, destination);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMyTrips(BuildContext context) {
    _showDestinationList(context, 'Chuyến đi của tôi', [TripData.daNang]);
  }

  void _showFavorites(BuildContext context) {
    _showDestinationList(context, 'Điểm đến yêu thích', [TripData.phuQuoc, TripData.daLat]);
  }

  void _showProfile(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const CircleAvatar(
          radius: 28,
          backgroundColor: Color(0xFFE7F6F3),
          child: Icon(Icons.person_rounded, color: Color(0xFF007C73)),
        ),
        title: const Text('Tài khoản của bạn'),
        content: const Text('Ngân • Thành viên Vietway\nBạn có 1 chuyến đi đang lên kế hoạch.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _showMyTrips(context);
            },
            child: const Text('Xem chuyến đi'),
          ),
        ],
      ),
    );
  }
}

class _ServiceItem {
  const _ServiceItem(this.icon, this.label);

  final IconData icon;
  final String label;
}
