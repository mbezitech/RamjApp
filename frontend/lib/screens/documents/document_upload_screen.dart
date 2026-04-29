import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  XFile? _tmdaFile;
  XFile? _traFile;
  List<VerificationDocument> _documents = [];
  bool _isLoading = true;
  bool _isUploading = false;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() => _isLoading = true);

    try {
      final response = await _apiService.get('/documents');
      setState(() {
        _documents = (response['documents'] as List)
            .map((d) => VerificationDocument.fromJson(d))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('ApiException: ', '');
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(String documentType) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
    );

    if (image != null) {
      setState(() {
        if (documentType == 'tmda') {
          _tmdaFile = image;
        } else {
          _traFile = image;
        }
      });
    }
  }

  Future<void> _uploadDocument(String documentType, XFile file) async {
    setState(() {
      _isUploading = true;
      _error = null;
      _success = null;
    });

    try {
      await _apiService.uploadDocument(
        '/documents/upload',
        {'document_type': documentType},
        file.path,
      );

      setState(() {
        _success =
            '${documentType.toUpperCase()} document uploaded. Pending review.';
        if (documentType == 'tmda') {
          _tmdaFile = null;
        } else {
          _traFile = null;
        }
        _isUploading = false;
      });

      await _loadDocuments();
      await context.read<AuthProvider>().refreshUser();
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('ApiException: ', '');
        _isUploading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Verification'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            authProvider.isVerifiedBusiness
                                ? Icons.verified
                                : Icons.verified_outlined,
                            color: authProvider.isVerifiedBusiness
                                ? AppColors.success
                                : AppColors.warning,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authProvider.isVerifiedBusiness
                                      ? 'Verified Business'
                                      : 'Verification Pending',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  authProvider.isVerifiedBusiness
                                      ? 'You can access all products including medicines'
                                      : 'Upload TMDA & TRA documents to get verified',
                                  style: TextStyle(color: AppColors.textLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                  if (_success != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _success!,
                        style: const TextStyle(color: AppColors.success),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  _DocumentSection(
                    title: 'TMDA Certificate',
                    subtitle: 'Tanzania Medicines and Medical Devices Authority',
                    document: _documents
                        .where((d) => d.documentType == 'tmda')
                        .firstOrNull,
                    pickedFile: _tmdaFile,
                    onPick: () => _pickImage('tmda'),
                    onUpload: _tmdaFile != null
                        ? () => _uploadDocument('tmda', _tmdaFile!)
                        : null,
                    isUploading: _isUploading,
                  ),
                  const SizedBox(height: 16),
                  _DocumentSection(
                    title: 'TRA Certificate',
                    subtitle: 'Tanzania Revenue Authority',
                    document: _documents
                        .where((d) => d.documentType == 'tra')
                        .firstOrNull,
                    pickedFile: _traFile,
                    onPick: () => _pickImage('tra'),
                    onUpload: _traFile != null
                        ? () => _uploadDocument('tra', _traFile!)
                        : null,
                    isUploading: _isUploading,
                  ),
                ],
              ),
            ),
    );
  }
}

class _DocumentSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final VerificationDocument? document;
  final XFile? pickedFile;
  final VoidCallback onPick;
  final VoidCallback? onUpload;
  final bool isUploading;

  const _DocumentSection({
    required this.title,
    required this.subtitle,
    this.document,
    this.pickedFile,
    required this.onPick,
    this.onUpload,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isApproved = document?.status == 'approved';
    final isRejected = document?.status == 'rejected';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(color: AppColors.textLight, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (document != null)
                  Row(
                    children: [
                      Icon(
                        document!.status == 'approved'
                            ? Icons.check_circle
                            : document!.status == 'rejected'
                                ? Icons.cancel
                                : Icons.pending,
                        color: document!.status == 'approved'
                            ? AppColors.success
                            : document!.status == 'rejected'
                                ? AppColors.error
                                : AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        document!.status.toUpperCase(),
                        style: TextStyle(
                          color: document!.status == 'approved'
                              ? AppColors.success
                              : document!.status == 'rejected'
                                  ? AppColors.error
                                  : AppColors.warning,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (document?.reviewNotes != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isRejected
                      ? AppColors.error.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Note: ${document!.reviewNotes}',
                  style: TextStyle(
                    color: isRejected ? AppColors.error : AppColors.warning,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            if (!isApproved) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onPick,
                      icon: const Icon(Icons.image),
                      label: Text(pickedFile != null
                          ? pickedFile!.name
                          : 'Select Image'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: onUpload,
                    icon: isUploading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload),
                    label: const Text('Upload'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
