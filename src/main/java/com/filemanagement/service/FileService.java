package com.filemanagement.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * FileService - Business Logic Layer for File Management
 *
 * Responsibilities:
 * - Save files to disk with unique IDs
 * - Retrieve file paths by unique ID
 * - Generate unique file identifiers
 * - Manage file metadata
 * 
 * Note: No database is used; file metadata is stored in memory
 */
@Service
public class FileService {

    // Store file metadata in memory (uniqueId -> original filename)
    // In production, this would be stored in a database
    private static final Map<String, String> fileMetadata = new HashMap<>();

    // Directory path for storing uploaded files
    private static final String UPLOAD_DIR = "/application_files/upload";

    /**
     * Save an uploaded file and generate a unique ID
     * 
     * @param file - The MultipartFile to save
     * @return String - The unique ID assigned to the file
     * @throws IOException - If file save operation fails
     */
    public String saveFile(MultipartFile file) throws IOException {
        // Validate input
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("File cannot be null or empty");
        }

        try {
            // Generate a unique ID using UUID
            String uniqueId = UUID.randomUUID().toString();

            // Create the upload directory if it doesn't exist
            Path uploadPath = Paths.get(UPLOAD_DIR);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
                System.out.println("✓ Created upload directory: " + UPLOAD_DIR);
            }

            // Store the original file name with the unique ID
            String originalFileName = file.getOriginalFilename();
            fileMetadata.put(uniqueId, originalFileName);

            // Create full file path: /application_files/upload/{uniqueId}_{originalFileName}
            String storedFileName = uniqueId + "_" + originalFileName;
            Path filePath = uploadPath.resolve(storedFileName);

            // Write the file to disk
            Files.write(filePath, file.getBytes());

            // Log the successful upload
            System.out.println("✓ File uploaded successfully");
            System.out.println("  - Unique ID: " + uniqueId);
            System.out.println("  - Original name: " + originalFileName);
            System.out.println("  - Stored path: " + filePath);

            // Return the unique ID to the client
            return uniqueId;

        } catch (IOException e) {
            // Log and re-throw the exception
            System.err.println("✗ Error saving file: " + e.getMessage());
            throw new IOException("Failed to save file: " + e.getMessage(), e);
        }
    }

    /**
     * Retrieve the file path by its unique ID
     * 
     * @param uniqueId - The unique identifier of the file
     * @return Path - The Path object pointing to the file
     * @throws IOException - If file is not found or cannot be accessed
     */
    public Path getFilePathById(String uniqueId) throws IOException {
        // Validate that the file exists in our metadata
        if (!fileMetadata.containsKey(uniqueId)) {
            throw new IOException("File with ID '" + uniqueId + "' not found");
        }

        // Retrieve the original file name
        String originalFileName = fileMetadata.get(uniqueId);

        // Reconstruct the stored file name (uniqueId_originalFileName)
        String storedFileName = uniqueId + "_" + originalFileName;

        // Create the full path
        Path filePath = Paths.get(UPLOAD_DIR, storedFileName);

        // Verify the file exists on disk
        if (!Files.exists(filePath)) {
            throw new IOException("File exists in metadata but not found on disk: " + filePath);
        }

        // Log the retrieval
        System.out.println("✓ File retrieved for download");
        System.out.println("  - Unique ID: " + uniqueId);
        System.out.println("  - File path: " + filePath);

        return filePath;
    }

    /**
     * Retrieve the original file name by its unique ID
     * 
     * @param uniqueId - The unique identifier of the file
     * @return String - The original file name
     * @throws IOException - If file ID is not found
     */
    public String getFileNameById(String uniqueId) throws IOException {
        // Check if the file ID exists in metadata
        if (!fileMetadata.containsKey(uniqueId)) {
            throw new IOException("File with ID '" + uniqueId + "' not found");
        }

        // Return the original file name
        return fileMetadata.get(uniqueId);
    }

    /**
     * Delete a file and its metadata by unique ID
     * (Optional utility method)
     * 
     * @param uniqueId - The unique identifier of the file
     * @return boolean - True if deletion was successful
     * @throws IOException - If file cannot be deleted
     */
    public boolean deleteFile(String uniqueId) throws IOException {
        // Check if file exists in metadata
        if (!fileMetadata.containsKey(uniqueId)) {
            throw new IOException("File with ID '" + uniqueId + "' not found");
        }

        try {
            // Get the original file name
            String originalFileName = fileMetadata.get(uniqueId);
            String storedFileName = uniqueId + "_" + originalFileName;
            Path filePath = Paths.get(UPLOAD_DIR, storedFileName);

            // Delete the file from disk if it exists
            if (Files.exists(filePath)) {
                Files.delete(filePath);
            }

            // Remove metadata entry
            fileMetadata.remove(uniqueId);

            // Log successful deletion
            System.out.println("✓ File deleted successfully: " + uniqueId);
            return true;

        } catch (IOException e) {
            System.err.println("✗ Error deleting file: " + e.getMessage());
            throw new IOException("Failed to delete file: " + e.getMessage(), e);
        }
    }

    /**
     * Get the count of uploaded files
     * 
     * @return int - Number of files currently stored
     */
    public int getFileCount() {
        return fileMetadata.size();
    }
}
