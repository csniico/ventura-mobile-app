import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ventura/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ventura/features/auth/presentation/widgets/profile_cover_image.dart';

class ViewBusinessProfilePage extends StatelessWidget {
  const ViewBusinessProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8.0),
          child: const SizedBox(height: 8.0),
        ),
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/edit-business-page');
            },
            icon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedPencilEdit02,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileCoverImage(
                      coverHeight: 200,
                      businessAvatarUrl: state.user.business?.logo,
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedCheckmarkBadge01,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 5),
                          if (state.user.business?.name != null) ...[
                            state.user.business!.name.length > 30
                                ? Text(
                                    '${state.user.business!.name.substring(0, 23)}...',
                                    style: TextStyle(fontSize: 24),
                                  )
                                : Text(
                                    state.user.business!.name,
                                    style: TextStyle(fontSize: 24),
                                  ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Center(
                        child: Text(
                          '${state.user.business?.tagLine}',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Business Information',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedTextAlignLeft,
                            title: 'Description',
                            value:
                                state.user.business?.description ??
                                'No description',
                          ),
                          const SizedBox(height: 8),
        
                          const SizedBox(height: 8),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedCall,
                            title: 'Phone',
                            value: state.user.business?.phone ?? 'Not set',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedInternetAntenna01,
                            title: 'Website',
                            value: 'Not set',
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Location',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedLocation01,
                            title: 'Address',
                            value: state.user.business?.address ?? 'Not set',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedBuilding03,
                            title: 'City',
                            value: state.user.business?.city ?? 'Not set',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedMapsLocation01,
                            title: 'State',
                            value: state.user.business?.state ?? 'Not set',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedGlobe,
                            title: 'Country',
                            value: state.user.business?.country ?? 'Not set',
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Business Details',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedFile02,
                            title: 'Tax ID',
                            value: 'Not set',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedIdea,
                            title: 'Registration Number',
                            value: 'Not set',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedClock01,
                            title: 'Business Hours',
                            value: '9-5 Mon-Sat',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedUserCircle,
                            title: 'Owner',
                            value: state.user.business?.ownerId == state.user.id
                                ? 'Yes'
                                : 'No',
                          ),
                          const SizedBox(height: 8),
                          _buildInfoItem(
                            context,
                            icon: HugeIcons.strokeRoundedCheckmarkBadge01,
                            title: 'Active Status',
                            value: 'Active',
                          ),
                          const SizedBox(height: 24),
                          if (state.user.business?.categories != null &&
                              state.user.business!.categories.isNotEmpty) ...[
                            Text(
                              'Categories',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: state.user.business!.categories
                                  .map(
                                    (category) => Chip(
                                      label: Text(
                                        category,
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          fontSize: 12,
                                        ),
                                      ),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                                      side: BorderSide.none,
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: Text('Loading...'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required dynamic icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: HugeIcon(icon: icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w400)),
        subtitle: Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
