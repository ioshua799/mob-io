import 'package:ecommerce_app/dashboard_screen.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/custom_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              
              // Burger Station Header Icon
              const Center(
                child: Icon(
                  Icons.fastfood_rounded,
                  size: 64,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "BURGER STATION",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Sign Up / Log In Toggle Bar
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isSignUp = false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isSignUp ? AppColors.primaryPurple : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: !isSignUp ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isSignUp = true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSignUp ? AppColors.primaryPurple : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: isSignUp ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Screen Title
              Text(
                isSignUp ? "Join Burger Station" : "Welcome Back",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isSignUp
                    ? "Create an account to start ordering your favorite burgers."
                    : "Enter your details to track orders and rewards.",
                style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Form Inputs
              if (isSignUp) ...[
                const CustomTextField(
                  label: "Full Name",
                  hint: "John Doe",
                ),
                const SizedBox(height: 16),
              ],
              const CustomTextField(
                label: "Email Address",
                hint: "burger.lover@example.com",
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                label: "Password",
                hint: "••••••••",
                isPassword: true,
                suffixIcon: Icons.visibility_off_outlined,
              ),
              const SizedBox(height: 28),

              // Action Button
              ElevatedButton(
                onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const DashboardScreen()),
  );
},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isSignUp ? "Create Account" : "Log In",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}