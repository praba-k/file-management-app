package com.filemanagement.controller;

import com.filemanagement.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.file.Path;
import java.util.HashMap;
import java.util.Map;

/**
 * FileManagementController - Handles all HTTP requests
 * This controller manages:
 * 1. GET /api/hello - Hello World endpoint
 * 2. POST /api/upload - File upload with unique ID generation
 * 3. GET /api/download/{uniqueId} - File download by unique ID
 * 4. GET / - Serves JSP UI page
 */
@Controller
public class FileManagementController {

    // Inject the FileService to handle file operations
    @Autowired
    private FileService fileService;

    /**
     * API Endpoint 1: Hello World
     * Returns a simple greeting message
     * 
     * @return ResponseEntity with JSON message
     */
    @GetMapping("/api/hello")
    @ResponseBody
    public Map<String, String> helloWorld() {
        // Create response map
        Map<String, String> response = new HashMap<>();
        response.put("message", "Hello, World!");
        response.put("timestamp", java.time.LocalDateTime.now().toString());
        response.put("status", "success");
        
        // Return the greeting
        return response;
    }

    /**
     * API Endpoint 2: File Upload
     * Accepts a file from the client and stores it in /application_files/upload
     * Generates a unique ID for the uploaded file
     * 
     * @param file - The file to be uploaded (from form/request)
     * @return ResponseEntity with unique file ID and status
     */
    @PostMapping("/api/upload")
    @ResponseBody
    public ResponseEntity<?> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            // Validate that a file was provided
            if (file.isEmpty()) {
                Map<String, String> error = new HashMap<>();
                error.put("status", "error");
                error.put("message", "Please select a file to upload");
                return ResponseEntity.badRequest().body(error);
            }

            // Call service to save file and get unique ID
            String uniqueId = fileService.saveFile(file);

            // Prepare success response
            Map<String, String> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "File uploaded successfully");
            response.put("uniqueId", uniqueId);
            response.put("fileName", file.getOriginalFilename());
            response.put("fileSize", file.getSize() + " bytes");
            
            // Return the response with 200 OK status
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            // Handle upload errors
            Map<String, String> error = new HashMap<>();
            error.put("status", "error");
            error.put("message", "File upload failed: " + e.getMessage());
            
            return ResponseEntity.internalServerError().body(error);
        }
    }

    /**
     * API Endpoint 3: File Download
     * Retrieves and returns a file based on the unique ID
     * 
     * @param uniqueId - The unique identifier of the file to download
     * @return ResponseEntity with the file content
     */
    @GetMapping("/api/download/{uniqueId}")
    public ResponseEntity<?> downloadFile(@PathVariable String uniqueId) {
        try {
            // Call service to retrieve file path
            Path filePath = fileService.getFilePathById(uniqueId);

            // Create resource from the file
            Resource resource = new UrlResource(filePath.toUri());

            // Check if file exists and is readable
            if (!resource.exists() || !resource.isReadable()) {
                Map<String, String> error = new HashMap<>();
                error.put("status", "error");
                error.put("message", "File not found or not readable");
                return ResponseEntity.notFound().build();
            }

            // Get the original file name from the stored metadata
            String originalFileName = fileService.getFileNameById(uniqueId);

            // Return the file with proper headers
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, 
                            "attachment; filename=\"" + originalFileName + "\"")
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM_VALUE)
                    .body(resource);

        } catch (Exception e) {
            // Handle download errors
            Map<String, String> error = new HashMap<>();
            error.put("status", "error");
            error.put("message", "File download failed: " + e.getMessage());
            
            return ResponseEntity.internalServerError().body(error);
        }
    }

    /**
     * Serves the JSP UI page
     * Maps the root path to index.jsp
     * 
     * @return String - Name of the JSP view to render
     */
    @GetMapping("/")
    public String index() {
        // Return the JSP view name (Spring will look for index.jsp in /WEB-INF/views/)
        return "index";
    }
}
