import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
// Envoi du code de vérification pour l'inscription
  Future<String> sendOtpVerificationCode(
      String countryCode, String prefixText, String phoneNumber) async {
    // Construire le numéro complet en utilisant les 3 parties
    String fullPhoneNumber = countryCode + prefixText + phoneNumber;

    String verificationId = ''; // Initialiser la variable pour le retour

    try {
      debugPrint(
          'Numéro complet : $fullPhoneNumber'); // Débogage du numéro complet

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Si la vérification est réussie automatiquement, connectez l'utilisateur
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

  /// Fonction pour afficher une alerte à l'utilisateur après la validation du code OTP
  Future<void> showUserCanRegisterAlert(
      String verificationId, String otp, BuildContext context) async {
    try {
      // Créer les credentials avec le code OTP
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      // Afficher un message d'alerte indiquant que l'utilisateur peut être enregistré
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Vérification réussie'),
            content: const Text(
                'Vous pouvez maintenant enregistrer cet utilisateur.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer l'alerte
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint("Erreur dans la validation du code OTP : $e");
      // Afficher une erreur générique
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une erreur inconnue s\'est produite')),
      );
    }
  }
}
