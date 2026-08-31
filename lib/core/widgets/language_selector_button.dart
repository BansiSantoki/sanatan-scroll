import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/locale_provider.dart';

class LanguageSelectorButton extends StatefulWidget {
  const LanguageSelectorButton({super.key});

  @override
  State<LanguageSelectorButton> createState() => _LanguageSelectorButtonState();
}

class _LanguageSelectorButtonState extends State<LanguageSelectorButton> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);

    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (overlayContext) {
        final localeProvider = context.watch<LocaleProvider>();
        final currentCode = localeProvider.languageCode;

        final options = [
          {'code': 'en', 'label': 'English'},
          {'code': 'hi', 'label': 'हिंदी'},
          {'code': 'gu', 'label': 'ગુજરાતી'},
        ];

        return Stack(
          children: [
            // Tap outside to close
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeDropdown,
                child: const SizedBox.expand(),
              ),
            ),

            Positioned(
              width: 140,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomRight,
                followerAnchor: Alignment.topRight,
                offset: const Offset(0, 8),
                child: Material(
                  elevation: 8,
                  shadowColor: Colors.black.withValues(alpha: 0.15),
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F7F2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFE8DEC8).withValues(alpha: 0.8),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(options.length, (index) {
                        final option = options[index];
                        final code = option['code']!;
                        final label = option['label']!;
                        final isSelected = currentCode == code;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                _closeDropdown();
                                localeProvider.setLanguageCode(code);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13,
                                ),
                                width: double.infinity,
                                color: isSelected
                                    ? const Color(0xFFF3EAD9)
                                    : Colors.transparent,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        label,
                                        style: GoogleFonts.manrope(
                                          fontSize: 14.5,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: const Color(0xFF23180C),
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_rounded,
                                        size: 17,
                                        color: Color(0xFFC85A32),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            if (index < options.length - 1)
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFEFE8DA),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF7BE78),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Language',
                style: GoogleFonts.manrope(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF23180C),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                _isOpen
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: const Color(0xFF23180C),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
