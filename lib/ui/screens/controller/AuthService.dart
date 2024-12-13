import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> sendVerificationCodeForRegistration(
      String countryCode, String prefixText, String phoneNumber) async {
    // Nettoyer prefixText pour enlever les espaces superflus
    String cleanedPrefixText = prefixText.trim();
    // Construire le numéro complet
    String fullPhoneNumber = countryCode + cleanedPrefixText + phoneNumber;

    String verificationId = ''; // Initialiser la variable pour le retour

    try {
      debugPrint(
          'Numéro complet : $fullPhoneNumber'); // Débogage du numéro complet

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _firebaseAuth.signInWithCredential(credential);
          debugPrint('Vérification automatique réussie.');
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            debugPrint('Le numéro de téléphone est invalide.');
          } else {
            debugPrint("Erreur lors de l'envoi du code : ${e.message}");
          }
        },
        codeSent: (String sentVerificationId, int? resendToken) {
          verificationId = sentVerificationId; // Capturer verificationId
          debugPrint('Code envoyé au numéro $fullPhoneNumber.');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Délai dépassé pour la récupération automatique du code.');
        },
      );
    } catch (e) {
      debugPrint('Erreur lors de la vérification du numéro : $e');
    }

    return verificationId; // Retourner verificationId
  }

  }
