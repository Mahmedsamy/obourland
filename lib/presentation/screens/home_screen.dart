import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/report_model.dart';
import '../bloc/report_cubit.dart';
import '../bloc/auth_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? _x;
  double? _y;
  String _date = '';
  String _time = '';
  File? _selectedImage;

  final _commentCtrl = TextEditingController();

  // ---------------------------------------------------------------------------
  // LOCATION
  // ---------------------------------------------------------------------------

  Future<void> _getCoordinates() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Enable GPS first')));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission required')));
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final now = DateTime.now();

      setState(() {
        _x = pos.latitude;
        _y = pos.longitude;

        _date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
        _time =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
      });
    } catch (e) {
      print("ERROR: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // IMAGE PICKER
  // ---------------------------------------------------------------------------

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        _selectedImage = File(img.path);
      });
    }
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              onPressed: () => context.read<AuthCubit>().logout(),
              icon: const Icon(Icons.logout))
        ],
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---------------- LOCATION CARDS ----------------
            Row(
              children: [
                Expanded(child: _infoCard("Latitude (X)", _x?.toStringAsFixed(6) ?? "---")),
                const SizedBox(width: 12),
                Expanded(child: _infoCard("Longitude (Y)", _y?.toStringAsFixed(6) ?? "---")),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _infoCard("Date", _date.isEmpty ? "---" : _date)),
                const SizedBox(width: 12),
                Expanded(child: _infoCard("Time", _time.isEmpty ? "---" : _time)),
              ],
            ),

            const SizedBox(height: 12),

            // ---------------- IMAGE UPLOAD ----------------
            _uploadImageCard(),

            const SizedBox(height: 12),

            // ---------------- COMMENT ----------------
            _commentCard(),

            const SizedBox(height: 20),

            // ---------------- BUTTONS ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _getCoordinates,
                  icon: const Icon(Icons.location_on),
                  label: const Text("Get X & Y"),
                ),

                BlocConsumer<ReportCubit, ReportState>(
                  listener: (context, state) {
                    if (state is ReportSuccess) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Submitted")));
                      _commentCtrl.clear();
                    }
                    if (state is ReportFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                  builder: (context, state) {
                    if (state is ReportLoading) {
                      return const CircularProgressIndicator();
                    }

                    return ElevatedButton.icon(
                      onPressed: (_x == null || _y == null)
                          ? null
                          : () {
                        final report = ReportModel(
                          x: _x!,
                          y: _y!,
                          date: _date,
                          time: _time,
                          comment: _commentCtrl.text.trim(),
                          imageFile: _selectedImage, // <----- NEW
                        );

                        context.read<ReportCubit>().submit(report);
                      },
                      icon: const Icon(Icons.send),
                      label: const Text("Submit"),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMPONENTS
  // ---------------------------------------------------------------------------

  Widget _infoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // ---------------- COMMENT CARD ----------------
  Widget _commentCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Comment", style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            controller: _commentCtrl,
            maxLines: 3,
            decoration: const InputDecoration(hintText: "Write something..."),
          )
        ],
      ),
    );
  }

  // ---------------- IMAGE UPLOAD CARD ----------------
  Widget _uploadImageCard() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent),
          color: Colors.grey.shade100,
          image: _selectedImage != null
              ? DecorationImage(
            image: FileImage(_selectedImage!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: _selectedImage == null
            ? const Center(
          child: Text("Tap to upload image",
              style: TextStyle(color: Colors.black54)),
        )
            : null,
      ),
    );
  }
}
