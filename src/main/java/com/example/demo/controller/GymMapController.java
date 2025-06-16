package com.example.demo.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class GymMapController {

    @GetMapping("/gyms/map")
    public String showMapPage() {
        return "gyms/map"; // /WEB-INF/views/gyms/map.jsp
    }
}