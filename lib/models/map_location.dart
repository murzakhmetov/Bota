import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MapLocation {
  final String id;
  final String nameKz;
  final String nameRu;
  final String descriptionKz;
  final String descriptionRu;
  final String icon;
  final Color color;
  final Offset mapPosition;
  final List<String> gameIds;
  final int requiredLevel;

  const MapLocation({
    required this.id,
    required this.nameKz,
    required this.nameRu,
    required this.descriptionKz,
    required this.descriptionRu,
    required this.icon,
    required this.color,
    required this.mapPosition,
    required this.gameIds,
    this.requiredLevel = 1,
  });

  static const List<MapLocation> allLocations = [
    MapLocation(
      id: 'almaty',
      nameKz: 'Алматы',
      nameRu: 'Алматы',
      descriptionKz: 'Тау бөктеріндегі алма бақтары',
      descriptionRu: 'Яблоневые сады у подножия гор',
      icon: '🏔️',
      color: AppColors.almaty,
      mapPosition: Offset(0.65, 0.72),
      gameIds: ['memory', 'math', 'catch'],
    ),
    MapLocation(
      id: 'astana',
      nameKz: 'Астана',
      nameRu: 'Астана',
      descriptionKz: 'Бәйтерек - өмір ағашы',
      descriptionRu: 'Байтерек - дерево жизни',
      icon: '🏛️',
      color: AppColors.astana,
      mapPosition: Offset(0.52, 0.42),
      gameIds: ['words', 'quiz'],
    ),
    MapLocation(
      id: 'turkestan',
      nameKz: 'Түркістан',
      nameRu: 'Туркестан',
      descriptionKz: 'Қожа Ахмет Яссауи кесенесі',
      descriptionRu: 'Мавзолей Ходжи Ахмеда Яссауи',
      icon: '🕌',
      color: AppColors.turkestan,
      mapPosition: Offset(0.38, 0.68),
      gameIds: ['puzzle', 'words'],
      requiredLevel: 2,
    ),
    MapLocation(
      id: 'charyn',
      nameKz: 'Шарын',
      nameRu: 'Чарын',
      descriptionKz: 'Шарын шатқалы - табиғат кереметі',
      descriptionRu: 'Чарынский каньон - чудо природы',
      icon: '🏜️',
      color: AppColors.charyn,
      mapPosition: Offset(0.75, 0.60),
      gameIds: ['quest', 'catch'],
      requiredLevel: 3,
    ),
    MapLocation(
      id: 'steppe',
      nameKz: 'Ұлы Дала',
      nameRu: 'Великая Степь',
      descriptionKz: 'Қазақ даласының сұлулығы',
      descriptionRu: 'Красота казахской степи',
      icon: '⛺',
      color: AppColors.steppe,
      mapPosition: Offset(0.35, 0.35),
      gameIds: ['memory', 'math', 'puzzle'],
      requiredLevel: 2,
    ),
  ];
}
