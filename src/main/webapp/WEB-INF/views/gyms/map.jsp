<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>📍 내 위치 & 주변 헬스장</title>

  <style>
    #map {
      width: 100%;
      height: 500px;
    }
  </style>

  <!-- ✅ Kakao Maps SDK (JS App Key 사용) -->
  <script src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=2ef79939131e63ad55094a3a5256ea37&autoload=false"></script>
</head>
<body>

  <h2 style="padding:10px;">📍 내 위치 & 주변 헬스장</h2>
  <div id="map"></div>

<script>
kakao.maps.load(() => {
  console.log("✅ Kakao Maps SDK 로드됨");

  // ✅ 고정 위치 (예: 강남역)
  const lat = 37.4979;
  const lon = 127.0276;
  console.log("📌 고정 위치 사용:", lat, lon);

  const locPosition = new kakao.maps.LatLng(lat, lon);
  const map = new kakao.maps.Map(document.getElementById('map'), {
    center: locPosition,
    level: 3
  });

  new kakao.maps.Marker({
    map: map,
    position: locPosition
  });

  const url = "/api/kakao/gyms?lat=" + encodeURIComponent(lat) + "&lon=" + encodeURIComponent(lon);
  console.log("🚀 API 호출 URL:", url);

  fetch(url)
    .then(res => {
      if (!res.ok) throw new Error("서버 오류: " + res.status);
      return res.json();
    })
    .then(data => {
      console.log("✅ 헬스장 개수:", data.length);

      data.forEach(place => {
        const marker = new kakao.maps.Marker({
          map: map,
          position: new kakao.maps.LatLng(place.y, place.x)
        });

        kakao.maps.event.addListener(marker, 'click', () => {
          const infowindow = new kakao.maps.InfoWindow({
            content: `<div style="padding:5px;">${place.place_name}</div>`
          });
          infowindow.open(map, marker);
        });
      });
    })
    .catch(err => {
      console.error("💥 헬스장 fetch 실패:", err);
    });
});
</script>

</body>
</html>
