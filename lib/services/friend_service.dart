// lib/services/friend_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send a friend request
  Future<void> sendFriendRequest(
      String senderId, String receiverUsername) async {
    try {
      // Look up receiver's userId by username
      final receiverQuery = await _firestore
          .collection('usernames')
          .doc(receiverUsername.toLowerCase())
          .get();
      if (!receiverQuery.exists) throw Exception('User not found');
      final receiverId = receiverQuery.data()!['userId'] as String;

      // Prevent sending request to self
      if (senderId == receiverId)
        throw Exception('Cannot send request to yourself');

      // Check if already friends
      final alreadyFriends = await _firestore
          .collection('users')
          .doc(senderId)
          .collection('friends')
          .doc(receiverId)
          .get();
      if (alreadyFriends.exists) throw Exception('Already friends');

      // Check if request already exists
      final existingRequest = await _firestore
          .collection('users')
          .doc(receiverId)
          .collection('friend_requests')
          .doc(senderId)
          .get();
      if (existingRequest.exists)
        throw Exception('Friend request already sent');

      // Send the friend request
      await _firestore
          .collection('users')
          .doc(receiverId)
          .collection('friend_requests')
          .doc(senderId)
          .set({
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint(
          'Friend request sent from $senderId to $receiverId ($receiverUsername)');
    } catch (e) {
      debugPrint('Error sending friend request: $e');
      rethrow;
    }
  }

  // Accept a friend request
  Future<void> acceptFriendRequest(String userId, String senderId) async {
    try {
      // Start a batch write for atomic updates
      final batch = _firestore.batch();

      // Add sender to user's friends list
      final userFriendRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(senderId);
      batch.set(userFriendRef, {
        'friendId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Add user to sender's friends list
      final senderFriendRef = _firestore
          .collection('users')
          .doc(senderId)
          .collection('friends')
          .doc(userId);
      batch.set(senderFriendRef, {
        'friendId': userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Remove the friend request
      final requestRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('friend_requests')
          .doc(senderId);
      batch.delete(requestRef);

      // Commit the batch
      await batch.commit();
      debugPrint('Friendship established between $userId and $senderId');
    } catch (e) {
      debugPrint('Error accepting friend request: $e');
      rethrow;
    }
  }

  // Reject a friend request
  Future<void> rejectFriendRequest(String userId, String senderId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('friend_requests')
          .doc(senderId)
          .delete();
      debugPrint(
          'Friend request rejected: $senderId removed from $userId requests');
    } catch (e) {
      debugPrint('Error rejecting friend request: $e');
      rethrow;
    }
  }

  // Get pending friend requests
  Stream<List<Map<String, dynamic>>> getFriendRequests(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('friend_requests')
        .snapshots()
        .map((snapshot) {
      debugPrint('Fetched ${snapshot.docs.length} friend requests for $userId');
      return snapshot.docs.map((doc) => doc.data()).toList();
    }).handleError((error) {
      debugPrint('Error fetching friend requests: $error');
      throw error;
    });
  }

  // Get friends list
  Stream<List<Map<String, dynamic>>> getFriends(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .snapshots()
        .map((snapshot) {
      debugPrint('Fetched ${snapshot.docs.length} friends for $userId');
      return snapshot.docs.map((doc) => doc.data()).toList();
    }).handleError((error) {
      debugPrint('Error fetching friends: $error');
      throw error;
    });
  }

  // Fetch user details (username from Firestore, PFP from Firebase Auth)
  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      debugPrint('Fetching details for userId: $userId');
      final userDoc = await _firestore.collection('users').doc(userId).get();
      String? username;
      String? pfpUrl;
      if (userDoc.exists) {
        username = userDoc.data()?['username'] as String?;
        pfpUrl =
            userDoc.data()?['photoURL'] as String?; // Synced from Firebase Auth
        debugPrint('Firestore data: username=$username, photoURL=$pfpUrl');
      }

      // Fallback to Firebase Auth for PFP if not in Firestore
      if (pfpUrl == null && _auth.currentUser?.uid == userId) {
        pfpUrl = _auth.currentUser?.photoURL;
        debugPrint('Using Firebase Auth photoURL: $pfpUrl');
      }

      if (username == null) {
        debugPrint('No username found for $userId');
        return null;
      }

      return {
        'username': username,
        'profilePictureUrl': pfpUrl,
      };
    } catch (e) {
      debugPrint('Error fetching user details for $userId: $e');
      return null;
    }
  }

  Future<String?> getUsername(String userId) async {
    final details = await getUserDetails(userId);
    return details?['username'];
  }
}
