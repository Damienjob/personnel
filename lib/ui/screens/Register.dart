import 'package:flutter/material.dart';
import 'package:projet/ui/screens/otp_screen.dart';
import 'loginPage.dart';
import 'controller/authServiceRegister.dart'; // Importez le fichier AuthService

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String? userType;
  String? transportMode;

  final AuthService _authService = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  // Fonction pour envoyer l'OTP
  Future<void> _sendOtp() async {
    String selectedCountry = "+229";
    String prefixText = "01 "; // Préfixe du numéro de téléphone
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isNotEmpty) {
      setState(() {
        isLoading = true; // Active le chargement
      });

      try {
        // Nettoyer le prefixText pour enlever les espaces superflus
        String cleanedPrefixText = prefixText.trim();

        // Passer les trois arguments et récupérer verificationId
        String verificationId = await _authService.sendOtpVerificationCode(
          selectedCountry,
          cleanedPrefixText, // Passer le prefixText nettoyé
          phoneNumber,
        );

        setState(() {
          isLoading = false; // Désactive le chargement
        });

        // Redirige vers la page OTP
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
      } catch (e) {
        setState(() {
          isLoading = false; // Désactive le chargement en cas d'erreur
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez entrer un numéro de téléphone valide.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
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
                  'Création de compte',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Partie principale de la page
            Padding(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                            "INSCRIPTION",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .white, // La couleur doit être définie ici pour que le ShaderMask fonctionne
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      // Champs pour le nom et le prénom
                      const Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                label: Text(
                                  'Nom',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff004aad),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                label: Text(
                                  'Prénom',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff004aad),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 23),

                      // Champ "Téléphone" avec indicatif et préfixe non modifiables
                      Row(
                        children: [
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
                          const Expanded(
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                prefixText: '01 ', // Préfixe non modifiable
                                prefixStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                labelText: 'Téléphone',
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff004aad),
                                ),

                                suffixIcon: Icon(
                                  Icons.check,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 23),

                      // Dropdown pour le type d'utilisateur
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Type d\'utilisateur',
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff004aad),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'client',
                            child: Text(
                              'CLIENT',
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'transporteur',
                            child: Text('TRANSPORTEUR'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            userType = value;
                            if (value != 'transporteur') {
                              transportMode = null;
                            }
                          });
                        },
                        value: userType,
                      ),

                      // Dropdown pour le mode de transport si transporteur
                      if (userType == 'transporteur') ...[
                        const SizedBox(height: 23),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Moyen de transport',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff004aad),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'moto',
                              child: Row(
                                children: [
                                  Icon(Icons.motorcycle, color: Colors.black),
                                  SizedBox(width: 10),
                                  Text('Moto'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'tricycle',
                              child: Row(
                                children: [
                                  Icon(Icons.electric_rickshaw,
                                      color: Colors.black),
                                  SizedBox(width: 10),
                                  Text('Tricycle'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'voiture',
                              child: Row(
                                children: [
                                  Icon(Icons.directions_car,
                                      color: Colors.black),
                                  SizedBox(width: 10),
                                  Text('Voiture'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              transportMode = value;
                            });
                          },
                          value: transportMode,
                        ),
                      ],

                      const SizedBox(height: 70),

                      // Bouton "S'inscrire"
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
                        child: const Center(
                          child: Text(
                            "S'inscrire",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),

                      // Lien vers la connexion
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Vous avez un compte ?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Se connecter",
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
          ],
        ),
      ),
    );
  }
}
