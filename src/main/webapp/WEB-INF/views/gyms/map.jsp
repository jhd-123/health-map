<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>📍 내 위치 & 주변 헬스장 검색</title>
  <style>
    body { font-family: 'Arial', sans-serif; margin: 0; padding: 0; }
    #search-container {
      padding: 10px;
      background: #f5f5f5;
      border-bottom: 1px solid #ddd;
    }
    #search-input {
      width: 200px;
      padding: 5px;
      font-size: 14px;
    }
    #search-btn {
      padding: 5px 10px;
      font-size: 14px;
      cursor: pointer;
    }
    #map { width: 100%; height: 500px; }
  </style>
</head>
<body>

<div id="search-container">
  <input type="text" id="search-input" placeholder="검색어 입력 (예: 헬스장)" />
  <button id="search-btn">검색</button>
</div>

<div id="map"></div>

<!-- ✅ Kakao Maps SDK: 반드시 동기 로딩으로! -->
<script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=709f8eb34b8860e51c2ed050bf8bc0f1&libraries=services"></script>

<script>
  window.onload = function () {
    console.log("✅ Kakao Maps SDK 로드 완료");

    let map, userLat, userLon;

    if (!navigator.geolocation) {
      alert("❌ 위치 정보를 지원하지 않습니다.");
      return;
    }

    navigator.geolocation.getCurrentPosition(function(pos) {
      userLat = pos.coords.latitude;
      userLon = pos.coords.longitude;
      console.log("📍 내 현재 위치:", userLat, userLon);

      const userPosition = new kakao.maps.LatLng(userLat, userLon);

      map = new kakao.maps.Map(document.getElementById('map'), {
        center: userPosition,
        level: 4
      });

      new kakao.maps.Marker({
        map: map,
        position: userPosition,
        image: new kakao.maps.MarkerImage(
          "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/red_b.png",
          new kakao.maps.Size(40, 42),
          { offset: new kakao.maps.Point(13, 42) }
        )
      });

      searchPlaces("헬스장");
    }, function(error) {
      console.error("❌ 위치 정보 실패:", error);
      alert("위치 정보를 가져올 수 없습니다.");
    });

    document.getElementById("search-btn").addEventListener("click", function() {
      const keyword = document.getElementById("search-input").value.trim();
      if (!keyword) {
        alert("검색어를 입력해주세요.");
        return;
      }
      searchPlaces(keyword);
    });

    function searchPlaces(query) {
      const url = "/api/kakao/gyms?lat=" + encodeURIComponent(userLat) + "&lon=" + encodeURIComponent(userLon);
      console.log("🚀 API 호출 (기본 lat/lon 사용) → 쿼리:", query);

      fetch(url)
        .then(res => {
          if (!res.ok) throw new Error("서버 오류: " + res.status);
          return res.json();
        })
        .then(data => {
          console.log("📦 응답 데이터:", data);
          if (!Array.isArray(data)) throw new Error("데이터가 배열이 아닙니다.");

          map.setCenter(new kakao.maps.LatLng(userLat, userLon));

          data.forEach(place => {
            const marker = new kakao.maps.Marker({
              map: map,
              position: new kakao.maps.LatLng(place.y, place.x),
              image: new kakao.maps.MarkerImage(
                "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/blue_b.png",
                new kakao.maps.Size(40, 42),
                { offset: new kakao.maps.Point(13, 42) }
              )
            });

            const infowindow = new kakao.maps.InfoWindow({
              content:
                '<div style="padding:6px 10px; font-size:14px;">' +
                '<strong>' + place.place_name + '</strong><br/>' +
                (place.road_address_name || '') +
                '</div>',
              removable: true
            });

            kakao.maps.event.addListener(marker, 'click', function() {
              infowindow.open(map, marker);
            });
          });
        })
        .catch(err => {
          console.error("❌ API 오류:", err);
          alert("장소 데이터를 불러올 수 없습니다.");
        });
    }
  };
</script>

</body>
</html>
