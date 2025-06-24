import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'get_redirect_result_view_model.dart';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';

class GetRedirectResultScreen extends StatefulWidget {
  const GetRedirectResultScreen({super.key});

  @override
  State<GetRedirectResultScreen> createState() =>
      _GetRedirectResultScreenState();
}

class _GetRedirectResultScreenState extends State<GetRedirectResultScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GetRedirectResultViewModel(),
      child: Consumer<GetRedirectResultViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Get Redirect Result'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  onTap: viewModel.getRedirectResults,
                  loading: viewModel.loading,
                  title: 'Get Redirect Result',
                ),
                20.vSpace,
                if (viewModel.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      viewModel.error!,
                      style: TextStyle(color: Colors.red.shade700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                if (viewModel.redirectResult?.user != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User Information:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          12.vSpace,
                          _buildInfoRow(
                            'UID',
                            viewModel.redirectResult!.user!.uid,
                          ),
                          8.vSpace,
                          _buildInfoRow(
                            'Email',
                            viewModel.redirectResult!.user!.email ?? 'N/A',
                          ),
                          8.vSpace,
                          _buildInfoRow(
                            'Display Name',
                            viewModel.redirectResult!.user!.displayName ??
                                'N/A',
                          ),
                          if (viewModel.redirectResult!.user!.photoURL !=
                              null) ...[
                            8.vSpace,
                            _buildInfoRow(
                              'Photo URL',
                              viewModel.redirectResult!.user!.photoURL!,
                            ),
                          ],
                          8.vSpace,
                          _buildInfoRow(
                            'Email Verified',
                            viewModel.redirectResult!.user!.emailVerified
                                .toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  12.vSpace,
                  if (viewModel.redirectResult?.credential != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Authentication Details:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            12.vSpace,
                            _buildInfoRow(
                              'Provider ID',
                              viewModel.redirectResult!.credential!.providerId,
                            ),
                            if (viewModel.redirectResult!.credential
                                is OAuthCredential) ...[
                              8.vSpace,
                              _buildInfoRow(
                                'Access Token',
                                (viewModel.redirectResult!.credential
                                            as OAuthCredential)
                                        .accessToken ??
                                    'N/A',
                              ),
                              8.vSpace,
                              _buildInfoRow(
                                'Sign-in Method',
                                (viewModel.redirectResult!.credential
                                            as OAuthCredential)
                                        .signInMethod ??
                                    'redirect',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  12.vSpace,
                  if (viewModel.redirectResult?.additionalUserInfo != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Additional Information:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            12.vSpace,
                            _buildInfoRow(
                              'Is New User',
                              viewModel
                                  .redirectResult!
                                  .additionalUserInfo!
                                  .isNewUser
                                  .toString(),
                            ),
                            8.vSpace,
                            _buildInfoRow(
                              'Provider ID',
                              viewModel
                                      .redirectResult!
                                      .additionalUserInfo!
                                      .providerId ??
                                  'N/A',
                            ),
                            if (viewModel
                                    .redirectResult!
                                    .additionalUserInfo!
                                    .profile !=
                                null) ...[
                              8.vSpace,
                              const Text(
                                'Profile Data:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              4.vSpace,
                              ...viewModel
                                  .redirectResult!
                                  .additionalUserInfo!
                                  .profile!
                                  .entries
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        top: 4,
                                      ),
                                      child: Text('${e.key}: ${e.value}'),
                                    ),
                                  ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  12.vSpace,
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Operation Information:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          12.vSpace,
                          _buildInfoRow(
                            'Operation Type',
                            viewModel.redirectResult!.operationType ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (!viewModel.loading) ...[
                  const Text(
                    'No redirect result available. Click the button to check for results.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(value, softWrap: true)),
      ],
    );
  }
}
