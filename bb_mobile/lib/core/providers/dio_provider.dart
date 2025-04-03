import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bb_mobile/core/constants/dio_client.dart';

final dioProvider = Provider<Dio>((ref) => DioClient.instance);
