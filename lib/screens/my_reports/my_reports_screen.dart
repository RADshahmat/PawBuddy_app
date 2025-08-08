import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/simple_card.dart';
import '../../widgets/animated_card.dart';
import '../../utils/app_colors.dart';
import '../../models/report_model.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});
  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  // Demo reports for the current user
  final List<ReportModel> _myReports = [
    ReportModel(
      id: '1',
      userId: '2', // Premium user ID
      animalType: 'Dog',
      condition: 'Injured',
      description: 'Found injured dog near Dhanmondi lake, needs immediate medical attention',
      latitude: 23.7461,
      longitude: 90.3742,
      locationAddress: 'Dhanmondi Lake, Dhaka',
      imageUrls: ['/placeholder.svg?height=200&width=200&text=Injured+Dog'],
      reportedAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'in_progress',
      assignedRescueTeamId: '1',
    ),
    ReportModel(
      id: '2',
      userId: '2',
      animalType: 'Cat',
      condition: 'Healthy but stray',
      description: 'Stray cat family with kittens, looking for shelter',
      latitude: 23.8103,
      longitude: 90.4125,
      locationAddress: 'Gulshan Circle 1, Dhaka',
      imageUrls: ['/placeholder.svg?height=200&width=200&text=Cat+Family'],
      reportedAt: DateTime.now().subtract(const Duration(days: 1)),
      status: 'completed',
    ),
    ReportModel(
      id: '3',
      userId: '2',
      animalType: 'Bird',
      condition: 'Injured',
      description: 'Injured crow unable to fly, found in park',
      latitude: 23.7925,
      longitude: 90.4078,
      locationAddress: 'Ramna Park, Dhaka',
      imageUrls: ['/placeholder.svg?height=200&width=200&text=Injured+Bird'],
      reportedAt: DateTime.now().subtract(const Duration(days: 3)),
      status: 'pending',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser!;
        
        // Filter reports for current user
        final userReports = _myReports.where((report) => report.userId == user.id).toList();
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Reports'),
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
          body: GradientBackground(
            child: userReports.isEmpty 
                ? _buildEmptyState()
                : _buildReportsList(userReports),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SimpleCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.report_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Reports Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven\'t reported any animals yet.\nStart helping by reporting stray animals!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to report screen
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Report Animal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsList(List<ReportModel> reports) {
    return Column(
      children: [
        // Stats Header
        Container(
          padding: const EdgeInsets.all(20),
          child: SimpleCard(
            child: Row(
              children: [
                _buildStatItem('Total', '${reports.length}', AppColors.primary),
                _buildStatItem('Pending', '${reports.where((r) => r.status == 'pending').length}', AppColors.warning),
                _buildStatItem('In Progress', '${reports.where((r) => r.status == 'in_progress').length}', AppColors.secondary),
                _buildStatItem('Completed', '${reports.where((r) => r.status == 'completed').length}', AppColors.success),
              ],
            ),
          ),
        ),
        
        // Reports List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: _buildReportCard(report),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(ReportModel report) {
    Color statusColor = _getStatusColor(report.status);
    
    return AnimatedCard(
      onTap: () => _showReportDetails(report),
      child: SimpleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Animal Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    report.imageUrls.isNotEmpty ? report.imageUrls.first : '',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.pets_rounded,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Report Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${report.animalType} - ${report.condition}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              report.locationAddress,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(report.reportedAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    report.statusDisplayName,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              report.description,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            if (report.assignedRescueTeamId != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_hospital_rounded,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Assigned to rescue team',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'in_progress':
        return AppColors.secondary;
      case 'completed':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  void _showReportDetails(ReportModel report) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SimpleCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Report Details',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              if (report.imageUrls.isNotEmpty)
                Container(
                  height: 150,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: report.imageUrls.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            report.imageUrls[index],
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.pets_rounded,
                                  color: AppColors.primary,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              
              const SizedBox(height: 16),
              
              _buildDetailRow('Animal Type', report.animalType),
              _buildDetailRow('Condition', report.condition),
              _buildDetailRow('Location', report.locationAddress),
              _buildDetailRow('Status', report.statusDisplayName),
              _buildDetailRow('Reported', _formatDate(report.reportedAt)),
              
              const SizedBox(height: 12),
              
              const Text(
                'Description:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                report.description,
                style: const TextStyle(fontSize: 14),
              ),
              
              const SizedBox(height: 20),
              
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
