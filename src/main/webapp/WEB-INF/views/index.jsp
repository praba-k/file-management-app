<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>File Management Application</title>
    <style>
        /* ================================================================
           General Styling
           ================================================================ */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            max-width: 900px;
            width: 100%;
            padding: 40px;
        }

        h1 {
            color: #333;
            margin-bottom: 10px;
            text-align: center;
            font-size: 28px;
        }

        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 40px;
            font-size: 14px;
        }

        /* ================================================================
           API Sections Layout
           ================================================================ */
        .api-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .api-card {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 25px;
            border-radius: 8px;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .api-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .api-card h2 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .api-number {
            background: #667eea;
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 14px;
        }

        .api-description {
            color: #666;
            font-size: 13px;
            margin-bottom: 15px;
            line-height: 1.5;
        }

        /* ================================================================
           Form Styling
           ================================================================ */
        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-size: 13px;
            font-weight: 500;
        }

        input[type="text"],
        input[type="file"],
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 13px;
            font-family: 'Courier New', monospace;
            transition: border-color 0.2s;
        }

        input[type="text"]:focus,
        input[type="file"]:focus,
        textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
        }

        textarea {
            resize: vertical;
            min-height: 100px;
            font-family: 'Courier New', monospace;
        }

        /* ================================================================
           Button Styling
           ================================================================ */
        button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background: #667eea;
            color: white;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: background 0.2s, transform 0.1s;
            width: 100%;
        }

        button:hover {
            background: #5568d3;
        }

        button:active {
            transform: scale(0.98);
        }

        button:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        /* ================================================================
           Response Message Styling
           ================================================================ */
        .response-section {
            margin-top: 40px;
            padding: 20px;
            background: #f0f2f5;
            border-radius: 8px;
            display: none;
        }

        .response-section.show {
            display: block;
        }

        .response-section h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 14px;
        }

        .response-content {
            background: white;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #667eea;
            overflow-x: auto;
        }

        .response-content pre {
            font-family: 'Courier New', monospace;
            font-size: 12px;
            color: #333;
            margin: 0;
            white-space: pre-wrap;
            word-wrap: break-word;
        }

        .success {
            border-left-color: #28a745;
            background-color: #d4edda;
        }

        .error {
            border-left-color: #dc3545;
            background-color: #f8d7da;
        }

        .info {
            border-left-color: #667eea;
            background-color: #e7f0ff;
        }

        /* ================================================================
           Utility Classes
           ================================================================ */
        .text-center {
            text-align: center;
        }

        .small-text {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }

        .loading {
            display: none;
            text-align: center;
            color: #667eea;
            font-size: 13px;
            margin: 10px 0;
        }

        .loading.show {
            display: block;
        }

        .spinner {
            display: inline-block;
            width: 12px;
            height: 12px;
            border: 2px solid #667eea;
            border-radius: 50%;
            border-top-color: transparent;
            animation: spin 0.6s linear infinite;
            margin-right: 8px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        .footer {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
            color: #999;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header Section -->
        <h1>📁 File Management Application</h1>
        <p class="subtitle">A simple full-stack Spring Boot application with three REST APIs</p>

        <!-- API Grid - Three Cards for Three APIs -->
        <div class="api-grid">
            <!-- API 1: Hello World -->
            <div class="api-card">
                <h2>
                    <span class="api-number">1</span>
                    Hello World
                </h2>
                <p class="api-description">
                    Test the API with a simple greeting message. Click the button below to fetch a response from the server.
                </p>
                <div class="form-group">
                    <button onclick="callHelloWorld()">🎉 Call Hello World API</button>
                </div>
                <div class="loading" id="hello-loading">
                    <span class="spinner"></span>Loading...
                </div>
                <p class="small-text">Endpoint: GET /api/hello</p>
            </div>

            <!-- API 2: File Upload -->
            <div class="api-card">
                <h2>
                    <span class="api-number">2</span>
                    Upload File
                </h2>
                <p class="api-description">
                    Upload a file to the server. The system will generate a unique ID for your file.
                </p>
                <div class="form-group">
                    <label for="fileInput">Select File:</label>
                    <input type="file" id="fileInput" placeholder="Choose a file...">
                </div>
                <div class="form-group">
                    <button onclick="uploadFile()">📤 Upload File</button>
                </div>
                <div class="loading" id="upload-loading">
                    <span class="spinner"></span>Uploading...
                </div>
                <p class="small-text">Endpoint: POST /api/upload</p>
            </div>

            <!-- API 3: Download File -->
            <div class="api-card">
                <h2>
                    <span class="api-number">3</span>
                    Download File
                </h2>
                <p class="api-description">
                    Download a file by entering the unique ID received from the upload API.
                </p>
                <div class="form-group">
                    <label for="uniqueIdInput">Enter Unique ID:</label>
                    <input type="text" id="uniqueIdInput" placeholder="e.g., 550e8400-e29b-41d4-a716-446655440000">
                </div>
                <div class="form-group">
                    <button onclick="downloadFile()">📥 Download File</button>
                </div>
                <div class="loading" id="download-loading">
                    <span class="spinner"></span>Downloading...
                </div>
                <p class="small-text">Endpoint: GET /api/download/{uniqueId}</p>
            </div>
        </div>

        <!-- Response Display Section -->
        <div class="response-section" id="responseSection">
            <h3>📋 Response</h3>
            <div class="response-content" id="responseContent">
                <!-- Response will be displayed here -->
            </div>
        </div>

        <!-- Footer -->
        <div class="footer">
            <p>
                💡 Tip: Upload a file first to get a unique ID, then use that ID to download the file.<br>
                Built with Spring Boot | No Database Required | All files stored locally
            </p>
        </div>
    </div>

    <!-- JavaScript Code for API Interaction -->
    <script>
        /**
         * Display a response message
         * @param {string} message - The message to display
         * @param {string} type - Type of response: 'success', 'error', 'info'
         */
        function displayResponse(message, type = 'info') {
            const responseSection = document.getElementById('responseSection');
            const responseContent = document.getElementById('responseContent');
            
            // Create a pre element for code formatting
            let htmlContent = '<pre>' + escapeHtml(message) + '</pre>';
            
            responseContent.innerHTML = htmlContent;
            responseContent.className = 'response-content ' + type;
            responseSection.classList.add('show');
            
            // Scroll to response section
            responseSection.scrollIntoView({ behavior: 'smooth' });
        }

        /**
         * Escape HTML special characters
         * @param {string} text - Text to escape
         * @returns {string} - Escaped text
         */
        function escapeHtml(text) {
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text.replace(/[&<>"']/g, m => map[m]);
        }

        /**
         * API 1: Call Hello World Endpoint
         */
        function callHelloWorld() {
            // Show loading state
            document.getElementById('hello-loading').classList.add('show');

            // Make API call
            fetch('/api/hello')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    // Hide loading state
                    document.getElementById('hello-loading').classList.remove('show');
                    // Display response
                    displayResponse(JSON.stringify(data, null, 2), 'success');
                })
                .catch(error => {
                    // Hide loading state
                    document.getElementById('hello-loading').classList.remove('show');
                    // Display error
                    displayResponse('Error: ' + error.message, 'error');
                });
        }

        /**
         * API 2: Upload File
         */
        function uploadFile() {
            // Get file input
            const fileInput = document.getElementById('fileInput');
            const file = fileInput.files[0];

            // Validate file selection
            if (!file) {
                displayResponse('Please select a file before uploading', 'error');
                return;
            }

            // Show loading state
            document.getElementById('upload-loading').classList.add('show');

            // Create FormData object
            const formData = new FormData();
            formData.append('file', file);

            // Make API call
            fetch('/api/upload', {
                method: 'POST',
                body: formData
            })
                .then(response => response.json())
                .then(data => {
                    // Hide loading state
                    document.getElementById('upload-loading').classList.remove('show');
                    
                    // Display response
                    if (data.status === 'success') {
                        displayResponse(JSON.stringify(data, null, 2), 'success');
                        // Clear file input
                        fileInput.value = '';
                    } else {
                        displayResponse(JSON.stringify(data, null, 2), 'error');
                    }
                })
                .catch(error => {
                    // Hide loading state
                    document.getElementById('upload-loading').classList.remove('show');
                    // Display error
                    displayResponse('Error: ' + error.message, 'error');
                });
        }

        /**
         * API 3: Download File
         */
        function downloadFile() {
            // Get unique ID
            const uniqueId = document.getElementById('uniqueIdInput').value;

            // Validate unique ID
            if (!uniqueId.trim()) {
                displayResponse('Please enter a unique ID', 'error');
                return;
            }

            // Show loading state
            document.getElementById('download-loading').classList.add('show');

            // Make API call
            fetch('/api/download/' + encodeURIComponent(uniqueId))
                .then(response => {
                    if (!response.ok) {
                        if (response.status === 404) {
                            throw new Error('File not found. Please check the unique ID.');
                        }
                        throw new Error('Download failed with status ' + response.status);
                    }
                    // Get filename from Content-Disposition header
                    const contentDisposition = response.headers.get('content-disposition');
                    let filename = 'download';
                    if (contentDisposition) {
                        const filenameMatch = contentDisposition.match(/filename="?(.+?)"?$/);
                        if (filenameMatch) filename = filenameMatch[1];
                    }
                    
                    return response.blob().then(blob => ({
                        blob: blob,
                        filename: filename
                    }));
                })
                .then(data => {
                    // Hide loading state
                    document.getElementById('download-loading').classList.remove('show');
                    
                    // Create download link and trigger download
                    const url = window.URL.createObjectURL(data.blob);
                    const link = document.createElement('a');
                    link.href = url;
                    link.download = data.filename;
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                    window.URL.revokeObjectURL(url);
                    
                    // Display success message
                    displayResponse('File downloaded successfully: ' + data.filename, 'success');
                })
                .catch(error => {
                    // Hide loading state
                    document.getElementById('download-loading').classList.remove('show');
                    // Display error
                    displayResponse('Error: ' + error.message, 'error');
                });
        }

        /**
         * Allow Enter key to trigger upload when file is selected
         */
        document.getElementById('fileInput').addEventListener('keypress', function(event) {
            if (event.key === 'Enter') {
                uploadFile();
            }
        });

        /**
         * Allow Enter key to trigger download when ID is entered
         */
        document.getElementById('uniqueIdInput').addEventListener('keypress', function(event) {
            if (event.key === 'Enter') {
                downloadFile();
            }
        });

        // Log when page loads
        console.log('✓ File Management Application loaded successfully');
    </script>
</body>
</html>
