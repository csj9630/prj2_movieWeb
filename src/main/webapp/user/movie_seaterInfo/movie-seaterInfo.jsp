<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ include file="../../fragments/siteProperty.jsp"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>2GV 극장 정보</title>
    <jsp:include page="../../fragments/style_css.jsp" />

    <style>
      /* 초기화 및 기본 스타일 */
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      /* Sticky Footer 패턴을 위한 html, body 설정 */
      html,
      body {
        height: 100%;
      }

      body {
        font-family: "Noto Sans KR", sans-serif;
        color: #333;
        background-color: #fdfdfd;
        display: flex;
        flex-direction: column;
      }

      /* main이 남은 공간을 모두 차지하도록 설정 */
      main {
        flex: 1;
      }

      a {
        text-decoration: none;
        color: inherit;
      }
      ul {
        list-style: none;
      }

      /* 유틸리티 */
      .seater-container {
        width: 100%;
        max-width: 980px;
        margin: 0 auto;
        padding: 0 20px;
      }

      /* 1. 헤더 영역 */
      header {
        border-bottom: 1px solid #ddd;
        padding-bottom: 10px;
      }

      .top-utils {
        display: flex;
        justify-content: flex-end;
        gap: 15px;
        padding: 10px 0;
        font-size: 13px;
        color: #666;
      }

      .main-nav {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 15px 0;
      }

      .nav-left i,
      .nav-right i {
        font-size: 24px;
        margin: 0 10px;
        cursor: pointer;
        color: #333;
      }

      .logo {
        text-align: center;
      }

      .logo-box {
        background-color: #3e2675;
        color: white;
        padding: 5px 15px;
        font-weight: 900;
        font-size: 24px;
        display: inline-block;
      }
      .logo-sub {
        display: block;
        font-size: 12px;
        color: #3e2675;
        font-weight: 700;
        letter-spacing: 1px;
        margin-top: 2px;
      }

      .nav-menu {
        font-size: 18px;
        font-weight: 700;
        margin: 0 15px;
      }

      /* 2. 브레드크럼 (경로) */
      .seater-breadcrumb {
        background-color: #f8f8f8;
        padding: 10px 0;
        font-size: 12px;
        color: #888;
        border-bottom: 1px solid #eee;
      }

      .seater-breadcrumb-list {
        display: flex;
        align-items: center;
        justify-content: flex-start;
        list-style: none;
        gap: 8px;
      }

      .seater-breadcrumb-list li {
        display: flex;
        align-items: center;
        gap: 8px;
      }

      .seater-breadcrumb-list a {
        color: #888;
        transition: color 0.2s;
      }

      .seater-breadcrumb-list a:hover {
        color: #3e2675;
        text-decoration: underline;
      }

      .seater-breadcrumb-list .current {
        color: #333;
        font-weight: 500;
      }

      .seater-breadcrumb-separator {
        color: #ccc;
      }

      /* 3. 탭 메뉴 */
      .seater-tabs {
        display: flex;
        margin-top: 30px;
        justify-content: center;
      }

      .seater-tab-item {
        flex: 1;
        text-align: center;
        padding: 15px 0;
        border: 1px solid #ddd;
        border-bottom: 1px solid #3e2675;
        cursor: pointer;
        font-weight: 500;
        color: #777;
      }

      .seater-tab-item.active {
        border: 1px solid #3e2675;
        border-bottom: 1px solid #fff;
        color: #3e2675;
        font-weight: 700;
      }

      /* 4. 메인 컨텐츠 박스 */
      .content-wrap {
        border: 2px solid #9ea9e8;
        padding: 40px;
        margin-top: 20px;
        margin-bottom: 0;
      }

      .headline {
        font-size: 18px;
        text-align: center;
        margin-bottom: 40px;
        color: #333;
        line-height: 1.4;
        padding-bottom: 20px;
        border-bottom: 1px solid #eee;
      }

      .section-title {
        color: #3e2675;
        font-size: 16px;
        font-weight: 700;
        margin-bottom: 10px;
      }

      .sub-title {
        font-size: 14px;
        color: #333;
        margin-bottom: 15px;
        font-weight: 500;
      }

      /* 시설 아이콘 */
      .facility-icons {
        margin-bottom: 30px;
      }

      .icon-circle {
        width: 60px;
        height: 60px;
        border: 1px solid #ddd;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 5px;
      }

      .icon-circle i {
        font-size: 24px;
        color: #777;
      }

      .icon-label {
        font-size: 12px;
        color: #666;
        text-align: center;
        width: 60px;
      }

      /* 층별 안내 */
      .floor-guide {
        margin-top: 30px;
      }

      .floor-list li {
        font-size: 13px;
        margin-bottom: 8px;
        color: #555;
        position: relative;
        padding-left: 10px;
      }

      .floor-list li::before {
        content: "•";
        position: absolute;
        left: 0;
        color: #3e2675;
      }

      .floor-num {
        color: #256b9c;
        font-weight: 700;
        margin-right: 5px;
      }

      /* 탭 컨텐츠 숨김 처리 */
      .seater-tab-content {
        display: none;
      }

      .seater-tab-content.active {
        display: block;
      }

      /* 관람료 테이블 스타일 */
      .price-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
        margin-bottom: 30px;
      }

      .price-table th,
      .price-table td {
        border: 1px solid #ddd;
        padding: 12px 15px;
        text-align: center;
        font-size: 14px;
      }

      .price-table th {
        background-color: #3e2675;
        color: white;
        font-weight: 700;
      }

      .price-table td {
        color: #555;
      }

      .price-table tr:nth-child(even) {
        background-color: #f9f9f9;
      }

      .price-note {
        font-size: 13px;
        color: #666;
        line-height: 1.8;
        margin-top: 10px;
      }

      .price-note li {
        position: relative;
        padding-left: 15px;
        margin-bottom: 5px;
      }

      .price-note li::before {
        content: "※";
        position: absolute;
        left: 0;
        color: #3e2675;
      }

      /* Footer margin 오버라이드 - 다른 페이지와 동일하게 맞춤 */
      .footer-bottom {
        margin-top: 0;
      }
    </style>
  </head>
  <body>
    <!-- 헤더 -->
    <div id="header">
      <jsp:include page="../../fragments/header.jsp" />
    </div>

    <nav class="seater-breadcrumb" aria-label="breadcrumb">
      <div class="seater-container">
        <ol class="seater-breadcrumb-list">
          <li>
            <a href="index.html" title="홈으로 이동">
              <i class="fa-solid fa-house"></i>
            </a>
            <span class="seater-breadcrumb-separator">></span>
          </li>
          <li>
            <a href="theater.html">극장</a>
            <span class="seater-breadcrumb-separator">></span>
          </li>
          <li>
            <a href="theater-list.html">전체극장</a>
            <span class="seater-breadcrumb-separator">></span>
          </li>
          <li>
            <span class="current">극장정보</span>
          </li>
        </ol>
      </div>
    </nav>

    <main class="seater-container">
      <div class="seater-tabs">
        <div class="seater-tab-item active" data-tab="theater">극장정보</div>
        <div class="seater-tab-item" data-tab="transport">교통안내</div>
        <div class="seater-tab-item" data-tab="price">관람료</div>
      </div>

      <div class="content-wrap">
        <!-- 극장정보 탭 컨텐츠 -->
        <div id="theater-content" class="seater-tab-content active">
          <h2 class="headline">
            선릉역 1번 출구와 7분 거리의 편리한 접근성! 전관 리클라이너 좌석에서
            누리는 최상의 영화 경험!
          </h2>

          <div class="section-title">시설안내</div>

          <div class="sub-title">보유시설</div>
          <div class="facility-icons">
            <div style="display: inline-block">
              <div class="icon-circle">
                <i class="fa-solid fa-wheelchair"></i>
              </div>
              <div class="icon-label">장애인석</div>
            </div>
          </div>

          <div class="sub-title">층별안내</div>
          <ul class="floor-list">
            <li>
              <span class="floor-num">8층 :</span> 매표소, 매점, 에스컬레이터,
              엘리베이터, 남자 · 여자 화장실, 비상계단 3
            </li>
            <li>
              <span class="floor-num">9층 :</span> 1관, 2관, 남자 · 여자 화장실,
              엘리베이터, 비상계단 3
            </li>
            <li>
              <span class="floor-num">10층 :</span> 3관, 4관, 엘리베이터 2, 남자
              · 여자 화장실, 비상계단 3
            </li>
            <li>
              <span class="floor-num">11층 :</span> 5관, 6관, 7관, 엘리베이터 2,
              남자 · 여자 화장실, 비상계단 3
            </li>
          </ul>
        </div>

        <!-- 교통안내 탭 컨텐츠 -->
        <div id="transport-content" class="seater-tab-content">
          <h2 class="headline">교통안내</h2>

          <!-- 약도 섹션 -->
          <div class="section-title">약도</div>
          <div class="facility-icons">
            <div style="display: inline-block">
              <div class="icon-circle">
                <i class="fa-solid fa-map-location-dot"></i>
              </div>
              <div class="icon-label">위치</div>
            </div>
          </div>
          <div class="sub-title">
            도봉역수소 · 서울특별시 서초구 서초대로 77길 3 (서초동) 아라타워 8층
          </div>
          <div style="margin-bottom: 40px">
            <!-- 지도연결 주소 추가 -->
            <a
              href="#"
              style="
                display: inline-block;
                background-color: #3e2675;
                color: white;
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 4px;
              "
            >
              길찾기
            </a>
          </div>

          <!-- 주차 섹션 -->
          <div class="section-title">주차</div>
          <div class="facility-icons">
            <div style="display: inline-block">
              <div class="icon-circle">
                <i class="fa-solid fa-square-parking"></i>
              </div>
              <div class="icon-label">주차</div>
            </div>
          </div>

          <div class="sub-title">주차안내</div>
          <ul class="floor-list" style="margin-bottom: 20px">
            <li>아라타워 건물 P4 지하 3층 ~ 지하 6층 주차장 이용</li>
          </ul>

          <div class="sub-title">주차혜택</div>
          <ul class="floor-list" style="margin-bottom: 20px">
            <li>8층 주차정산기에서 티켓 하단 바코드 인증 후 할인 등록</li>
            <li>
              영화 관람 시 3시간 30분 : 3천원 (이후 10분당 1천원 / 카드결제만
              가능)
            </li>
          </ul>

          <div class="sub-title">주차요금</div>
          <ul class="floor-list" style="margin-bottom: 40px">
            <li>알짜시간 가족으로, 알짜 후 20분 이후부터 정산 가능</li>
            <li>강을 내 타 매장과 중복 할인 충복 적용 불가</li>
            <li>
              주차 공간이 협소하므니 가급적이면 대중교통을 이용 바랍니다.
              (지하철 2호선 강남역 출구 9번 출구)
            </li>
          </ul>

          <!-- 대중교통 섹션 -->
          <div class="section-title">대중교통</div>
          <div class="facility-icons">
            <div style="display: inline-block; margin-right: 20px">
              <div class="icon-circle">
                <i class="fa-solid fa-bus"></i>
              </div>
              <div class="icon-label">버스</div>
            </div>
            <div style="display: inline-block">
              <div class="icon-circle">
                <i class="fa-solid fa-train-subway"></i>
              </div>
              <div class="icon-label">지하철</div>
            </div>
          </div>

          <div class="sub-title">버스</div>
          <ul class="floor-list" style="margin-bottom: 20px">
            <li>
              140번, 144번, 145번, 146번, 360번, 402번, 420번, 440번, 441번,
              452번, 470번, 741번
            </li>
            <li>3412번, 4312번, 서초3번, 서초 09번</li>
            <li>
              9404번, 9408번, 9409번, 9503번, 9711번, 9500번, 9501번, 9510번,
              9800번, 9801번, 9802번, 9901번, M4403번, M7412번
            </li>
          </ul>

          <div class="sub-title">지하철</div>
          <ul class="floor-list">
            <li>
              지하철 2호선, 신분당선 '강남역' → 지하철 9번 출구 직통 연결통로
              이용
            </li>
          </ul>
        </div>

        <!-- 관람료 탭 컨텐츠 -->
        <div id="price-content" class="seater-tab-content">
          <h2 class="headline">2GV 관람료 안내</h2>

          <div class="section-title">2D 일반 관람료</div>
          <table class="price-table">
            <thead>
              <tr>
                <th>구분</th>
                <th>평일</th>
                <th>주말/공휴일</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>일반</td>
                <td>13,000원</td>
                <td>15,000원</td>
              </tr>
              <tr>
                <td>청소년</td>
                <td>11,000원</td>
                <td>13,000원</td>
              </tr>
              <tr>
                <td>경로/장애인</td>
                <td>9,000원</td>
                <td>9,000원</td>
              </tr>
            </tbody>
          </table>
          <ul class="price-note">
            <li>상영 시간대, 영화등급에 따라 관람료가 상이할 수 있습니다.</li>
            <li>경로 우대는 만 65세 이상 고객님께 적용됩니다.</li>
            <li>
              장애인 우대는 장애인복지카드 또는 증명서 지참 시 적용됩니다.
            </li>
          </ul>
        </div>
      </div>
    </main>

    <!-- 푸터 -->
    <div id="footer"><%@ include file="../../fragments/footer.jsp" %></div>

    <script>
      // 탭 전환 기능
      const tabItems = document.querySelectorAll(".seater-tab-item");
      const tabContents = document.querySelectorAll(".seater-tab-content");

      tabItems.forEach((tab) => {
        tab.addEventListener("click", function () {
          // 모든 탭과 컨텐츠에서 active 클래스 제거
          tabItems.forEach((t) => t.classList.remove("active"));
          tabContents.forEach((c) => c.classList.remove("active"));

          // 클릭한 탭에 active 클래스 추가
          this.classList.add("active");

          // 해당하는 컨텐츠 표시
          const tabName = this.getAttribute("data-tab");
          document.getElementById(tabName + "-content").classList.add("active");
        });
      });
    </script>
  </body>
</html>
