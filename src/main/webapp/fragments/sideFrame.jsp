<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<style>
  /* 초기화 및 기본 스타일 */
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }

  body {
    font-family: "Noto Sans KR", sans-serif;
    color: #333;
    background-color: #fdfdfd;
  }

  a {
    text-decoration: none;
    color: inherit;
  }

  ul {
    list-style: none;
  }

  /* 유틸리티 */
  .container {
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
  }

  /* 헤더 영역 */
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

  /* 브레드크럼 */
  .breadcrumb {
    background-color: #f8f8f8;
    padding: 10px 0;
    font-size: 12px;
    color: #888;
    border-bottom: 1px solid #eee;
  }

  .breadcrumb-list {
    display: flex;
    align-items: center;
    justify-content: flex-start;
    list-style: none;
    gap: 8px;
  }

  .breadcrumb-list li {
    display: flex;
    align-items: center;
    gap: 8px;
  }

  .breadcrumb-list a {
    color: #888;
    transition: color 0.2s;
  }

  .breadcrumb-list a:hover {
    color: #3e2675;
    text-decoration: underline;
  }

  .breadcrumb-list .current {
    color: #333;
    font-weight: 500;
  }

  .breadcrumb-separator {
    color: #ccc;
  }

  /* 페이지 레이아웃 */
  .page-wrap {
    display: flex;
    gap: 30px;
    margin-top: 30px;
    margin-bottom: 50px;
  }

  /* 사이드바 */
  .sidebar {
    width: 200px;
    flex-shrink: 0;
  }

  .sidebar-title {
    background-color: #3e2675;
    color: white;
    padding: 15px;
    font-size: 16px;
    font-weight: 700;
    text-align: center;
    border-radius: 14px 14px 0 0;
  }

  .sidebar-menu {
    border: 1px solid #ddd;
    border-radius: 0 0 14px 14px;
    overflow: hidden;
  }

  .menu-group {
    border-bottom: 1px solid #ddd;
  }

  .menu-group:last-child {
    border-bottom: none;
  }

  .menu-group-title {
    padding: 12px 15px;
    font-size: 14px;
    font-weight: 600;
    color: #333;
    background-color: #f8f8f8;
    border-bottom: 1px solid #ddd;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .menu-group-title:hover {
    background-color: #ececec;
  }

  .menu-group-title.active {
    background-color: #3e2675;
    color: white;
  }

  .menu-item {
    padding: 10px 20px;
    font-size: 13px;
    color: #666;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .menu-item:hover {
    background-color: #f5f5f5;
  }

  .menu-item.active {
    background-color: #3e2675;
    color: white;
    font-weight: 600;
  }

  /* 메뉴 컨텐츠 */
  .menu-content {
    display: none;
  }

  .menu-content.active {
    display: block;
  }

  /* 메인 컨텐츠 */
  .main-content {
    flex: 1;
    /* Swiper가 flex container 안에서 제대로 동작하도록 min-width 설정 */
    min-width: 0;
  }

  .page-title {
    font-size: 24px;
    font-weight: 700;
    color: #333;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 2px solid #3e2675;
  }
</style>

<!-- 사이드바 -->
<%
    String activeMenu = (String) request.getAttribute("activeMenu");
    if (activeMenu == null) activeMenu = "";
%>
<aside class="sidebar">
  <div class="sidebar-title" onclick="location.href='../movie_mypage/mypage_main.jsp'" style="cursor: pointer;">나의 2GV</div>
  <div class="sidebar-menu">
    <div class="menu-group">
      <div class="menu-group-title <%= "booking".equals(activeMenu) ? "active" : "" %>" onclick="location.href='../movie_book/mypageBook1.jsp'">예매/구매내역</div>
    </div>
    <div class="menu-group">
      <div class="menu-group-title <%= "movie-story".equals(activeMenu) ? "active" : "" %>" onclick="location.href='../movie_moviestroy/mypage_movieStory1.jsp'">
        나의 무비스토리
      </div>
    </div>
    <div class="menu-group">
      <div class="menu-group-title">회원정보</div>
      <div class="menu-item <%= "profile".equals(activeMenu) ? "active" : "" %>" onclick="location.href='../movie_mystory_mainpage/mypage_withdraw1.jsp'">개인정보 수정</div>
    </div>
  </div>
</aside>
