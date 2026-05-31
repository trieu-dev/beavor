import 'dart:ui';

class Member {
  final String id;
  final String name;
  final Color avatarColor;

  const Member({
    required this.id,
    required this.name,
    required this.avatarColor,
  });

  /// Extract initials from Vietnamese name (first char of last two words)
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[parts.length - 2][0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }
}

// Sample data matching the Stitch mockup
final List<Member> allMembers = [
  Member(
    id: '1',
    name: 'Linh Trinh',
    avatarColor: Color(0xFF818CF8),
  ),
  Member(
    id: '2',
    name: 'Trang Le',
    avatarColor: Color(0xFF34D399),
  ),
  Member(
    id: '3',
    name: 'Vu Vo',
    avatarColor: Color(0xFFFB7185),
  ),
  Member(
    id: '4',
    name: 'Huy Nguyen',
    avatarColor: Color(0xFFF59E0B),
  ),
  Member(
    id: '5',
    name: 'Toan Nguyen',
    avatarColor: Color(0xFF06B6D4),
  ),
  Member(
    id: '6',
    name: 'Khang Bui',
    avatarColor: Color(0xFFA78BFA),
  ),
  Member(
    id: '7',
    name: 'Tri Vu',
    avatarColor: Color(0xFF2DD4BF),
  ),
  Member(
    id: '8',
    name: 'Trieu Le',
    avatarColor: Color(0xFFFF6B6B),
  ),
  Member(
    id: '9',
    name: 'Huy Tran',
    avatarColor: Color(0xFF818CF8),
  ),
  Member(
    id: '10',
    name: 'Minh Vu',
    avatarColor: Color(0xFF34D399),
  ),
  Member(
    id: '11',
    name: 'Quang Tran',
    avatarColor: Color(0xFFFB7185),
  ),
  Member(
    id: '12',
    name: 'Hoang Tran',
    avatarColor: Color(0xFFF59E0B),
  ),
  Member(
    id: '13',
    name: 'Khoa Vo',
    avatarColor: Color(0xFF06B6D4),
  ),
  Member(
    id: '14',
    name: 'Duy Le',
    avatarColor: Color(0xFFA78BFA),
  ),
  Member(
    id: '15',
    name: 'Nam Tran',
    avatarColor: Color(0xFF2DD4BF),
  ),
  Member(
    id: '16',
    name: 'Hiep Lam',
    avatarColor: Color(0xFFFF6B6B),
  ),
  Member(
    id: '17',
    name: 'Phong Phan',
    avatarColor: Color(0xFF34D399),
  ),
  Member(
    id: '18',
    name: 'Vu Pham',
    avatarColor: Color(0xFFFB7185),
  ),
  Member(
    id: '19',
    name: 'Thy Nguyen',
    avatarColor: Color(0xFFF59E0B),
  ),
  Member(
    id: '20',
    name: 'Tien Vu',
    avatarColor: Color(0xFF06B6D4),
  ),
  Member(
    id: '21',
    name: 'Tuyen Dinh',
    avatarColor: Color(0xFFA78BFA),
  ),
  Member(
    id: '22',
    name: 'Mai Pho',
    avatarColor: Color(0xFF2DD4BF),
  ),
  Member(
    id: '23',
    name: 'Hau Tran',
    avatarColor: Color(0xFFFF6B6B),
  ),
];

List<String> getNames(List<String> ids) {
  return allMembers.where((m) => ids.contains(m.id)).map((x) => x.name).toList();
}