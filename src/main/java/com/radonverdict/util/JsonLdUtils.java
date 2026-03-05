package com.radonverdict.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public final class JsonLdUtils {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    private JsonLdUtils() {
    }

    public static String json(String value) {
        if (value == null) {
            return "null";
        }
        try {
            return OBJECT_MAPPER.writeValueAsString(value);
        } catch (JsonProcessingException e) {
            return "\"\"";
        }
    }
}
