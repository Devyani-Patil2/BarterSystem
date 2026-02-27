import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../config/theme.dart';
import '../../providers/app_state.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  String _currentOtp = '';

  void _verifyOtp() async {
    if (_currentOtp.length != 6) return;

    final appState = context.read<AppState>();
    final success = await appState.verifyOtp(_currentOtp);

    if (!mounted) return;
    if (success) {
      Navigator.pushReplacementNamed(
        context,
        '/profile-setup',
        arguments: widget.phoneNumber,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP. Please try again.'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AppState>().isLoading;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                const SizedBox(height: 40),
                FadeInDown(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.sms_outlined,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                FadeInLeft(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Verify OTP',
                    style: GoogleFonts.outfit(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeInLeft(
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    'Enter the 6-digit code sent to\n+91 ${widget.phoneNumber}',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // OTP Input
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        PinCodeTextField(
                          appContext: context,
                          length: 6,
                          controller: _otpController,
                          animationType: AnimationType.scale,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(12),
                            fieldHeight: 54,
                            fieldWidth: 44,
                            activeFillColor: Colors.grey.shade50,
                            inactiveFillColor: Colors.grey.shade100,
                            selectedFillColor: AppTheme.primaryGreen.withValues(alpha: 0.05),
                            activeColor: AppTheme.primaryGreen,
                            inactiveColor: Colors.grey.shade300,
                            selectedColor: AppTheme.primaryGreen,
                          ),
                          enableActiveFill: true,
                          textStyle: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                          onChanged: (value) {
                            setState(() => _currentOtp = value);
                          },
                          onCompleted: (value) {
                            _currentOtp = value;
                            _verifyOtp();
                          },
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: (isLoading || _currentOtp.length != 6)
                                ? null
                                : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'Verify & Continue',
                                    style: GoogleFonts.outfit(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Didn\'t receive code? ',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AppState>().sendOtp(widget.phoneNumber);
                              },
                              child: Text(
                                'Resend OTP',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Center(
                    child: Text(
                      'Tip: Enter any 6 digits for demo',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
