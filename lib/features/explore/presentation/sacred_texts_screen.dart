import 'package:flutter/material.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../data/mock_sacred_texts.dart';
import 'widgets/sacred_text_card.dart';

class SacredTextsScreen extends StatelessWidget {
  const SacredTextsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final texts = MockSacredTexts.all
        .where((t) =>
            t.id != 'karma_yoga' &&
            t.id != 'meditation' &&
            t.id != 'bhakti' &&
            t.id != 'self_realization' &&
            t.id != 'krishna_teachings' &&
            t.id != 'inner_peace')
        .toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'All Sacred Texts',
        showBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.horizontalPadding),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.68,
        ),
        itemCount: texts.length,
        itemBuilder: (context, index) {
          final text = texts[index];
          return SacredTextCard(
            text: text,
            showBookmark: false,
            onTap: () => Navigator.of(context).pushNamed(
              AppRoutes.sacredTextDetail,
              arguments: text.id,
            ),
          );
        },
      ),
    );
  }
}
