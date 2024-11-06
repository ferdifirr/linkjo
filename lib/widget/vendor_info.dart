import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:linkjo/config/routes.dart';
import 'package:linkjo/util/asset.dart';
import 'package:linkjo/util/log.dart';

class VendorInfo extends StatefulWidget {
  const VendorInfo({super.key});

  @override
  State<VendorInfo> createState() => _VendorInfoState();
}

class _VendorInfoState extends State<VendorInfo> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  void _playAudio() async {
    Log.d('Playing audio');
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource(Asset.dummyVendorAudio));
    setState(() {
      _isPlaying = true;
    });  
  }

  void _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _playAudio();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return SizedBox(
      height: height * 0.4,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Theme.of(context).primaryColor.withOpacity(
                    0.8,
                  ),
            ),
          ),
          Positioned(
            top: height * 0.18,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _audioPlayer.stop();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, Routes.vendor);
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: width * 0.1,
                        backgroundImage: const AssetImage(
                          Asset.logo,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bakso Pak Kumis',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'Cahyo Nugroho',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        if (_isPlaying) {
                          _pauseAudio();
                        } else {
                          _playAudio();
                        }
                      },
                    ),
                    Text(_isPlaying ? 'Pause the Vibe' : 'Let\'s Jam!'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
