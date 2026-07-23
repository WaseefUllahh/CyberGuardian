import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/scan_model.dart';

void main() {
  group('ScanModel', () {
    final timestamp = Timestamp.now();

    test('toMap() returns a valid map', () {
      final model = ScanModel(
        id: 'doc123',
        userId: 'user123',
        url: 'https://example.com',
        result: 'Safe',
        threatLevel: 'Low',
        provider: 'VirusTotal',
        scanDate: '2023-10-01',
        scanTime: '12:00 PM',
        createdAt: timestamp,
      );

      final map = model.toMap();

      expect(map['userId'], 'user123');
      expect(map['url'], 'https://example.com');
      expect(map['result'], 'Safe');
      expect(map['threatLevel'], 'Low');
      expect(map['provider'], 'VirusTotal');
      expect(map['scanDate'], '2023-10-01');
      expect(map['scanTime'], '12:00 PM');
      expect(map['createdAt'], timestamp);
      expect(map.containsKey('id'), isFalse); // ID shouldn't be serialized to fields
    });

    test('fromMap() creates a valid model from map', () {
      final map = {
        'userId': 'user456',
        'url': 'https://phishing.com',
        'result': 'Suspicious',
        'threatLevel': 'High',
        'provider': 'UrlScan',
        'scanDate': '2023-10-02',
        'scanTime': '01:00 PM',
        'createdAt': timestamp,
      };

      final model = ScanModel.fromMap(map, 'doc456');

      expect(model.id, 'doc456');
      expect(model.userId, 'user456');
      expect(model.url, 'https://phishing.com');
      expect(model.result, 'Suspicious');
      expect(model.threatLevel, 'High');
      expect(model.provider, 'UrlScan');
      expect(model.scanDate, '2023-10-02');
      expect(model.scanTime, '01:00 PM');
      expect(model.createdAt, timestamp);
    });

    test('fromMap() handles missing fields gracefully', () {
      final map = <String, dynamic>{};
      final model = ScanModel.fromMap(map, 'doc789');

      expect(model.id, 'doc789');
      expect(model.userId, '');
      expect(model.url, '');
      expect(model.result, 'Safe'); // Default
      expect(model.threatLevel, 'Low'); // Default
      expect(model.provider, 'VirusTotal'); // Default
      expect(model.scanDate, '');
      expect(model.scanTime, '');
      expect(model.createdAt, isA<Timestamp>());
    });
  });
}
