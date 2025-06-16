package com.example.demo.controller;

import com.example.demo.dto.KakaoPlaceDto;
import com.example.demo.dto.KakaoSearchResponseDto;
import com.example.demo.service.KakaoLocalService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/kakao")
public class KakaoLocalController {

    private final KakaoLocalService kakaoLocalService;

    @Autowired
    public KakaoLocalController(KakaoLocalService kakaoLocalService) {
        this.kakaoLocalService = kakaoLocalService;
    }

    @GetMapping("/gyms")
    public List<KakaoPlaceDto> getNearbyGyms(@RequestParam double lat, @RequestParam double lon) {
        try {
            KakaoSearchResponseDto response = kakaoLocalService.searchGyms(lat, lon, 2000).block();
            return response.getDocuments();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
