package com.java_server.shop;

import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class ScrapeController {

    @PostMapping("/scrape")
    public ResponseEntity<String> scrape(@RequestBody Map<String, Object> requestBody) {

        System.err.println("Received scrape request: " + requestBody);

        String url = "http://python-app:8000/process";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);

        RestTemplate restTemplate = new RestTemplate();
        
        ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);

        ResponseEntity<String> finalResponse = ResponseEntity
        .status(response.getStatusCode())
        .body(response.getBody());

        return finalResponse;
    }

}
