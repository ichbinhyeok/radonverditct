package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.QuoteLedgerBenchmarkRow;
import com.radonverdict.model.dto.QuoteLedgerBenchmarkSnapshot;
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
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Slf4j
@Service
public class QuoteLedgerService {

    private static final int PUBLIC_PRICE_THRESHOLD = 3;

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

    public QuoteLedgerBenchmarkSnapshot getBenchmarkSnapshot() {
        List<LedgerRow> rows = readLedgerRows();
        Map<String, SegmentAccumulator> segments = new LinkedHashMap<>();
        Set<String> states = new HashSet<>();
        Set<String> counties = new HashSet<>();
        int pricedCount = 0;

        for (LedgerRow row : rows) {
            if (!row.stateAbbr().isBlank()) {
                states.add(row.stateAbbr());
            }
            if (!row.stateAbbr().isBlank() && !row.countySlug().isBlank()) {
                counties.add(row.stateAbbr() + ":" + row.countySlug());
            }
            Integer price = row.publicPrice();
            if (price != null) {
                pricedCount++;
            }

            String key = row.stateAbbr() + "|" + row.countySlug() + "|" + row.foundationType() + "|" + row.resultBand();
            segments.computeIfAbsent(key, ignored -> new SegmentAccumulator(row)).add(row);
        }

        List<QuoteLedgerBenchmarkRow> publicRows = segments.values().stream()
                .sorted(Comparator
                        .comparingInt(SegmentAccumulator::pricedSignalCount).reversed()
                        .thenComparingInt(SegmentAccumulator::signalCount).reversed()
                        .thenComparing(SegmentAccumulator::marketLabel))
                .limit(12)
                .map(SegmentAccumulator::toPublicRow)
                .toList();

        int publicBenchmarkCount = (int) publicRows.stream()
                .filter(row -> row.getPricedSignalCount() >= PUBLIC_PRICE_THRESHOLD)
                .count();

        return QuoteLedgerBenchmarkSnapshot.builder()
                .totalSignalCount(rows.size())
                .pricedSignalCount(pricedCount)
                .publicBenchmarkCount(publicBenchmarkCount)
                .stateCount(states.size())
                .countyCount(counties.size())
                .freshnessLabel(rows.isEmpty() ? "No public signals yet" : "Updated from anonymized submissions")
                .rows(publicRows)
                .build();
    }

    public String publicBenchmarkCsv() {
        StringBuilder csv = new StringBuilder();
        csv.append("Market,State,County,Foundation,ResultBand,SignalCount,PricedSignalCount,PriceRange,Median,Confidence\n");
        for (QuoteLedgerBenchmarkRow row : getBenchmarkSnapshot().getRows()) {
            csv.append(csv(row.getMarketLabel())).append(',')
                    .append(csv(row.getStateAbbr())).append(',')
                    .append(csv(row.getCountySlug())).append(',')
                    .append(csv(row.getFoundationLabel())).append(',')
                    .append(csv(row.getResultBandLabel())).append(',')
                    .append(row.getSignalCount()).append(',')
                    .append(row.getPricedSignalCount()).append(',')
                    .append(csv(row.getPriceRangeDisplay())).append(',')
                    .append(csv(row.getMedianPriceDisplay())).append(',')
                    .append(csv(row.getConfidenceLabel())).append('\n');
        }
        return csv.toString();
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

    private List<LedgerRow> readLedgerRows() {
        Path path = Paths.get(quoteLedgerCsvPath);
        if (!Files.exists(path)) {
            return List.of();
        }

        try {
            List<String> lines = Files.readAllLines(path);
            if (lines.size() <= 1) {
                return List.of();
            }

            List<LedgerRow> rows = new ArrayList<>();
            for (int i = 1; i < lines.size(); i++) {
                List<String> columns = parseCsvLine(lines.get(i));
                if (columns.size() < 11) {
                    continue;
                }
                rows.add(new LedgerRow(
                        get(columns, 2),
                        get(columns, 3),
                        get(columns, 5),
                        get(columns, 7),
                        get(columns, 8),
                        parsePrice(get(columns, 9)),
                        parsePrice(get(columns, 10))));
            }
            return rows;
        } catch (IOException e) {
            log.warn("Could not read quote ledger benchmark rows from {}", quoteLedgerCsvPath, e);
            return List.of();
        }
    }

    private List<String> parseCsvLine(String line) {
        List<String> values = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean quoted = false;
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == '"') {
                if (quoted && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    current.append('"');
                    i++;
                } else {
                    quoted = !quoted;
                }
            } else if (c == ',' && !quoted) {
                values.add(current.toString());
                current.setLength(0);
            } else {
                current.append(c);
            }
        }
        values.add(current.toString());
        return values;
    }

    private String get(List<String> values, int index) {
        if (index < 0 || index >= values.size() || values.get(index) == null) {
            return "";
        }
        return values.get(index).trim();
    }

    private Integer parsePrice(String value) {
        if (value == null || value.isBlank() || !value.matches("^\\d{2,6}$")) {
            return null;
        }
        return Integer.parseInt(value);
    }

    private String csv(String value) {
        return "\"" + (value == null ? "" : escapeCsv(value)) + "\"";
    }

    private String formatDollars(int value) {
        return "$" + String.format(java.util.Locale.US, "%,d", value);
    }

    private String displayFoundation(String value) {
        return switch (value == null ? "" : value) {
            case "basement" -> "Basement";
            case "slab" -> "Slab";
            case "crawlspace" -> "Crawl space";
            case "mixed" -> "Mixed";
            default -> "Unknown";
        };
    }

    private String displayResultBand(String value) {
        return switch (value == null ? "" : value) {
            case "above_8" -> "8.0+ pCi/L";
            case "above_4" -> "4.0+ pCi/L";
            case "between_2_and_4" -> "2.0-3.9 pCi/L";
            case "under_2" -> "Under 2.0";
            case "not_tested" -> "Not tested yet";
            default -> "Unknown";
        };
    }

    private String displayCounty(String countySlug) {
        if (countySlug == null || countySlug.isBlank()) {
            return "Unknown county";
        }
        String[] parts = countySlug.split("-");
        StringBuilder label = new StringBuilder();
        for (String part : parts) {
            if (part.isBlank()) {
                continue;
            }
            if (label.length() > 0) {
                label.append(' ');
            }
            label.append(part.substring(0, 1).toUpperCase(java.util.Locale.ROOT))
                    .append(part.substring(1));
        }
        return label.toString();
    }

    private record LedgerRow(
            String stateAbbr,
            String countySlug,
            String resultBand,
            String foundationType,
            String quoteStatus,
            Integer quotedPrice,
            Integer finalPrice) {

        Integer publicPrice() {
            if (finalPrice != null) {
                return finalPrice;
            }
            return quotedPrice;
        }
    }

    private class SegmentAccumulator {
        private final LedgerRow seed;
        private final List<Integer> prices = new ArrayList<>();
        private int signalCount;

        SegmentAccumulator(LedgerRow seed) {
            this.seed = seed;
        }

        void add(LedgerRow row) {
            signalCount++;
            Integer price = row.publicPrice();
            if (price != null) {
                prices.add(price);
            }
        }

        int signalCount() {
            return signalCount;
        }

        int pricedSignalCount() {
            return prices.size();
        }

        String marketLabel() {
            String state = seed.stateAbbr().isBlank() ? "" : ", " + seed.stateAbbr();
            return displayCounty(seed.countySlug()) + state;
        }

        QuoteLedgerBenchmarkRow toPublicRow() {
            prices.sort(Integer::compareTo);
            boolean publicPrice = prices.size() >= PUBLIC_PRICE_THRESHOLD;
            String priceRange = publicPrice
                    ? formatDollars(prices.get(0)) + "-" + formatDollars(prices.get(prices.size() - 1))
                    : "Hidden until 3 priced signals";
            String median = publicPrice
                    ? formatDollars(prices.get(prices.size() / 2))
                    : "Collecting";
            String confidence = publicPrice
                    ? prices.size() >= 10 ? "Benchmark ready" : "Early benchmark"
                    : "Need " + Math.max(0, PUBLIC_PRICE_THRESHOLD - prices.size()) + " more priced signals";

            return QuoteLedgerBenchmarkRow.builder()
                    .marketLabel(marketLabel())
                    .stateAbbr(seed.stateAbbr())
                    .countySlug(seed.countySlug())
                    .foundationLabel(displayFoundation(seed.foundationType()))
                    .resultBandLabel(displayResultBand(seed.resultBand()))
                    .signalCount(signalCount)
                    .pricedSignalCount(prices.size())
                    .priceRangeDisplay(priceRange)
                    .medianPriceDisplay(median)
                    .confidenceLabel(confidence)
                    .build();
        }
    }
}
