<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
      /* 
         [Reset 및 공통 스타일 제외] 
      */

      /* 헤더 영역 보정 */
      #header {
        border-bottom: 1px solid #ddd;
        padding-bottom: 10px;
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
        margin: 0;
        padding: 0;
      }

      .breadcrumb-list li {
        display: flex;
        align-items: center;
        gap: 8px;
      }

      .breadcrumb-list a {
        color: #888;
        text-decoration: none;
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

      .main-content {
        flex: 1;
      }

      /* 마이페이지 메인 전용 스타일 */
      .profile-banner {
        background-color: #3e2675;
        color: white;
        padding: 40px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        gap: 30px;
        margin-bottom: 50px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
      }

      .profile-avatar {
        width: 100px;
        height: 100px;
        background-color: #ddd;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        border: 3px solid rgba(255, 255, 255, 0.3);
      }
      
      .profile-avatar i {
        font-size: 60px;
        color: #fff;
      }

      .profile-info h2 {
        font-size: 28px;
        font-weight: 700;
        margin-bottom: 10px;
        line-height: 1.3;
      }

      .profile-links {
        font-size: 13px;
        color: rgba(255, 255, 255, 0.7);
      }
      
      .profile-links a {
          margin-right: 10px;
          color: inherit;
      }
      .profile-links a:hover {
          color: white;
          text-decoration: underline;
      }

      .section-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 2px solid #ddd;
        padding-bottom: 15px;
        margin-bottom: 20px;
        margin-top: 40px; /* 섹션 간격 */
      }

      .section-title {
        font-size: 20px;
        font-weight: 700;
        color: #3e2675;
      }
      .more-link {
          font-size: 13px;
          color: #666;
      }

      /* Story Counts */
      .story-counts {
        display: flex;
        justify-content: center;
        gap: 80px;
        margin-bottom: 40px;
        background-color: #fff;
        padding: 20px;
        border: 1px solid #eee;
        border-radius: 10px;
      }

      .count-item { text-align: center; }
      .count-num {
        display: block;
        font-size: 32px;
        font-weight: 700;
        color: #3e2675;
      }
      .count-label { font-size: 14px; color: #666; }

      .review-list {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
      }
      .review-card {
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 20px;
        display: flex;
        gap: 15px;
        background-color: #fff;
      }
      
      .review-content { flex: 1; }
      .review-movie-title { font-weight: 700; margin-bottom: 5px; }
      .review-rating { color: #ffcc00; font-size: 14px; margin-bottom: 5px; }
      .review-text { 
           font-size: 13px; color: #666; line-height: 1.5;
           display: -webkit-box;
           -webkit-line-clamp: 3;
           -webkit-box-orient: vertical;
           overflow: hidden;
      }
      
      .booking-empty {
          text-align: center;
          padding: 50px 0;
          color: #666;
          font-size: 14px;
      }
    </style>
