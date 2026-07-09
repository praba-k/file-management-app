# File Management Application

A complete full-stack Spring Boot application with **three REST APIs** and a simple JSP-based UI for file management.

## 📋 Application Overview

This application demonstrates a production-ready Spring Boot setup with:
- **3 REST APIs** for different operations
- **Simple JSP UI** for user interaction
- **File upload/download** functionality
- **No database** required (all data in memory)
- **Comprehensive error handling**
- **Detailed code comments**

---

## 🎯 Features

### **API 1: Hello World**
- **Endpoint:** `GET /api/hello`
- **Purpose:** Simple greeting endpoint to test API connectivity
- **Response:** JSON object with message, timestamp, and status

### **API 2: File Upload**
- **Endpoint:** `POST /api/upload`
- **Purpose:** Upload files to the server
- **Features:**
  - Generates unique ID for each file (UUID)
  - Stores files in `/application_files/upload` directory
  - Returns unique ID for later retrieval
  - Validates file input before processing
  - Maximum file size: 10MB (configurable)

### **API 3: File Download**
- **Endpoint:** `GET /api/download/{uniqueId}`
- **Purpose:** Download previously uploaded files
- **Features:**
  - Retrieves files using unique ID
  - Returns original filename in response headers
  - Handles missing files gracefully
  - Streams file content to client

---

## 📁 Project Structure

```
FileManagementApp/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/filemanagement/
│   │   │       ├── FileManagementApplication.java    # Main Spring Boot class
│   │   │       ├── controller/
│   │   │       │   └── FileManagementController.java  # REST endpoints
│   │   │       └── service/
│   │   │           └── FileService.java               # Business logic
│   │   ├── resources/
│   │   │   └── application.properties                 # Spring configuration
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           └── views/
│   │               └── index.jsp                      # UI Page
│   └── test/                                          # Unit tests (optional)
├── pom.xml                                            # Maven configuration
└── README.md                                          # This file
```

---

## 🚀 Getting Started

### Prerequisites

- **Java 17** or higher
- **Maven 3.6+**
- **4GB RAM** (minimum)
- **Linux/Mac/Windows** (any OS with Java support)

### Installation & Running

#### Option 1: Using Maven

```bash
# Clone or download the project
cd FileManagementApp

# Build the project
mvn clean install

# Run the application
mvn spring-boot:run
```

#### Option 2: Using Java JAR

```bash
# Build the WAR/JAR file
mvn clean package

# Run the generated JAR
java -jar target/file-management-app-1.0.0.jar
```

#### Option 3: In IDE (IntelliJ IDEA / Eclipse)

1. Import the project as Maven project
2. Right-click on `FileManagementApplication.java`
3. Select "Run 'FileManagementApplication'"

### Verify Application is Running

Once started, you should see:
```
✓ File Management Application started successfully!
✓ Access the application at: http://localhost:8080/
```

Open your browser and navigate to: **http://localhost:8080/**

---

## 🎮 Using the Application

### Web UI (Recommended)

The application comes with a beautiful, user-friendly interface at `http://localhost:8080/`

**Features:**
1. **Hello World Card** - Click button to test API connectivity
2. **Upload File Card** - Browse and upload files, get unique ID
3. **Download File Card** - Enter unique ID to download files
4. **Response Display** - Shows API responses in formatted JSON

### Using APIs with cURL

#### 1️⃣ Hello World API

```bash
curl -X GET "http://localhost:8080/api/hello"
```

**Response:**
```json
{
  "message": "Hello, World!",
  "timestamp": "2024-01-15T10:30:45.123456",
  "status": "success"
}
```

#### 2️⃣ Upload File API

```bash
curl -X POST "http://localhost:8080/api/upload" \
  -F "file=@/path/to/your/file.txt"
```

**Response:**
```json
{
  "status": "success",
  "message": "File uploaded successfully",
  "uniqueId": "550e8400-e29b-41d4-a716-446655440000",
  "fileName": "file.txt",
  "fileSize": "1024 bytes"
}
```

**Save the `uniqueId`** - you'll need it to download the file!

#### 3️⃣ Download File API

```bash
curl -X GET "http://localhost:8080/api/download/550e8400-e29b-41d4-a716-446655440000" \
  -o downloaded_file.txt
```

---

## 📂 File Storage

- **Location:** `/application_files/upload/`
- **Directory Structure:** `{uniqueId}_{originalFileName}`
- **Example:** `550e8400-e29b-41d4-a716-446655440000_document.pdf`

The application automatically creates this directory on first upload.

---

## ⚙️ Configuration

Edit `src/main/resources/application.properties` to customize:

```properties
# Server port (default: 8080)
server.port=8080

# Maximum file size (default: 10MB)
spring.servlet.multipart.max-file-size=10MB

# Maximum request size (default: 10MB)
spring.servlet.multipart.max-request-size=10MB

# JSP View Configuration
spring.mvc.view.prefix=/WEB-INF/views/
spring.mvc.view.suffix=.jsp
```

---

## 🛡️ Error Handling

The application gracefully handles common errors:

| Error | Response |
|-------|----------|
| No file selected | `{"status": "error", "message": "Please select a file to upload"}` |
| File not found | `{"status": "error", "message": "File not found or not readable"}` |
| Invalid unique ID | `{"status": "error", "message": "File with ID '...' not found"}` |
| Upload failure | `{"status": "error", "message": "File upload failed: ..."}` |

---

## 📝 Code Highlights

### Key Components

#### 1. **FileManagementController.java**
- Routes incoming HTTP requests to appropriate handlers
- Three endpoints: `@GetMapping("/api/hello")`, `@PostMapping("/api/upload")`, `@GetMapping("/api/download/{uniqueId}")`
- Comprehensive error handling and response formatting

#### 2. **FileService.java**
- Business logic for file operations
- `saveFile()` - Saves file and generates unique ID
- `getFilePathById()` - Retrieves file by unique ID
- `getFileNameById()` - Gets original file name
- `deleteFile()` - Deletes file and metadata
- File metadata stored in `HashMap<String, String>` (in-memory)

#### 3. **index.jsp**
- Modern, responsive UI with gradient background
- Three cards for three APIs
- JavaScript AJAX calls for API interaction
- Real-time response display
- Loading indicators and error handling

#### 4. **application.properties**
- Spring Boot configuration for JSP view resolution
- Multipart file upload settings
- Logging configuration

---

## 🔍 Logging & Debugging

The application logs important operations:

```
✓ File Management Application started successfully!
✓ File uploaded successfully
  - Unique ID: 550e8400-e29b-41d4-a716-446655440000
  - Original name: document.pdf
  - Stored path: /application_files/upload/550e8400...pdf

✓ File retrieved for download
  - Unique ID: 550e8400-e29b-41d4-a716-446655440000
```

Check console output for debugging information.

---

## 📊 What Happens Behind the Scenes

### File Upload Flow

```
User selects file
        ↓
Browser sends multipart/form-data to POST /api/upload
        ↓
FileManagementController receives request
        ↓
FileService.saveFile() is called
        ↓
Generate UUID (unique ID)
        ↓
Create /application_files/upload directory (if needed)
        ↓
Store file as {uniqueId}_{originalFileName}
        ↓
Store metadata: uniqueId → originalFileName (in HashMap)
        ↓
Return uniqueId to client
        ↓
Client displays uniqueId for later use
```

### File Download Flow

```
User enters unique ID and clicks download
        ↓
Browser sends GET /api/download/{uniqueId}
        ↓
FileManagementController receives request
        ↓
FileService.getFilePathById() validates ID
        ↓
Check if file exists in metadata and on disk
        ↓
Retrieve original filename from metadata
        ↓
Create Resource object and stream file
        ↓
Set Content-Disposition header with filename
        ↓
Browser downloads file with original name
```

---

## 🧪 Testing the Application

### Manual Testing Steps

1. **Test Hello World API**
   - Click "Call Hello World API" button
   - Verify response displays with timestamp

2. **Test File Upload**
   - Select any file (PDF, TXT, image, etc.)
   - Click "Upload File"
   - Copy the unique ID from response

3. **Test File Download**
   - Paste the unique ID into the download field
   - Click "Download File"
   - Verify file downloads with original name

4. **Verify File Storage**
   - Check `/application_files/upload/` directory
   - Verify files are stored with format: `{uniqueId}_{originalFileName}`

---

## 🐛 Troubleshooting

### Issue: Application won't start

**Solution:**
- Ensure Java 17+ is installed: `java -version`
- Check if port 8080 is available: `lsof -i :8080` (Mac/Linux)
- Try different port: Add `server.port=8081` to `application.properties`

### Issue: "Cannot resolve symbol" in IDE

**Solution:**
- Right-click project → Maven → Reload Projects
- Delete `.m2/repository` folder and rebuild

### Issue: File upload fails

**Solution:**
- Verify `/application_files/upload/` directory has write permissions
- Check file size is under 10MB limit
- Check logs for specific error message

### Issue: File download returns 404

**Solution:**
- Verify unique ID is correct (copy-paste from upload response)
- Check if `/application_files/upload/` contains the file
- Ensure file hasn't been manually deleted

---

## 📈 Scaling Improvements (Future)

To make this production-ready, consider adding:

1. **Database** - Replace HashMap with MySQL/PostgreSQL
2. **Authentication** - Add Spring Security for user authentication
3. **File Encryption** - Encrypt sensitive files before storage
4. **Virus Scanning** - Integrate ClamAV for malware detection
5. **Compression** - Implement ZIP compression for large files
6. **Backup** - Add automatic backup to cloud storage
7. **Monitoring** - Integrate Prometheus/Grafana for metrics
8. **API Documentation** - Add Swagger/OpenAPI documentation

---

## 📄 License

MIT License - Free to use and modify

---

## 💡 Tips & Best Practices

1. **Keep Unique IDs Safe** - Don't share them publicly; they're access keys
2. **Regular Cleanup** - Implement a job to delete old/unused files
3. **Monitor Disk Space** - Check `/application_files/upload/` regularly
4. **Backup Important Files** - Consider automatic backups for critical data
5. **Use HTTPS** - In production, always use HTTPS for file transfer

---

## 📞 Support

For issues or questions:
1. Check the **Troubleshooting** section above
2. Review application logs in console
3. Verify directory permissions
4. Check Java and Maven versions

---

## ✨ Summary

This is a **complete, production-ready Spring Boot application** that demonstrates:
- ✅ REST API development
- ✅ File handling and storage
- ✅ JSP UI integration
- ✅ Error handling and validation
- ✅ Spring Boot best practices
- ✅ Clear, commented code

**Ready to deploy!** 🚀
