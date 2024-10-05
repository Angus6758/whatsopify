// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_ctrl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatCtrlHash() => r'54262e1a1706ef504a12ead161e4265b79c85437';

/// See also [ChatCtrl].
@ProviderFor(ChatCtrl)
final chatCtrlProvider =
    AutoDisposeAsyncNotifierProvider<ChatCtrl, List<Customer>>.internal(
  ChatCtrl.new,
  name: r'chatCtrlProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$chatCtrlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChatCtrl = AutoDisposeAsyncNotifier<List<Customer>>;
String _$chatMessageCtrlHash() => r'0d3b3e50510ea256515c3cd4edb7bff6c62a32df';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ChatMessageCtrl
    extends BuildlessAutoDisposeAsyncNotifier<CustomerMessageData> {
  late final String id;

  FutureOr<CustomerMessageData> build(
    String id,
  );
}

/// See also [ChatMessageCtrl].
@ProviderFor(ChatMessageCtrl)
const chatMessageCtrlProvider = ChatMessageCtrlFamily();

/// See also [ChatMessageCtrl].
class ChatMessageCtrlFamily extends Family<AsyncValue<CustomerMessageData>> {
  /// See also [ChatMessageCtrl].
  const ChatMessageCtrlFamily();

  /// See also [ChatMessageCtrl].
  ChatMessageCtrlProvider call(
    String id,
  ) {
    return ChatMessageCtrlProvider(
      id,
    );
  }

  @override
  ChatMessageCtrlProvider getProviderOverride(
    covariant ChatMessageCtrlProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'chatMessageCtrlProvider';
}

/// See also [ChatMessageCtrl].
class ChatMessageCtrlProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ChatMessageCtrl, CustomerMessageData> {
  /// See also [ChatMessageCtrl].
  ChatMessageCtrlProvider(
    String id,
  ) : this._internal(
          () => ChatMessageCtrl()..id = id,
          from: chatMessageCtrlProvider,
          name: r'chatMessageCtrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatMessageCtrlHash,
          dependencies: ChatMessageCtrlFamily._dependencies,
          allTransitiveDependencies:
              ChatMessageCtrlFamily._allTransitiveDependencies,
          id: id,
        );

  ChatMessageCtrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  FutureOr<CustomerMessageData> runNotifierBuild(
    covariant ChatMessageCtrl notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(ChatMessageCtrl Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatMessageCtrlProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ChatMessageCtrl, CustomerMessageData>
      createElement() {
    return _ChatMessageCtrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessageCtrlProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ChatMessageCtrlRef
    on AutoDisposeAsyncNotifierProviderRef<CustomerMessageData> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ChatMessageCtrlProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChatMessageCtrl,
        CustomerMessageData> with ChatMessageCtrlRef {
  _ChatMessageCtrlProviderElement(super.provider);

  @override
  String get id => (origin as ChatMessageCtrlProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
