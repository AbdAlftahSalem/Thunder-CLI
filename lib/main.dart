import 'package:thunder_cli/features/localization_feature/localization_feature.dart';

import 'core/services/command_service/command_service.dart';
import 'features/create_feature/create_feature.dart';
import 'features/init_project/init_project.dart';

void main(List<String> arguments) async {
  CreateFeatureFiles.createFiles();
  // print(							"body": "{\n    \"Success\": true,\n    \"Message\": \"تمت العملية بنجاح\",\n    \"Data\": {\n        \"accessToken\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uSWQiOiJkNDUxYTU3MS00ZTc4LTRiNzQtYTJhOS00Y2Y1ZjAyYmEzOTQiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjkyNDZmZmFiLTFhMDMtNDA3Zi1iODc0LWEwZDlhYTY5NDQ4NCIsImVtYWlsIjoiYWJkYWxmdGFoQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJhYmRhbGZ0YWgiLCJqdGkiOiI1ZGRjZGZjZi1kYTUwLTQ3MzItYThiZS0zOWU1ZDEyYjBiYjMiLCJzdWIiOiI2RlhEVEFLS002R1JRTVhRSU5GVVhETlBYSVBRSU5NUyIsIlVzZXJJZCI6IjkyNDZmZmFiLTFhMDMtNDA3Zi1iODc0LWEwZDlhYTY5NDQ4NCIsIlVzZXJUeXBlIjoiNDEiLCJBdmF0YXIiOiIvaW1hZ2VzL2RlZmF1bHQvYmxhbmsucG5nIiwiRnVsbE5hbWUiOiLYudio2K_Yp9mE2YHYqtin2K0g2LPYp9mE2YUiLCJleHAiOjE3MzE5MjU0NzIsImlzcyI6Imh0dHBzOi8vYnJpZ2h0ZW5zcy5jb20vIiwiYXVkIjoiaHR0cHM6Ly9icmlnaHRlbnNzLmNvbS8ifQ.lAXQJBeQ9XAdmKODJB_H_33_vIF4CZmrX_lhUO74wr8\",\n        \"expiryDate\": \"2024-11-18T10:24:32Z\",\n        \"refreshToken\": \"sp4npfVG28hz0GvegO6irRy+vVX5ovoGXSUoPReyyXk=\",\n        \"refreshTokenExpiryDate\": \"2024-11-23T03:50:28.660242\"\n    },\n    \"Errors\": []\n}");
  // CommandServices.startCommands(arguments);
  // LocalizationFeature.localizationFeature();
  // InitProject.initProject();
}
