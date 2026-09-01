import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';

import 'recylingIdeas.dart';

class scannerPage extends StatefulWidget {
  final int userId;
  final int points;

  const scannerPage({
    super.key,
    required this.userId,
    required this.points,
  });

  @override
  State<scannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<scannerPage> {
  final ImagePicker _picker = ImagePicker();

  bool _isPickingImage = false;

  File? _selectedImage;

  bool _isScanning = false;

  static const Color mainGreen = Color(0xFFA9C19F);
  static const Color darkGreen = Color(0xFF758B72);
  static const Color lightGreen = Color(0xFFEAF2D4);



  Future<void> _pickImageFromGallery() async {
    if (_isPickingImage || _isScanning) return;

    _isPickingImage = true;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _selectedImage = File(image.path);
      });

      await _scanImage();
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Failed to open gallery: $e',
      );
    } finally {
      _isPickingImage = false;
    }
  }


  Future<void> _takePhoto() async {
    if (_isPickingImage || _isScanning) return;

    _isPickingImage = true;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() {
        _selectedImage = File(image.path);
      });

      await _scanImage();
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Failed to open camera: $e',
      );
    } finally {
      _isPickingImage = false;
    }
  }


  Future<void> _scanImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isScanning = true;
    });

    try {
      final Uri uri = Uri.parse(
        'http://10.0.2.2/eltrack_recycling/scannerApi/scanner.php',
      );

      final http.MultipartRequest request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
        ),
      );

      final http.StreamedResponse streamedResponse =
          await request.send();

      final http.Response response =
          await http.Response.fromStream(streamedResponse);

      final dynamic decoded = jsonDecode(response.body);

      if (!mounted) return;

      if (decoded is! Map<String, dynamic>) {
        _showMessage('Invalid response from scanner');
        return;
      }

      if (decoded['success'] != true) {
        _showMessage(
          '${decoded['message'] ?? 'Failed to detect waste'}\n'
          '${decoded['api_response'] ?? decoded['error'] ?? ''}',
        );

        return;
      }

      final Map<String, dynamic> recognition =
          Map<String, dynamic>.from(
        decoded['recognition'] ?? {},
      );

      final String? matchedItem =
          decoded['matched_item']?.toString();

      final List<dynamic> ideas = List<dynamic>.from(
        decoded['ideas'] ?? [],
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => recylingIdeas(
            userId: widget.userId,
            points: widget.points,
            recognition: recognition,
            matchedItem: matchedItem,
            ideas: ideas,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Scanner error: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  30,
                  30,
                  30,
                  25,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    25,
                    25,
                    25,
                    40,
                  ),
                  decoration: BoxDecoration(
                    color: mainGreen,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Product Detection',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Scan your waste item to categorize it\n'
                        'automatically and to get recycling tips & ideas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          height: 1.5,
                          letterSpacing: 0.8,
                        ),
                      ),

                      const SizedBox(height: 55),

                      _buildScannerFrame(),

                      const SizedBox(height: 30),

                      _buildUploadButton(),

                      const SizedBox(height: 25),

                      _buildCameraButton(),

                      if (_isScanning) ...[
                        const SizedBox(height: 25),

                        const CircularProgressIndicator(
                          color: Colors.white,
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Detecting waste...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            EltrackBottomNav(
              currentIndex: 1,

              onHome: () {
                Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                );
              },

              onScanner: () {
                // masih berada di fitur scanner
              },

              onStore: () {
                // nanti arahkan ke Store
              },

              onProfile: () {
                // nanti arahkan ke Profile
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildScannerFrame() {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(5),
              ),
              clipBehavior: Clip.antiAlias,
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Icon(
                        Icons.recycling,
                        size: 85,
                        color: darkGreen,
                      ),
                    ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            child: _scannerCorner(
              top: true,
              left: true,
            ),
          ),

          Positioned(
            top: 0,
            right: 0,
            child: _scannerCorner(
              top: true,
              left: false,
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            child: _scannerCorner(
              top: false,
              left: true,
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: _scannerCorner(
              top: false,
              left: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _scannerCorner({
    required bool top,
    required bool left,
  }) {
    return SizedBox(
      width: 70,
      height: 70,
      child: Stack(
        children: [
          Positioned(
            top: top ? 0 : null,
            bottom: top ? null : 0,
            left: left ? 0 : null,
            right: left ? null : 0,
            child: Container(
              width: 70,
              height: 14,
              color: darkGreen,
            ),
          ),

          Positioned(
            top: top ? 0 : null,
            bottom: top ? null : 0,
            left: left ? 0 : null,
            right: left ? null : 0,
            child: Container(
              width: 14,
              height: 70,
              color: darkGreen,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildUploadButton() {
    return SizedBox(
      width: 195,
      height: 42,
      child: ElevatedButton.icon(
        onPressed: (
          _isScanning || _isPickingImage
        ) ? null : _pickImageFromGallery,
        icon: const Icon(
          Icons.image,
          size: 18,
        ),
        label: const Text(
          'Upload From File',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }


  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: (_isScanning || _isPickingImage)
        ? null : _takePhoto,
      child: Container(
        width: 82,
        height: 82,
        decoration: const BoxDecoration(
          color: darkGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }

  
}