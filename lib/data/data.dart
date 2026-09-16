import 'package:flutter/material.dart';

import '../models/destination.dart';
import '../models/trip.dart';

class TripData {
  TripData._();

  static const daNang = Destination(
    name: 'Đà Nẵng',
    description: 'Biển xanh – Thành phố đáng sống',
    imagePath: 'assets/images/destinations/da_nang.jpg',
    discountLabel: 'Giảm đến 40%',
  );

  static const phuQuoc = Destination(
    name: 'Phú Quốc',
    description: 'Thiên đường nghỉ dưỡng',
    imagePath: 'assets/images/destinations/phu_quoc.jpg',
    discountLabel: 'Giảm đến 35%',
  );

  static const daLat = Destination(
    name: 'Đà Lạt',
    description: 'Thành phố ngàn hoa',
    imagePath: 'assets/images/destinations/da_lat.jpg',
    discountLabel: 'Giảm đến 30%',
  );

  static const promotions = [daNang, phuQuoc, daLat];

  static const categories = [
    Destination(
      name: 'Biển đảo',
      description: 'Nắng vàng, biển xanh',
      imagePath: 'assets/images/categories/bien_dao.jpg',
    ),
    Destination(
      name: 'Thiên nhiên',
      description: 'Chạm vào màu xanh',
      imagePath: 'assets/images/categories/thien_nhien.jpg',
    ),
    Destination(
      name: 'Văn hóa – Lịch sử',
      description: 'Dấu ấn Việt Nam',
      imagePath: 'assets/images/categories/van_hoa.jpg',
    ),
    Destination(
      name: 'Ẩm thực',
      description: 'Hương vị bản địa',
      imagePath: 'assets/images/categories/am_thuc.jpg',
    ),
    Destination(
      name: 'Cắm trại',
      description: 'Một đêm giữa thiên nhiên',
      imagePath: 'assets/images/categories/cam_trai.jpg',
    ),
    Destination(
      name: 'Du lịch gia đình',
      description: 'Kỷ niệm bên người thân',
      imagePath: 'assets/images/categories/gia_dinh.jpg',
    ),
    Destination(
      name: 'Du lịch nhóm',
      description: 'Đi cùng hội bạn',
      imagePath: 'assets/images/categories/du_lich_nhom.jpg',
    ),
  ];

  static const inspiration = [
    Destination(
      name: 'Hà Giang',
      description: 'Chạm mây nơi cực Bắc',
      imagePath: 'assets/images/banners/ha_giang.jpg',
    ),
    Destination(
      name: 'Ninh Bình',
      description: 'Non nước hữu tình',
      imagePath: 'assets/images/banners/ninh_binh.jpg',
    ),
    Destination(
      name: 'Hội An',
      description: 'Phố cổ lên đèn',
      imagePath: 'assets/images/banners/hoi_an.jpg',
    ),
  ];

  static const demoTrip = Trip(
    name: 'Chuyến đi Đà Nẵng',
    destination: daNang,
    days: 4,
    nights: 3,
    people: 2,
    budget: 10000000,
    bookingSubtotal: 10000000,
    serviceFee: 150000,
    discount: 200000,
  );

  static Trip tripForDestination(Destination destination) {
    return Trip(
      name: 'Chuyến đi ${destination.name}',
      destination: destination,
      days: 4,
      nights: 3,
      people: 2,
      budget: 10000000,
      bookingSubtotal: 10000000,
      serviceFee: 150000,
      discount: 200000,
    );
  }

  static List<ScheduleActivity> schedule() {
    return [
      ScheduleActivity(
        day: 1,
        time: '14:00',
        title: 'Check-in khách sạn',
        detail: 'Nhận phòng, nghỉ ngơi',
        icon: Icons.hotel_rounded,
      ),
      ScheduleActivity(
        day: 1,
        time: '18:30',
        title: 'Ăn tối',
        detail: 'Thưởng thức đặc sản Đà Nẵng',
        icon: Icons.restaurant_rounded,
      ),
      ScheduleActivity(
        day: 1,
        time: '20:00',
        title: 'Cầu Rồng',
        detail: 'Dạo sông Hàn về đêm',
        icon: Icons.account_balance_rounded,
      ),
      ScheduleActivity(
        day: 2,
        time: '08:00',
        title: 'Bà Nà Hills',
        detail: 'Cáp treo, Cầu Vàng',
        icon: Icons.terrain_rounded,
      ),
      ScheduleActivity(
        day: 2,
        time: '14:00',
        title: 'Cafe',
        detail: 'Nghỉ chân, ngắm thành phố',
        icon: Icons.local_cafe_rounded,
      ),
      ScheduleActivity(
        day: 2,
        time: '17:00',
        title: 'Biển Mỹ Khê',
        detail: 'Tắm biển lúc hoàng hôn',
        icon: Icons.beach_access_rounded,
      ),
      ScheduleActivity(
        day: 2,
        time: '20:00',
        title: 'Cầu Rồng',
        detail: 'Xem cầu phun lửa cuối tuần',
        icon: Icons.account_balance_rounded,
      ),
      ScheduleActivity(
        day: 3,
        time: '09:00',
        title: 'Hội An',
        detail: 'Tham quan phố cổ',
        icon: Icons.map_rounded,
      ),
      ScheduleActivity(
        day: 3,
        time: '12:30',
        title: 'Ăn uống',
        detail: 'Cao lầu và cơm gà Hội An',
        icon: Icons.lunch_dining_rounded,
      ),
      ScheduleActivity(
        day: 3,
        time: '15:00',
        title: 'Tham quan',
        detail: 'Chùa Cầu và làng nghề',
        icon: Icons.camera_alt_rounded,
      ),
    ];
  }
}

String formatVnd(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[index]);
  }
  return '$bufferđ';
}
