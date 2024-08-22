import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'joborder_model.dart';
import 'globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'history_model.dart';

class JobDetailsPage extends StatefulWidget {
  final JobModel job;

  JobDetailsPage({required this.job});

  @override
  _JobDetailsPageState createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFiles = [];
  bool _isButtonActive = true;
  bool _isUploadButtonDisabled = false; // Track if the upload button should be disabled
  bool _isLoading = false;
  List<JobHistory>? _jobHistories = []; // Track the fetched job history

  @override
  void initState() {
    super.initState();
    _fetchJobHistory();
  }

  Future<void> _fetchJobHistory() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse('https://locationtracker.cvs-global.com/api/Driver/history'),
        body: {
          'user_id': Globals.userId,
          'token': Globals.token,
          'job_id': Globals.jobId,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<dynamic> jobList = responseData['job'];
        setState(() {
          _jobHistories =
              jobList.map((data) => JobHistory.fromJson(data)).toList();
        });
      } else {
        _showErrorMessage(
            'Failed to load history. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _pickImages() async {
    if (_isUploadButtonDisabled) return; // Prevent picking images if button is disabled

    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _imageFiles = selectedImages;
        _updateButtonState();
      });

      for (var image in selectedImages) {
        await _confirmAndUploadImage(image);
      }
    }
  }

  Future<void> _captureImage() async {
    if (_isUploadButtonDisabled) return; // Prevent capturing images if button is disabled

    final XFile? capturedImage = await _picker.pickImage(source: ImageSource.camera);
    if (capturedImage != null) {
      setState(() {
        _imageFiles?.add(capturedImage);
        _updateButtonState();
      });

      await _confirmAndUploadImage(capturedImage);
    }
  }

  Future<void> _confirmAndUploadImage(XFile image) async {
    bool? confirm = await _showConfirmationDialog('Are you sure you want to upload this image?');

    if (confirm == true) {
      await _uploadImage(image);

      if (_imageFiles?.length == 3) {
        await _confirmAndUploadStatus();
      }
    }
  }

  Future<void> _confirmAndUploadStatus() async {
    bool? confirm = await _showConfirmationDialog('Are you sure you want to update the status?');

    if (confirm == true) {
      setState(() {
        _imageFiles = []; // Clear the images
        _isUploadButtonDisabled = true; // Disable the upload button
        _updateButtonState(); // Update button state
      });

      _showSuccessMessage('Status updated successfully');
    }
  }


  Future<void> _uploadImage(XFile image) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://locationtracker.cvs-global.com/api/Driver/job_vehicle_image_save'),
      );

      request.fields['user_id'] = Globals.userId;
      request.fields['job_order'] = widget.job.jobNo;
      request.fields['vehicle_id'] = widget.job.vehicleId;
      request.fields['token'] = Globals.token;

      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      var response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var data = json.decode(responseBody);
        if (data['status'] == 200) {
          _showSuccessMessage('Image uploaded successfully');
        } else {
          _showErrorMessage('Failed to upload image');
        }
      } else {
        _showErrorMessage('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<void> _updateStatus() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://locationtracker.cvs-global.com/api/Driver/job_vehicle_image_save'),
      );

      request.fields['user_id'] = Globals.userId;
      request.fields['job_order'] = widget.job.jobNo;
      request.fields['vehicle_id'] = widget.job.vehicleId;
      request.fields['token'] = Globals.token;

      for (var image in _imageFiles!) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      var response = await request.send();

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var data = json.decode(responseBody);
        if (data['status'] == 200) {
          _showSuccessMessage('Status updated successfully');
          setState(() {
            _isUploadButtonDisabled = true; // Disable upload button after successful save
            _imageFiles = []; // Clear the images list
            _updateButtonState(); // Update button state after clearing images
          });
        } else {
          _showErrorMessage('Failed to update status');
        }
      } else {
        _showErrorMessage('Failed to update status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorMessage('Error: $e');
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  Future<bool?> _showConfirmationDialog(String message) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _updateButtonState() {
    setState(() {
      _isButtonActive = _imageFiles != null && _imageFiles!.isNotEmpty && _imageFiles!.length < 3;
    });
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF043927),
        title: Text('Hello ${widget.job.driverName}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Status',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      color: Colors.white,
                      height: 55,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.job.vehicleNo}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            child: ElevatedButton.icon(
                              onPressed: _isUploadButtonDisabled
                                  ? null
                                  : _showImageSourceDialog,
                              icon: Icon(Icons.camera_alt),
                              label: Text('Upload Image'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFF043927),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    _imageFiles != null && _imageFiles!.isNotEmpty
                        ? Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _imageFiles!.map((image) {
                        return Image.file(
                          File(image.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                    )
                        : Container(),
                    SizedBox(height: 5),
                    Container(
                      color: Colors.black12,
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isButtonActive ? _confirmAndUploadStatus : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Job Number:', widget.job.jobNo),
                          _buildDetailRow('Start Date:', widget.job.startDate),
                          _buildDetailRow('End Date:', widget.job.endDate),
                          _buildDetailRow('Destination:', widget.job.destination),
                          _buildDetailRow('Client Name:', widget.job.clientName),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Recent',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    _jobHistories != null && _jobHistories!.isNotEmpty
                        ? Column(
                      children: _jobHistories!.reversed.map((history) {
                        return Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                history.status ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          history.vehicleNo ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          history.location ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          history.statusDate ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          history.statusTime ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'remarks:',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: _buildStatus2Widget(history.status2),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                        : Center(child: Text('No recent history available')),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              data,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus2Widget(JobStatus status2) {
    switch (status2) {
      case JobStatus.pending:

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cancel, color: Colors.orange),
            SizedBox(width: 4),
            Text(
              'Pending',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.orange,
              ),
            ),
          ],
        );
      case JobStatus.approved:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 4),
            Text(
              'Approved',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ],
        );
      default:
        return Text(
          'Unknown',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
        );
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _captureImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImages();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
