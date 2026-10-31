import 'package:path/path.dart' as p;

import '../../core/consts/const_strings.dart';
import '../../core/services/console_service/console.dart';
import '../../core/services/folder_and_file_service/folder_and_file_service.dart';

/// Adds a GitHub Actions workflow that builds an APK and sends it to Telegram.
class SetUpGithubAction {
  /// Writes `.github/workflows/build_apk_and_send_to_telegram.yaml` in [root].
  static Future<void> setUpGithubAction(String root) async {
    await FolderAndFileService.createFile(
      p.join(
          root, '.github', 'workflows', 'build_apk_and_send_to_telegram.yaml'),
      ConstStrings.instance.buildApkFileWorkFlow(),
    );
    Console.success(
        'GitHub Action added (.github/workflows/build_apk_and_send_to_telegram.yaml)');
    Console.info(
        '   Add TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID to your repository secrets:');
    Console.info('   GitHub repo > Settings > Secrets and variables > Actions');
  }
}
