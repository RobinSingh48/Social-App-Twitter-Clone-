import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDateTime(Timestamp timestamp) {
  DateTime time = timestamp.toDate();
  return DateFormat("MMM d, yyyy h:mm a").format(time);
}
