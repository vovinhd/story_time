


  import 'package:file_picker/file_picker.dart';
import 'package:fl_audiobook/services/player_service.dart';
import 'package:logging/logging.dart';

final _log = Logger('files');


Future<bool> pickFile() async {
    PlatformFile? file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ["m4b", "m4a", "mp3"],
    );

    if (file != null) {
      try {
        await PlayerService().openFile(
          BookFile(name: file.name, path: file.path!),
        );
        return true;
      } catch (e) {
        _log.severe("something went wrong: ${e}");
        return false;
      }
    } else {
      // User canceled the picker
      _log.info("User canceled the picker");
      return false;
    }
  }