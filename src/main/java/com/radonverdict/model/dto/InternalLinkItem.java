package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class InternalLinkItem {
    private String title;
    private String description;
    private String url;
    private String bucket;
}
