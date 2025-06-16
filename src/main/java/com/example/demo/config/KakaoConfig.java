package com.example.demo.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class KakaoConfig {
    @Value("${kakao.rest-api-key}")
    private String restApiKey;

    public String getApiKey() {
        return "KakaoAK " + restApiKey;
    }
}
