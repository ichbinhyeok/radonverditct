package com.radonverdict;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(properties = {
        "app.site.enforce-canonical-host=false",
        "app.site.retire-non-evidence-county-pages=true",
        "app.product.legacy-surfaces-enabled=false"
})
@AutoConfigureMockMvc
class ProductPivotPolicyIntegrationTest {
    @Autowired MockMvc mockMvc;

    @Test
    void retiresModeledCostSurfaceAndRedirectsOldPlan() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/virginia/fairfax-county"))
                .andExpect(status().isGone())
                .andExpect(header().string("X-Robots-Tag", "noindex, noarchive"))
                .andExpect(content().string(containsString("could not support a defensible local answer")));
        mockMvc.perform(get("/client-action-plan"))
                .andExpect(status().isMovedPermanently())
                .andExpect(header().string("Location", "/plan"));
        mockMvc.perform(get("/guides"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Radon test field manual")));
        mockMvc.perform(get("/radon-levels/florida")).andExpect(status().isGone());
        mockMvc.perform(get("/guides/how-to-test-for-radon")).andExpect(status().isOk());
    }

    @Test
    void exposesOnlyTheControlledEvidenceAndIntentCohortsThroughMainSitemap() throws Exception {
        mockMvc.perform(get("/radon-levels/florida/marion-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Radon Zone &amp; Test Data")));
        mockMvc.perform(get("/radon-levels/new-york/schenectady-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Radon Zone &amp; Test Data")));
        mockMvc.perform(get("/radon-levels/virginia/fairfax-county"))
                .andExpect(status().isGone());
        mockMvc.perform(get("/radon-testing/new-york/ulster-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Radon Gas Testing")));
        mockMvc.perform(get("/radon-testing/virginia/fairfax-county"))
                .andExpect(status().isNotFound());
        mockMvc.perform(get("/sitemap.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/sitemap-county-evidence.xml")))
                .andExpect(content().string(not(containsString("/sitemap-cost-evidence.xml"))))
                .andExpect(content().string(containsString("/sitemap-intent.xml")));
        mockMvc.perform(get("/sitemap-county-evidence.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-levels/new-york/schenectady-county")))
                .andExpect(content().string(containsString("/radon-levels/new-york/ulster-county")));
        mockMvc.perform(get("/sitemap-intent.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-testing/new-york/ulster-county")));
    }

    @Test
    void keepsInspectorHandoffSecondaryAndOutOfTheIndexableCore() throws Exception {
        mockMvc.perform(get("/for-home-inspectors"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("noindex, follow")));
        mockMvc.perform(get("/sitemap-core.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("/for-home-inspectors"))));
        mockMvc.perform(get("/radon-data-sources"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("/radon-cost-data-report"))));
    }
}
