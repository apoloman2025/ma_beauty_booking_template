import 'package:flutter/material.dart';

class Master {
  final String id;
  final String name;
  final String title;
  final String avatarUrl;
  final double rating;
  final int reviewsCount;
  final String experience;
  final List<String> portfolioPhotos;
  final String instagram;

  const Master({
    required this.id,
    required this.name,
    required this.title,
    required this.avatarUrl,
    required this.rating,
    required this.reviewsCount,
    required this.experience,
    required this.portfolioPhotos,
    required this.instagram,
  });
}

class BeautyCategory {
  final String id;
  final String name;
  final String emoji;
  final IconData icon;

  const BeautyCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.icon,
  });
}

class BeautyService {
  final String id;
  final String name;
  final String categoryId;
  final int durationMinutes;
  final double price;
  final String currency;
  final String description;
  final List<String> masterIds;
  final bool isPopular;
  final String imageUrl;

  const BeautyService({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.durationMinutes,
    required this.price,
    this.currency = "AED",
    required this.description,
    required this.masterIds,
    this.isPopular = false,
    required this.imageUrl,
  });
}

class TimeSlot {
  final String time;
  final bool isBooked;

  const TimeSlot({
    required this.time,
    this.isBooked = false,
  });
}

class AppointmentBooking {
  final String serviceName;
  final String masterName;
  final String masterAvatar;
  final DateTime date;
  final String timeSlot;
  final double price;
  final String currency;
  final String clientName;
  final String clientPhone;
  final String clientTelegram;

  const AppointmentBooking({
    required this.serviceName,
    required this.masterName,
    required this.masterAvatar,
    required this.date,
    required this.timeSlot,
    required this.price,
    required this.currency,
    required this.clientName,
    required this.clientPhone,
    required this.clientTelegram,
  });
}
