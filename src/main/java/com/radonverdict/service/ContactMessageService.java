package com.radonverdict.service;

import com.radonverdict.model.dto.ContactSubmissionRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Slf4j
@Service
public class ContactMessageService {

    @Value("${app.storage.contact-csv-path:data/contact_messages.csv}")
    private String contactCsvPath;

    private final Object writeLock = new Object();

    public void submit(ContactSubmissionRequest request, String ipAddress, String userAgent) {
        try {
            synchronized (writeLock) {
                Path path = Paths.get(contactCsvPath);
                if (path.getParent() != null) {
                    Files.createDirectories(path.getParent());
                }

                boolean isNewFile = !Files.exists(path);
                try (PrintWriter pw = new PrintWriter(new FileWriter(path.toFile(), true))) {
                    if (isNewFile) {
                        pw.println("Date,Name,Email,Message,IpAddress,UserAgent");
                    }

                    String date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                    pw.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                            date,
                            escapeCsv(request.getName()),
                            escapeCsv(request.getEmail()),
                            escapeCsv(request.getMessage()),
                            escapeCsv(ipAddress),
                            escapeCsv(userAgent));
                }
            }
        } catch (IOException e) {
            log.error("Failed to write contact message to CSV", e);
            throw new RuntimeException("Could not save contact message", e);
        }
    }

    private String escapeCsv(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\"", "\"\"");
    }
}
