import 'package:flutter/material.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/simple_card.dart';
import '../../widgets/animated_card.dart';
import '../../utils/app_colors.dart';
import '../../models/volunteer_request_model.dart';

class VolunteerRequestsScreen extends StatefulWidget {
  @override
  State<VolunteerRequestsScreen> createState() => _VolunteerRequestsScreenState();
}

class _VolunteerRequestsScreenState extends State<VolunteerRequestsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Approved', 'Rejected'];
  
  // Demo volunteer requests
  List<VolunteerRequestModel> _volunteerRequests = [
    VolunteerRequestModel(
      id: '1',
      userId: 'user1',
      userName: 'Ahmed Rahman',
      userEmail: 'ahmed@email.com',
      userPhone: '01712345678',
      rescueTeamId: 'team1',
      rescueTeamName: 'Animal Rescuers of Bangladesh',
      motivation: 'I love animals and want to help rescue and care for stray animals in our community.',
      experience: 'I have been feeding stray cats in my neighborhood for 2 years.',
      availability: 'Weekends and evenings',
      skills: ['Animal Care', 'First Aid', 'Photography'],
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
      status: VolunteerRequestStatus.pending,
    ),
    VolunteerRequestModel(
      id: '2',
      userId: 'user2',
      userName: 'Fatima Khan',
      userEmail: 'fatima@email.com',
      userPhone: '01798765432',
      rescueTeamId: 'team1',
      rescueTeamName: 'Animal Rescuers of Bangladesh',
      motivation: 'As a veterinary student, I want to gain practical experience in animal rescue.',
      experience: 'Currently studying veterinary medicine, have experience with pet care.',
      availability: 'Flexible schedule',
      skills: ['Veterinary Knowledge', 'Animal Handling', 'Medical Care'],
      requestDate: DateTime.now().subtract(const Duration(days: 5)),
      status: VolunteerRequestStatus.approved,
      responseDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    VolunteerRequestModel(
      id: '3',
      userId: 'user3',
      userName: 'Mohammad Ali',
      userEmail: 'ali@email.com',
      userPhone: '01634567890',
      rescueTeamId: 'team1',
      rescueTeamName: 'Animal Rescuers of Bangladesh',
      motivation: 'I want to contribute to animal welfare in Bangladesh.',
      experience: 'No prior experience but very enthusiastic to learn.',
      availability: 'Weekends only',
      skills: ['Transportation', 'Social Media'],
      requestDate: DateTime.now().subtract(const Duration(days: 7)),
      status: VolunteerRequestStatus.rejected,
      rejectionReason: 'Limited availability does not match our current needs.',
      responseDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  List<VolunteerRequestModel> get _filteredRequests {
    if (_selectedFilter == 'All') return _volunteerRequests;
    
    VolunteerRequestStatus status;
    switch (_selectedFilter) {
      case 'Pending':
        status = VolunteerRequestStatus.pending;
        break;
      case 'Approved':
        status = VolunteerRequestStatus.approved;
        break;
      case 'Rejected':
        status = VolunteerRequestStatus.rejected;
        break;
      default:
        return _volunteerRequests;
    }
    
    return _volunteerRequests.where((request) => request.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Requests'),
        backgroundColor: Colors.transparent,
      ),
      body: GradientBackground(
        child: Column(
          children: [
            // Filter Tabs
            Container(
              padding: const EdgeInsets.all(20),
              child: SimpleCard(
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    final count = filter == 'All' 
                        ? _volunteerRequests.length
                        : _filteredRequests.length;
                    
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilter = filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$count',
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // Requests List
            Expanded(
              child: _filteredRequests.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.volunteer_activism_rounded,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No ${_selectedFilter.toLowerCase()} requests',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filteredRequests.length,
                      itemBuilder: (context, index) {
                        final request = _filteredRequests[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: _buildRequestCard(request),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(VolunteerRequestModel request) {
    Color statusColor;
    IconData statusIcon;
    
    switch (request.status) {
      case VolunteerRequestStatus.pending:
        statusColor = AppColors.warning;
        statusIcon = Icons.pending_rounded;
        break;
      case VolunteerRequestStatus.approved:
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle_rounded;
        break;
      case VolunteerRequestStatus.rejected:
        statusColor = AppColors.error;
        statusIcon = Icons.cancel_rounded;
        break;
    }

    return AnimatedCard(
      onTap: () => _showRequestDetails(request),
      child: SimpleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        request.userEmail,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        request.userPhone,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        request.status.name.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'Motivation:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              request.motivation,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Availability: ${request.availability}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Skills
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: request.skills.take(3).map((skill) => 
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ).toList(),
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Text(
                  'Applied ${_formatDate(request.requestDate)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                if (request.status == VolunteerRequestStatus.pending) ...[
                  TextButton(
                    onPressed: () => _rejectRequest(request),
                    child: const Text(
                      'Reject',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _approveRequest(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Approve'),
                  ),
                ] else ...[
                  TextButton(
                    onPressed: () => _showRequestDetails(request),
                    child: const Text('View Details'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRequestDetails(VolunteerRequestModel request) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: SimpleCard(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Volunteer Application',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                _buildDetailRow('Email:', request.userEmail),
                _buildDetailRow('Phone:', request.userPhone),
                _buildDetailRow('Availability:', request.availability),
                _buildDetailRow('Applied:', _formatDate(request.requestDate)),
                
                const SizedBox(height: 16),
                
                const Text(
                  'Motivation:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  request.motivation,
                  style: const TextStyle(fontSize: 12),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  'Experience:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  request.experience,
                  style: const TextStyle(fontSize: 12),
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  'Skills:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: request.skills.map((skill) => 
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ).toList(),
                ),
                
                if (request.status == VolunteerRequestStatus.rejected && request.rejectionReason != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rejection Reason:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          request.rejectionReason!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 20),
                
                if (request.status == VolunteerRequestStatus.pending) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _rejectRequest(request);
                          },
                          child: const Text(
                            'Reject',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _approveRequest(request);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Approve'),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 44),
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _approveRequest(VolunteerRequestModel request) {
    setState(() {
      final index = _volunteerRequests.indexWhere((r) => r.id == request.id);
      if (index != -1) {
        _volunteerRequests[index] = request.copyWith(
          status: VolunteerRequestStatus.approved,
          responseDate: DateTime.now(),
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${request.userName} has been approved as a volunteer!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _rejectRequest(VolunteerRequestModel request) {
    showDialog(
      context: context,
      builder: (context) {
        final reasonController = TextEditingController();
        return AlertDialog(
          title: const Text('Reject Application'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to reject ${request.userName}\'s application?'),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for rejection (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  final index = _volunteerRequests.indexWhere((r) => r.id == request.id);
                  if (index != -1) {
                    _volunteerRequests[index] = request.copyWith(
                      status: VolunteerRequestStatus.rejected,
                      rejectionReason: reasonController.text.isEmpty 
                          ? 'Application does not meet current requirements.' 
                          : reasonController.text,
                      responseDate: DateTime.now(),
                    );
                  }
                });
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${request.userName}\'s application has been rejected.'),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }
}
