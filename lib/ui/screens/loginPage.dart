import 'package:projet/ui/screens/controller/AuthService.dart';
import 'package:projet/ui/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_action.dart';
import 'package:recaptcha_enterprise_flutter/recaptcha_enterprise.dart';

import 'Register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false; // Clé de site reCAPTCHA
  final String recaptchaSiteKey =
      'YOUR_RECAPTCHA_SITE_KEY'; // Remplacez par votre propre clé

  // Fonction pour envoyer OTP
  Future<void> _sendOtp() async {
    String selectedCountry = "+229"; // Code du pays
    String prefixText = "01 "; // Préfixe du numéro de téléphone
    String phoneNumber =
        _phoneController.text.trim(); // Numéro de téléphone saisi

    if (phoneNumber.isNotEmpty) {
      setState(() {
        isLoading = true; // Affichage de l'indicateur de chargement
      });

      try {
        // Étape 1 : Vérification reCAPTCHA
        final String token = await _verifyRecaptcha();

        if (token.isNotEmpty) {
          // Étape 2 : Si reCAPTCHA validé, envoyer OTP
          String cleanedPrefixText =
              prefixText.trim(); // Nettoyer les espaces du préfixe

          // Passer les trois arguments et récupérer verificationId
          String verificationId =
              await _authService.sendVerificationCodeForRegistration(
            selectedCountry,
            cleanedPrefixText, // Passer le prefixText nettoyé
            phoneNumber,
          );

          setState(() {
            isLoading = false; // Arrêter l'indicateur de chargement
          });

          if (verificationId.isNotEmpty) {
            // Si l'envoi du code OTP est réussi, naviguer vers l'écran OTP
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  phoneNumber: phoneNumber,
                  countryCode: selectedCountry,
                  verificationId: verificationId,
                  prefixText: prefixText, // Passer verificationId
                ),
              ),
            );
          } else {
            // Si le code OTP n'a pas été envoyé correctement
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Erreur lors de l\'envoi du code OTP')),
            );
          }
        } else {
          // Si la vérification reCAPTCHA échoue
          setState(() {
            isLoading = false; // Arrêter l'indicateur de chargement
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erreur de vérification reCAPTCHA.')),
          );
        }
      } catch (e) {
        setState(() {
          isLoading =
              false; // Arrêter l'indicateur de chargement en cas d'erreur
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')), // Afficher l'erreur
        );
      }
    } else {
      // Si le numéro de téléphone est vide ou invalide
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez entrer un numéro de téléphone valide.')),
      );
    }
  }

  // Méthode pour effectuer la vérification reCAPTCHA
  Future<String> _verifyRecaptcha() async {
    try {
      // Utilisez la clé de site reCAPTCHA et exécutez l'action 'login' ou autre action spécifique
      final String token =
          await RecaptchaEnterprise.execute(RecaptchaAction.LOGIN());
      return token; // Renvoie le token de succès reCAPTCHA
    } on Exception catch (e) {
      // Si un problème survient avec reCAPTCHA
      print('Erreur reCAPTCHA: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond avec un dégradé de couleur
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff004aad),
                  Color(0xff000000),
                ],
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Bienvenue\nConnexion!',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Partie principale de la page
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.grey[200],
                ),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      // Section d'introduction
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xff004aad),
                              Color(0xff000000),
                            ],
                          ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                          child: const Text(
                            "VERIFICATION OTP",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Champ "Téléphone" avec indicatif et préfixe
                      Row(
                        children: [
                          // Indicateur de pays fixe
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 14.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '+229',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // Champ de texte pour le numéro
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixText: '01 ',
                                prefixStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                labelText: 'Téléphone',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff004aad),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 70),

                      // Bouton "Se connecter"
                      Container(
                        height: 55,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff004aad),
                              Color(0xff000000),
                            ],
                          ),
                        ),
                        child: Center(
                            child: TextButton(
                          onPressed: isLoading ? null : _sendOtp,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Se connecter',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                        )),
                      ),

                      const SizedBox(height: 20),

                      // Section explicative
                      const Text(
                        "Bénéficiez d'un accès sécurisé et rapide à vos fonctionnalités préférées.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 70),

                      // Lien vers l'inscription
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Vous n'avez pas de compte ?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Register(),
                                  ),
                                );
                              },
                              child: const Text(
                                "S'inscrire",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
        color: const Color(0xFF222222),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.facebook,
                      color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.twitter,
                      color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.instagram,
                      color: Colors.white),
                ),
              ],
            ),
            const Expanded(
              child: Text(
                'Suivez-nous sur les réseaux sociaux',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
