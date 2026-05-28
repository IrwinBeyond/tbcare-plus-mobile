import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/auth_api_service.dart';
import '../../../core/theme/app_colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nicknameCtrl = TextEditingController();
  final _pictureCtrl = TextEditingController();
  bool _saving = false;
  String? _error;
  String? _nicknameError;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  Future<void> _loadCurrentProfile() async {
    final user = await StorageService.getUser();
    if (user == null) return;
    setState(() {
      _nicknameCtrl.text = user.fullName ?? '';
      _pictureCtrl.text = user.profilePicture ?? '';
    });
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _pictureCtrl.dispose();
    super.dispose();
  }

  bool _validate() {
    bool ok = true;
    setState(() {
      _nicknameError = null;
      if (_nicknameCtrl.text.trim().isEmpty) { _nicknameError = 'Nama tidak boleh kosong'; ok = false; }
    });
    return ok;
  }

  Future<void> _onSave() async {
    if (!_validate()) return;
    setState(() { _saving = true; _error = null; });
    try {
      final pic = _pictureCtrl.text.trim();
      await AuthApiService.updateProfile(nickname: _nicknameCtrl.text.trim(), profilePicture: pic.isEmpty ? null : pic);
      await AuthApiService.fetchCurrentUser();
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(child: Column(children: [
      _buildHeader(),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(24, 0, 24, 24), child: Column(children: [
        const SizedBox(height: 16),
        if (_error != null) ...[
          Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.shade200)), child: Text(_error!, style: TextStyle(fontSize: 13, color: Colors.red.shade700))),
          const SizedBox(height: 20),
        ],
        Container(
          width: double.infinity, padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white.withAlpha(235), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white), boxShadow: [BoxShadow(color: AppColors.primary.withAlpha(15), blurRadius: 20, offset: const Offset(0, 4))]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _label('Nama'), const SizedBox(height: 8),
            _field(_nicknameCtrl, 'Nama lengkap Anda', Icons.badge_outlined, _nicknameError),
            const SizedBox(height: 20),
            _label('URL Foto Profil'), const SizedBox(height: 8),
            _field(_pictureCtrl, 'https://example.com/photo.jpg', Icons.link_rounded, null),
          ]),
        ),
        const SizedBox(height: 32),
        SizedBox(width: double.infinity, height: 56, child: ElevatedButton(onPressed: _saving ? null : _onSave, style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 4, shadowColor: AppColors.primary.withAlpha(76), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: _saving ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) : const Text('Simpan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)))),
      ]))),
    ])),
  );

  Widget _buildHeader() => Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), child: Row(children: [
    GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withAlpha(179), shape: BoxShape.circle, border: Border.all(color: Colors.white), boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, 2))]), child: const Icon(Icons.arrow_back, color: AppColors.foreground, size: 20))),
    const SizedBox(width: 16), const Expanded(child: Text('Edit Profil', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.foreground, letterSpacing: -0.3))), const SizedBox(width: 40),
  ]));

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(left: 4), child: Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.foreground)));

  Widget _field(TextEditingController ctrl, String hint, IconData icon, String? err) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Container(
      decoration: BoxDecoration(color: Colors.white.withAlpha(230), borderRadius: BorderRadius.circular(12), border: Border.all(color: err != null ? AppColors.destructive.withAlpha(102) : AppColors.primary.withAlpha(51))),
      child: TextField(controller: ctrl, decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(fontSize: 14, color: AppColors.mutedForeground.withAlpha(128)), prefixIcon: Icon(icon, color: err != null ? AppColors.destructive.withAlpha(179) : AppColors.primary.withAlpha(179), size: 20), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14))),
    ),
    if (err != null) Padding(padding: const EdgeInsets.only(left: 8, top: 6), child: Text(err, style: const TextStyle(fontSize: 11, color: AppColors.destructive, fontWeight: FontWeight.w600))),
  ]);
}
