package com.java_server.shop;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api")
public class ScrapeController {

    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${auth0.domain}")
    private String domain;

    @Value("${auth0.client-id}")
    private String clientId;

    @Value("${auth0.redirect-uri}")
    private String redirectUri;

    @Value("${auth0.audience}")
    private String audience;

    @Value("${auth0.scope}")
    private String scope;


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

}
