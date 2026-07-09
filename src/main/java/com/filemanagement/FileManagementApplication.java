package com.filemanagement;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main Spring Boot Application Class
 * This class serves as the entry point for the File Management Application
 * 
 * Features:
 * 1. Hello World API - Simple greeting endpoint
 * 2. File Upload API - Accepts files and stores them with a unique ID
 * 3. File Download API - Retrieves files by unique ID
 * 
 * No database is required for this application
 */
@SpringBootApplication
public class FileManagementApplication {

    public static void main(String[] args) {
        // Start the Spring Boot application
        SpringApplication.run(FileManagementApplication.class, args);
        System.out.println("✓ File Management Application started successfully!");
        System.out.println("✓ Access the application at: http://localhost:8080/");
    }
}
