import 'package:flutter/material.dart';

import '../../data/data.dart';
import '../../models/trip.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, this.trip});

  final Trip? trip;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PaymentMethod _selectedMethod = _PaymentMethod.wallet;
  var _isPaid = false;

  Trip get _trip => widget.trip ?? TripData.demoTrip;

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
        title: const Text(
          'Thanh toán',
          style: TextStyle(fontWeight: FontWeight.w800),
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
                  constraints: const BoxConstraints(maxWidth: 1320),
                  child: isWide
                      ? _buildDesktopContent()
                      : _buildMobileContent(),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildPayButton(),
    );
  }

  Widget _buildDesktopContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildOrderSummary(),
              const SizedBox(height: 18),
              _buildGroupPayment(),
            ],
          ),
        ),
        const SizedBox(width: 18),
        Expanded(child: _buildPaymentMethods()),
      ],
    );
  }

  Widget _buildMobileContent() {
    return Column(
      children: [
        _buildOrderSummary(),
        const SizedBox(height: 18),
        _buildPaymentMethods(),
        const SizedBox(height: 18),
        _buildGroupPayment(),
      ],
    );
  }

  Widget _buildOrderSummary() {
    const orders = [
      _OrderLine('Khách sạn', '3 đêm gần biển Mỹ Khê', 3800000),
      _OrderLine('Vé/hoạt động', 'Bà Nà Hills, Hội An', 3200000),
      _OrderLine('Di chuyển', 'Chuyến bay khứ hồi', 3000000),
    ];
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(Icons.receipt_long_rounded, 'Tóm tắt đơn'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F6F3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    _trip.destination.imagePath,
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    semanticLabel: _trip.destination.name,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _trip.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${_trip.destination.name} • ${_trip.days} ngày ${_trip.nights} đêm • ${_trip.people} người',
                        style: const TextStyle(color: Color(0xFF45625F)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...orders.map(
            (order) => Padding(
              padding: const EdgeInsets.only(bottom: 11),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          order.detail,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF61717D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatVnd(order.amount),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 24),
          _amountLine('Tạm tính', _trip.bookingSubtotal),
          const SizedBox(height: 8),
          _amountLine('Phí dịch vụ', _trip.serviceFee),
          const SizedBox(height: 8),
          _amountLine(
            'Giảm giá',
            -_trip.discount,
            valueColor: const Color(0xFF00897B),
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Tổng thanh toán',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                formatVnd(_trip.totalPayment),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF007C73),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final methods = <_MethodInfo>[
      const _MethodInfo(
        _PaymentMethod.wallet,
        Icons.account_balance_wallet_rounded,
        'Ví điện tử',
        'Thanh toán nhanh, bảo mật',
      ),
      const _MethodInfo(
        _PaymentMethod.card,
        Icons.credit_card_rounded,
        'Thẻ ngân hàng',
        'Visa, Mastercard, thẻ nội địa',
      ),
      const _MethodInfo(
        _PaymentMethod.transfer,
        Icons.account_balance_rounded,
        'Chuyển khoản',
        'Xác nhận sau khi nhận tiền',
      ),
      const _MethodInfo(
        _PaymentMethod.later,
        Icons.schedule_rounded,
        'Thanh toán sau',
        'Giữ chỗ trong 24 giờ',
      ),
    ];
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(Icons.payments_rounded, 'Phương thức thanh toán'),
          const SizedBox(height: 8),
          const Text(
            'Chọn một phương thức phù hợp với bạn',
            style: TextStyle(color: Color(0xFF61717D)),
          ),
          const SizedBox(height: 14),
          RadioGroup<_PaymentMethod>(
            groupValue: _selectedMethod,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedMethod = value);
              }
            },
            child: Column(children: methods.map(_methodTile).toList()),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1FAF8),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  color: Color(0xFF007C73),
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Thông tin thanh toán được bảo vệ an toàn.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _methodTile(_MethodInfo method) {
    final isSelected = method.method == _selectedMethod;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => _selectedMethod = method.method),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFEAF7F5) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF007C73)
                    : const Color(0xFFE0ECEA),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: isSelected
                      ? const Color(0xFF007C73)
                      : const Color(0xFFE7F6F3),
                  child: Icon(
                    method.icon,
                    color: isSelected ? Colors.white : const Color(0xFF007C73),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.name,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        method.detail,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF61717D),
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<_PaymentMethod>(
                  value: method.method,
                  activeColor: const Color(0xFF007C73),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupPayment() {
    const members = [
      _PaymentMember('Ngân', 'Đã thanh toán', true, Color(0xFFE16666)),
      _PaymentMember('Linh', 'Đã thanh toán', true, Color(0xFF9B59B6)),
      _PaymentMember('Huy', 'Đã thanh toán', true, Color(0xFFF4A261)),
      _PaymentMember('Minh', 'Chờ thanh toán', false, Color(0xFF5B8DEF)),
    ];
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(Icons.groups_rounded, 'Group Payment'),
          const SizedBox(height: 7),
          const Text(
            'Tổng 4.000.000đ / 4 người',
            style: TextStyle(color: Color(0xFF61717D)),
          ),
          const SizedBox(height: 14),
          ...members.map(
            (member) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: member.color,
                    child: Text(
                      member.name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      member.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Text(
                    '1.000.000đ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 9),
                  Icon(
                    member.paid
                        ? Icons.check_circle_rounded
                        : Icons.pending_rounded,
                    size: 18,
                    color: member.paid
                        ? const Color(0xFF00897B)
                        : const Color(0xFFE77B00),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: .75,
              minHeight: 9,
              backgroundColor: Color(0xFFE0ECEA),
              valueColor: AlwaysStoppedAnimation(Color(0xFF00897B)),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Đã thanh toán 3/4 thành viên',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF007C73),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayButton() {
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
        child: ElevatedButton.icon(
          onPressed: _isPaid ? null : _confirmPayment,
          icon: Icon(_isPaid ? Icons.check_circle_rounded : Icons.lock_rounded),
          label: Text(
            _isPaid
                ? 'Đã thanh toán thành công'
                : 'Thanh toán ${formatVnd(_trip.totalPayment)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007C73),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFFD5E9E5),
            disabledForegroundColor: const Color(0xFF315E5A),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
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

  Widget _title(IconData icon, String title) {
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
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF10233F),
          ),
        ),
      ],
    );
  }

  Widget _amountLine(String label, int value, {Color? valueColor}) {
    final isDiscount = value < 0;
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Color(0xFF526273))),
        ),
        Text(
          '${isDiscount ? '-' : ''}${formatVnd(value.abs())}',
          style: TextStyle(fontWeight: FontWeight.w700, color: valueColor),
        ),
      ],
    );
  }

  void _confirmPayment() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF00897B),
          size: 46,
        ),
        title: const Text('Thanh toán thành công'),
        content: Text(
          'Vietway đã ghi nhận ${formatVnd(_trip.totalPayment)} cho ${_trip.name}.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() => _isPaid = true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thanh toán thành công')),
              );
            },
            child: const Text('Hoàn tất'),
          ),
        ],
      ),
    );
  }
}

enum _PaymentMethod { wallet, card, transfer, later }

class _MethodInfo {
  const _MethodInfo(this.method, this.icon, this.name, this.detail);

  final _PaymentMethod method;
  final IconData icon;
  final String name;
  final String detail;
}

class _OrderLine {
  const _OrderLine(this.title, this.detail, this.amount);

  final String title;
  final String detail;
  final int amount;
}

class _PaymentMember {
  const _PaymentMember(this.name, this.status, this.paid, this.color);

  final String name;
  final String status;
  final bool paid;
  final Color color;
}
