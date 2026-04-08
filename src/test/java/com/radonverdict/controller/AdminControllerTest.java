package com.radonverdict.controller;

import com.radonverdict.model.entity.Lead;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class AdminControllerTest {

    @Test
    void parseCsvColumnsHandlesQuotedCommasAndEscapedQuotes() {
        String line = "\"2026-04-08 10:00:00\",\"Doe, Jane \"\"JJ\"\"\",\"\",\"jane@example.com\",\"22046\",\"VA\",\"falls-church-city\",\"other, hybrid\",\"true\",\"homeowner\",\"not_tested\"";

        List<String> columns = AdminController.parseCsvColumns(line);

        assertThat(columns).hasSize(11);
        assertThat(columns.get(1)).isEqualTo("Doe, Jane \"JJ\"");
        assertThat(columns.get(7)).isEqualTo("other, hybrid");
        assertThat(columns.get(10)).isEqualTo("not_tested");
    }

    @Test
    void parseLeadPreservesCommaSeparatedValues() {
        AdminController controller = new AdminController();
        String line = "\"2026-04-08 10:00:00\",\"Doe, Jane\",\"\",\"jane@example.com\",\"22046\",\"VA\",\"falls-church-city\",\"other, hybrid\",\"true\",\"homeowner\",\"not_tested\"";

        Lead lead = ReflectionTestUtils.invokeMethod(controller, "parseLead", line);

        assertThat(lead).isNotNull();
        assertThat(lead.getCustomerName()).isEqualTo("Doe, Jane");
        assertThat(lead.getFoundationType()).isEqualTo("other, hybrid");
        assertThat(lead.getCustomerEmail()).isEqualTo("jane@example.com");
        assertThat(lead.getIsTested()).isTrue();
    }
}
