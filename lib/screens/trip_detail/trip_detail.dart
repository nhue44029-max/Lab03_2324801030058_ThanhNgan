import 'package:flutter/material.dart';

import '../../core/constants/routes.dart';
import '../../data/data.dart';
import '../../models/trip.dart';

class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({super.key, this.trip});

  final Trip? trip;

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late List<ScheduleActivity> _activities;
  var _showFlexibleWarning = false;
  var _replanApplied = false;

  Trip get _trip => widget.trip ?? TripData.demoTrip;

  @override
  void initState() {
    super.initState();
    _activities = TripData.schedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Quay lại',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SMART TRIP',
              style: TextStyle(fontSize: 13, color: Color(0xFF00897B)),
            ),
            Text(
              'Chi tiết chuyến đi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Center(
              child: Text(
                'Vietway',
                style: TextStyle(
                  color: Color(0xFF007C73),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 600
                ? 14.0
                : constraints.maxWidth < 1000
                ? 24.0
                : 40.0;
            final isWide = constraints.maxWidth >= 1000;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                18,
                horizontalPadding,
                120,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1440),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTripHeader(),
                      const SizedBox(height: 18),
                      if (isWide)
                        _buildDesktopLayout()
                      else
                        _buildMobileLayout(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildPaymentBar(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            children: [
              _buildSchedule(),
              const SizedBox(height: 18),
              _buildAutoReplan(),
            ],
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildBudgetGuard(),
              const SizedBox(height: 18),
              _buildGroupWallet(),
              const SizedBox(height: 18),
              _buildBookingSummary(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildBudgetGuard(),
        const SizedBox(height: 18),
        _buildSchedule(),
        const SizedBox(height: 18),
        _buildAutoReplan(),
        const SizedBox(height: 18),
        _buildGroupWallet(),
        const SizedBox(height: 18),
        _buildBookingSummary(),
      ],
    );
  }

  Widget _buildTripHeader() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        height: 250,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(_trip.destination.imagePath, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0x33000000), Color(0xE600343B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              top: 18,
              left: 18,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xD9D8FFF5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: Color(0xFF007C73),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Kế hoạch đang mở',
                      style: TextStyle(color: Color(0xFF007C73)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _trip.destination.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 31,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _headerPill(
                        Icons.calendar_month_rounded,
                        '${_trip.days} ngày ${_trip.nights} đêm',
                      ),
                      _headerPill(Icons.group_rounded, '${_trip.people} người'),
                      _headerPill(
                        Icons.account_balance_wallet_rounded,
                        'Ngân sách ${formatVnd(_trip.budget)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerPill(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0x33000000),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x44FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetGuard() {
    final budgetItems = <_BudgetItem>[
      const _BudgetItem(
        Icons.flight_rounded,
        'Di chuyển',
        3000000,
        Color(0xFF4C8BF5),
      ),
      const _BudgetItem(
        Icons.hotel_rounded,
        'Khách sạn',
        3000000,
        Color(0xFF9B59B6),
      ),
      const _BudgetItem(
        Icons.restaurant_rounded,
        'Ăn uống',
        1500000,
        Color(0xFFFF8A65),
      ),
      const _BudgetItem(
        Icons.confirmation_num_rounded,
        'Vui chơi',
        1500000,
        Color(0xFFFFB300),
      ),
      const _BudgetItem(
        Icons.local_taxi_rounded,
        'Đi lại',
        500000,
        Color(0xFF26A69A),
      ),
      const _BudgetItem(
        Icons.savings_rounded,
        'Dự phòng',
        500000,
        Color(0xFF78909C),
      ),
    ];

    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.shield_outlined,
            'Budget Guard',
            'Bảo vệ ngân sách',
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tổng ngân sách',
                      style: TextStyle(color: Color(0xFF61717D)),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      formatVnd(_trip.budget),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF10233F),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '94%',
                style: TextStyle(
                  color: Color(0xFF007C73),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const LinearProgressIndicator(
              value: 0.945,
              minHeight: 10,
              backgroundColor: Color(0xFFE0ECEA),
              valueColor: AlwaysStoppedAnimation(Color(0xFF00897B)),
            ),
          ),
          const SizedBox(height: 11),
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: const [
              _BudgetMetric(
                label: 'Đã sử dụng',
                value: '9.450.000đ',
                color: Color(0xFF007C73),
              ),
              _BudgetMetric(
                label: 'Còn lại',
                value: '550.000đ',
                color: Color(0xFF315E5A),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(height: 1),
          ),
          ...budgetItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: item.color.withValues(alpha: 0.14),
                    child: Icon(item.icon, size: 16, color: item.color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    formatVnd(item.value),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFFD699)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFE77B00)),
                SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Chi phí khách sạn đang vượt ngân sách 800.000đ.',
                    style: TextStyle(
                      color: Color(0xFF7A4800),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Gợi ý tiết kiệm',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 7),
          const _SavingLine('Đổi khách sạn khác', '-600.000đ'),
          const _SavingLine('Thay hoạt động khác', '-250.000đ'),
          const Divider(height: 20),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng mới',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '9.950.000đ',
                style: TextStyle(
                  color: Color(0xFF007C73),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            'Nằm trong ngân sách',
            style: TextStyle(fontSize: 12, color: Color(0xFF00897B)),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedule() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.route_rounded,
            'Lịch trình linh hoạt',
            'Dễ dàng thay đổi mọi lúc',
          ),
          const SizedBox(height: 18),
          for (var day = 1; day <= 3; day++) ...[
            _dayTitle(day),
            const SizedBox(height: 10),
            ..._activities
                .where((activity) => activity.day == day)
                .map(_activityTile),
            const SizedBox(height: 8),
          ],
          OutlinedButton.icon(
            onPressed: _addActivity,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Thêm hoạt động'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF007C73),
            ),
          ),
          const SizedBox(height: 16),
          _buildFlexibleSchedule(),
        ],
      ),
    );
  }

  Widget _dayTitle(int day) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F6F3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'NGÀY $day',
            style: const TextStyle(
              color: Color(0xFF007C73),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(child: Divider()),
      ],
    );
  }

  Widget _activityTile(ScheduleActivity activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Text(
                activity.time,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF00A18F),
                  shape: BoxShape.circle,
                ),
              ),
              Container(width: 2, height: 46, color: const Color(0xFFD5ECE8)),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 9, 5, 9),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFCFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE3EEEE)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFFE8F7F4),
                    child: Icon(
                      activity.icon,
                      size: 17,
                      color: const Color(0xFF007C73),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activity.detail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF61717D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<_ScheduleAction>(
                    tooltip: 'Tùy chỉnh hoạt động',
                    onSelected: (action) =>
                        _handleScheduleAction(action, activity),
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: _ScheduleAction.changeTime,
                        child: Text('Đổi giờ'),
                      ),
                      PopupMenuItem(
                        value: _ScheduleAction.moveDay,
                        child: Text('Đổi ngày'),
                      ),
                      PopupMenuItem(
                        value: _ScheduleAction.reorder,
                        child: Text('Đổi thứ tự'),
                      ),
                      PopupMenuItem(
                        value: _ScheduleAction.delete,
                        child: Text('Xóa'),
                      ),
                    ],
                    icon: const Icon(Icons.more_horiz_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlexibleSchedule() {
    if (_showFlexibleWarning) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4E5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFFFD699)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.schedule_rounded, color: Color(0xFFE77B00)),
                SizedBox(width: 8),
                Text(
                  'Flexible Schedule',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Nếu tham quan Bà Nà Hills lúc 10:00, bạn có thể không kịp hoạt động Cafe lúc 14:00.',
            ),
            const SizedBox(height: 10),
            const Text(
              'Phương án đề xuất',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            const Text(
              'Bà Nà Hills 10:00 – 15:00\nCafe 16:00 – 17:00\nBiển Mỹ Khê 17:30 – 19:00\nCầu Rồng 20:00',
            ),
            TextButton(
              onPressed: () => setState(() => _showFlexibleWarning = false),
              child: const Text('Đổi lại lịch ban đầu'),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_fix_high_rounded, color: Color(0xFF007C73)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Thử đổi Bà Nà Hills 08:00 → 10:00 để Vietway sắp xếp lại lịch.',
            ),
          ),
          TextButton(onPressed: _moveBaNaToTen, child: const Text('Thử ngay')),
        ],
      ),
    );
  }

  Widget _buildAutoReplan() {
    return _sectionCard(
      background: const Color(0xFFF3F6FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.cloud, 'Auto Re-plan', 'Điều chỉnh thông minh'),
          const SizedBox(height: 14),
          const Text(
            'Dự báo mưa có thể ảnh hưởng lịch trình.',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: Color(0xFF10233F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _replanApplied
                ? 'Lịch mới đã ưu tiên hoạt động trong nhà vào buổi chiều.'
                : 'Vietway đề xuất chuyển hoạt động ngoài trời sang buổi tối và ghé bảo tàng vào chiều ngày 2.',
            style: const TextStyle(color: Color(0xFF526273)),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => _showMessage('Đã giữ lịch cũ.'),
                child: const Text('Giữ lịch cũ'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => _replanApplied = true);
                  _showMessage('Đã áp dụng lịch trình mới.');
                },
                icon: Icon(
                  _replanApplied
                      ? Icons.check_rounded
                      : Icons.auto_awesome_rounded,
                ),
                label: Text(_replanApplied ? 'Đã áp dụng' : 'Áp dụng lịch mới'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B6FE8),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupWallet() {
    const expenses = [
      _WalletExpense('Ngân', 'Khách sạn', 3000000, Color(0xFFE16666)),
      _WalletExpense('Minh', 'Thuê xe', 2000000, Color(0xFF5B8DEF)),
      _WalletExpense('Huy', 'Ăn uống', 1200000, Color(0xFFF4A261)),
    ];
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.groups_rounded,
            'Group Wallet',
            'Cùng nhau minh bạch chi tiêu',
          ),
          const SizedBox(height: 14),
          const Wrap(
            spacing: 10,
            children: [
              _MemberChip('N', 'Ngân', Color(0xFFE16666)),
              _MemberChip('M', 'Minh', Color(0xFF5B8DEF)),
              _MemberChip('L', 'Linh', Color(0xFF9B59B6)),
              _MemberChip('H', 'Huy', Color(0xFFF4A261)),
            ],
          ),
          const SizedBox(height: 15),
          ...expenses.map(
            (expense) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: expense.color,
                    child: Text(
                      expense.name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${expense.name} trả ${expense.type}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const Text(
                          'Đã ghi nhận',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF00897B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatVnd(expense.amount),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 22),
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng chi phí nhóm',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                '6.200.000đ',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF10233F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            '3/4 thành viên đã xác nhận chia tiền',
            style: TextStyle(fontSize: 12, color: Color(0xFF61717D)),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingSummary() {
    const bookings = [
      _Booking(Icons.flight_rounded, 'Chuyến bay', 'Khứ hồi Đà Nẵng', 3000000),
      _Booking(
        Icons.hotel_rounded,
        'Khách sạn',
        '3 đêm gần biển Mỹ Khê',
        3800000,
      ),
      _Booking(
        Icons.confirmation_num_rounded,
        'Vé tham quan',
        'Bà Nà Hills',
        1400000,
      ),
      _Booking(
        Icons.tour_rounded,
        'Tour/hoạt động',
        'Hội An & trải nghiệm',
        1800000,
      ),
    ];
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            Icons.receipt_long_rounded,
            'Booking Summary',
            'Dịch vụ đã chọn',
          ),
          const SizedBox(height: 12),
          ...bookings.map(
            (booking) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Icon(booking.icon, color: const Color(0xFF007C73)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.title,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          booking.detail,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF61717D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatVnd(booking.amount),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tổng thanh toán',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                formatVnd(_trip.totalPayment),
                style: const TextStyle(
                  fontSize: 17,
                  color: Color(0xFF007C73),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () =>
              Navigator.pushNamed(context, AppRoutes.payment, arguments: _trip),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007C73),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tiếp tục thanh toán',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required Widget child,
    Color background = Colors.white,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE0ECEA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFFE7F6F3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF007C73)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF10233F),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF61717D)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleScheduleAction(
    _ScheduleAction action,
    ScheduleActivity activity,
  ) {
    final index = _activities.indexOf(activity);
    if (index < 0) {
      return;
    }
    switch (action) {
      case _ScheduleAction.changeTime:
        _moveBaNaToTen(activity: activity);
        break;
      case _ScheduleAction.moveDay:
        setState(() {
          _activities[index] = activity.copyWith(
            day: activity.day == 3 ? 1 : activity.day + 1,
          );
        });
        _showMessage('Đã chuyển ${activity.title} sang ngày mới.');
        break;
      case _ScheduleAction.reorder:
        if (index > 0) {
          setState(() {
            final moved = _activities.removeAt(index);
            _activities.insert(index - 1, moved);
          });
          _showMessage('Đã đưa ${activity.title} lên trước một vị trí.');
        } else {
          _showMessage('Hoạt động này đã ở vị trí đầu tiên.');
        }
        break;
      case _ScheduleAction.delete:
        setState(() => _activities.removeAt(index));
        _showMessage('Đã xóa ${activity.title}.');
        break;
    }
  }

  void _moveBaNaToTen({ScheduleActivity? activity}) {
    final index = activity == null
        ? _activities.indexWhere((item) => item.title == 'Bà Nà Hills')
        : _activities.indexOf(activity);
    if (index >= 0) {
      setState(() {
        _activities[index] = _activities[index].copyWith(time: '10:00');
        _showFlexibleWarning = true;
      });
    }
  }

  void _addActivity() {
    setState(() {
      _activities.add(
        ScheduleActivity(
          day: 3,
          time: '18:30',
          title: 'Ngắm hoàng hôn',
          detail: 'Hoạt động mới đã thêm',
          icon: Icons.wb_sunny_rounded,
        ),
      );
    });
    _showMessage('Đã thêm hoạt động mới vào ngày 3.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

enum _ScheduleAction { changeTime, moveDay, reorder, delete }

class _BudgetItem {
  const _BudgetItem(this.icon, this.label, this.value, this.color);

  final IconData icon;
  final String label;
  final int value;
  final Color color;
}

class _BudgetMetric extends StatelessWidget {
  const _BudgetMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12, color: Color(0xFF61717D)),
        children: [
          TextSpan(text: '$label: '),
          TextSpan(
            text: value,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _SavingLine extends StatelessWidget {
  const _SavingLine(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF00897B),
            size: 16,
          ),
          const SizedBox(width: 7),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF00897B),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletExpense {
  const _WalletExpense(this.name, this.type, this.amount, this.color);

  final String name;
  final String type;
  final int amount;
  final Color color;
}

class _MemberChip extends StatelessWidget {
  const _MemberChip(this.initial, this.name, this.color);

  final String initial;
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color,
        child: Text(
          initial,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      ),
      label: Text(name),
      side: const BorderSide(color: Color(0xFFE0ECEA)),
      backgroundColor: Colors.white,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _Booking {
  const _Booking(this.icon, this.title, this.detail, this.amount);

  final IconData icon;
  final String title;
  final String detail;
  final int amount;
}
