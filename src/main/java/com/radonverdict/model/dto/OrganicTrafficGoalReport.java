package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class OrganicTrafficGoalReport {
    private boolean dailyExportAvailable;
    private int dailyClickGoal;
    private int daysObserved;
    private String firstDate;
    private String lastDate;
    private double observedDailyClicks;
    private double dailyClickShortfall;
    private String summary;
    private List<Cluster> clusters;

    @Data
    @Builder
    public static class Cluster {
        private String name;
        private int dailyClickTarget;
        private double observedDailyClicks;
        private double dailyClickShortfall;
        private List<String> paths;
    }
}
