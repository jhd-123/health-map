package com.example.demo.dto;

public class KakaoPlaceDto {
    private String place_name;
    private String road_address_name;
    private String phone;
    private String x; // 경도
    private String y; // 위도

    // Getter & Setter
    public String getPlace_name() { return place_name; }
    public void setPlace_name(String place_name) { this.place_name = place_name; }

    public String getRoad_address_name() { return road_address_name; }
    public void setRoad_address_name(String road_address_name) { this.road_address_name = road_address_name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getX() { return x; }
    public void setX(String x) { this.x = x; }

    public String getY() { return y; }
    public void setY(String y) { this.y = y; }
}