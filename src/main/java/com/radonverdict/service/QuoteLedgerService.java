package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.QuoteLedgerSubmissionRequest;
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
public class QuoteLedgerService {

    @Value("${app.storage.quote-ledger-csv-path:data/quote_ledger.csv}")
    private String quoteLedgerCsvPath;

    private final Object writeLock = new Object();

    public void submit(QuoteLedgerSubmissionRequest request, County county, String ipAddress, String userAgent) {
        try {
            synchronized (writeLock) {
                Path path = Paths.get(quoteLedgerCsvPath);
                if (path.getParent() != null) {
                    Files.createDirectories(path.getParent());
                }

                boolean isNewFile = !Files.exists(path);
                try (PrintWriter pw = new PrintWriter(new FileWriter(path.toFile(), true))) {
                    if (isNewFile) {
                        pw.println("Date,Zip,State,County,Role,ResultBand,RadonReadingPciL,Foundation,QuoteStatus,QuotedPrice,FinalPrice,SystemScope,Timeline,Email,Notes,IpAddress,UserAgent");
                    }

                    String date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                    pw.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                            date,
                            escapeCsv(request.getZipCode()),
                            escapeCsv(county != null ? county.getStateAbbr() : ""),
                            escapeCsv(county != null ? county.getCountySlug() : ""),
                            escapeCsv(request.getRole()),
                            escapeCsv(request.getResultBand()),
                            escapeCsv(request.getRadonReadingPciL()),
                            escapeCsv(request.getFoundationType()),
                            escapeCsv(request.getQuoteStatus()),
                            escapeCsv(request.getQuotedPrice()),
                            escapeCsv(request.getFinalPrice()),
                            escapeCsv(request.getSystemScope()),
                            escapeCsv(request.getTimeline()),
                            escapeCsv(request.getEmail()),
                            escapeCsv(request.getNotes()),
                            escapeCsv(ipAddress),
                            escapeCsv(userAgent));
                }
            }
        } catch (IOException e) {
            log.error("Failed to write quote ledger row", e);
            throw new RuntimeException("Could not save quote ledger row", e);
        }
    }

    private String escapeCsv(String value) {
        if (value == null) {
            return "";
        }
        return value
                .replace("\r", " ")
                .replace("\n", " ")
                .replace("\"", "\"\"");
    }
}
