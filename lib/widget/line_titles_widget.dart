import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 35,
          getTextStyles: (_, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
                case 0:
                return '0H';
              case 1:
                return '2H';
              case 2:
                return '4H';
              case 3:
                return '6HH';
                case 4:
                return '8H';
                case 5:
                return '10H';
                case 6:
                return '12H';
                case 7:
                return '14H';
                case 8:
                return '16H';
                case 9:
                return '18H';
                case 10:
                return '20H';
                case 11:
                return '22H';
                case 12:
                return '24H';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (_, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0 L';
              case 1:
                return '100L';
              case 2:
                return '200L';
              case 3:
                return '300L';
              case 4:
                return '400L';
              case 5:
                return '500L';
              case 6:
                return '600L';
              case 7:
                return '700L';
                case 8:
                return '800L';
            }
            return '';
          },
          reservedSize: 35,
          margin: 12,
        ),
      );
}
