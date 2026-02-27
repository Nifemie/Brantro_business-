Correction summary

What changed

1) Moved the first-load responsibility from UI to Riverpod.
- Removed manual fetches from widget initState.
- Let the provider load data on first watch via AsyncNotifier.build().
- Result: one initial API call instead of repeated calls on widget mount.

2) Fixed provider dependency rebuild cascade.
- Providers that build repositories now use read instead of watch.
- Result: repository/provider recreation no longer triggers repeated notifier rebuilds.

3) Converted template provider to AsyncNotifier.
- Replaced StateNotifier lifecycle hacks with AsyncNotifier.build().
- fetchTemplates now sets AsyncLoading and then AsyncData/AsyncError.
- Result: clean Riverpod lifecycle, no init microtask, no storm.

4) Updated UI to consume AsyncValue.
- Screens and sections now render with AsyncValue.when().
- Removed old isInitialLoading/message/isDataAvailable checks in UI.
- Result: consistent loading/error/data rendering driven by provider state.

Files updated

- lib/features/template/logic/template_notifier.dart
- lib/features/template/presentation/screens/template_listing_screen.dart
- lib/features/home/presentation/widgets/sections/template_section.dart

Why this fixes the API storm

The storm was caused by initiating fetches inside widgets and provider rebuild cascades. AsyncNotifier.build() runs once per provider lifecycle and is the correct place to perform first-load work. Switching repository dependencies to read prevents unintended notifier recreation. Together, these changes stop repeated API calls and stabilize the data flow.

How to apply these fixes to other screens

Checklist

1) Provider setup (Repository/Api client)
- Use ref.read(...) inside Provider builders unless you truly need reactive updates.
- Avoid ref.watch(...) in repository providers to prevent recreation cascades.

2) Notifier setup (first load)
- Prefer AsyncNotifier for async data fetching.
- Move initial fetch into AsyncNotifier.build().
- Remove any _init() or Future.microtask() triggers.

3) UI setup (no manual first load)
- Delete initState fetches.
- Let the provider load automatically on first watch.

4) UI rendering (AsyncValue)
- Replace old flags like isInitialLoading/message/isDataAvailable with AsyncValue.when().
- Keep error/empty/list logic inside the data callback.

Quick template

Provider:
final featureProvider = AsyncNotifierProvider<FeatureNotifier, DataState<FeatureModel>>(
	FeatureNotifier.new,
);

Notifier:
class FeatureNotifier extends AsyncNotifier<DataState<FeatureModel>> {
	late final FeatureRepository _repository;

	@override
	Future<DataState<FeatureModel>> build() async {
		_repository = ref.read(featureRepositoryProvider);
		final items = await _repository.fetchItems(page: 0, size: 20);
		return DataState<FeatureModel>(
			data: items,
			isDataAvailable: items.isNotEmpty,
			currentPage: 0,
			message: items.isEmpty ? 'No items available' : null,
		);
	}
}

UI:
final featureAsync = ref.watch(featureProvider);

return featureAsync.when(
	loading: _buildLoadingState,
	error: (e, _) => _buildErrorState(e.toString()),
	data: (state) {
		final items = state.data ?? [];
		if (items.isEmpty) return _buildEmptyState();
		return _buildList(items);
	},
);

Common mistakes to avoid

- Calling fetch in initState or build.
- Using ref.watch inside repository providers.
- Using StateNotifier to simulate initState with microtasks.
