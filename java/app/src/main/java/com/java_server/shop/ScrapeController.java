package com.java_server.shop;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api")
public class ScrapeController {

    private final RestTemplate restTemplate = new RestTemplate();

    @PostMapping("/private/scrape")
    @PreAuthorize("hasAuthority('SCOPE_scrape:read')")
    public String scrape(@RequestBody ScrapeRequest requestBody) {

        String url = "http://python-app:8000/process";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<ScrapeRequest> request = new HttpEntity<>(requestBody, headers);

        try {
            return restTemplate.postForEntity(url, request, String.class).getBody();
        } catch (Exception e) {
            e.printStackTrace();
            return "Error calling Python service: " + e.getMessage();
        }
    }


    @GetMapping("/private")
    public String privateEndpoint() {
        return "This is private - valid token required.";
    }

    @GetMapping("/public")
    public String publicEndpoint() {
        return "This is public - no token required.";
    }

}
