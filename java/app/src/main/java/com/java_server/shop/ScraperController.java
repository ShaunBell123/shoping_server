package com.java_server.shop;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class ScraperController {

    private final RestTemplate restTemplate = new RestTemplate();

    @PostMapping("/scrape")
    public String scrape() {
        String url = "http://python-app:8000/process"; // Python endpoint
        ResponseEntity<String> response = restTemplate.postForEntity(url, null, String.class);
        return response.getBody();
    }
}
