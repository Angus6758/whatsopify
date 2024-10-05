import 'dart:async';
import 'dart:io';

import 'package:seller_management/features/settings/controller/settings_ctrl.dart';
import 'package:seller_management/main.export.dart';

import '../repository/ticket_repository.dart';

final ticketMassageCtrlProvider = AutoDisposeAsyncNotifierProviderFamily<
    TicketMassageCtrlNotifier,
    TicketData,
    String>(TicketMassageCtrlNotifier.new);

class TicketMassageCtrlNotifier
    extends AutoDisposeFamilyAsyncNotifier<TicketData, String> {
  final _repo = locate<TicketRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  @override
  FutureOr<TicketData> build(String arg) async {
    final data = await _repo.getMassage(arg);
    return data.fold(
      (l) => l.toFError(),
      (r) => r.data,
    );
  }

  Future<void> ticketReply(String message, List<File> file) async {
    if (message.isEmpty) {
      Toaster.showError('Message field is required');
      return;
    }
    final res = await _repo.ticketReply(message, arg, file);
    res.fold(
      (l) {
        Toaster.showError(l);
        ref.invalidateSelf();
      },
      (r) => state = AsyncData(r.data),
    );
  }

  Future<List<File>> pickFiles() async {
    final picker = locate<FilePickerRepo>();
    final exts =
        ref.read(localSettingsProvider.select((v) => v?.allFormate ?? []));
    final res = await picker.pickFiles(allowedExtensions: exts);

    return res.fold(
      (l) {
        Toaster.showError(l);
        return [];
      },
      (r) => r,
    );
  }
}

// Ticket Create Controller

final ticketCreateProvider =
    AutoDisposeNotifierProvider<TicketCreateNotifier, TicketCreateModel>(
        TicketCreateNotifier.new);

class TicketCreateNotifier extends AutoDisposeNotifier<TicketCreateModel> {
  final _repo = locate<TicketRepo>();

  void setTicketInfo(QMap map) {
    state = state.copyWith(
      subject: map['subject'],
      priority: map['priority'],
      message: map['message'],
    );
  }

  Future<void> pickFiles() async {
    final picker = locate<FilePickerRepo>();
    final exts =
        ref.read(localSettingsProvider.select((v) => v?.allFormate ?? []));
    final res = await picker.pickFiles(allowedExtensions: exts);

    res.fold(
      (l) => Toaster.showError(l),
      (r) => state = state.copyWith(files: r),
    );
  }

  Future<void> removeFile(int index) async {
    state = state.copyWith(files: state.files..removeAt(index));
  }

  @override
  TicketCreateModel build() {
    return TicketCreateModel.empty;
  }

  Future<String?> createTicket() async {
    final parts = await state.toMapFiles();
    final formData = {...state.toMap(), ...parts};
    Logger.json(state.toMap());
    final res = await _repo.createTicket(formData: formData);

    return res.fold((l) {
      Logger.ex(l.message, l.stackTrace);
      return null;
    }, (r) {
      return r.data.ticket.ticketNumber;
    });
  }
}
