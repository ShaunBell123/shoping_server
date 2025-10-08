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
public class ScrapeController {

    @PostMapping("scrape")
    public String scrape(@RequestBody ScrapeRequest requestBody) {

        String url = "http://python-app:8000/process";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<ScrapeRequest> request = new HttpEntity<>(requestBody, headers);

        return restTemplate.postForEntity(url, request, String.class).getBody();
    }
}
