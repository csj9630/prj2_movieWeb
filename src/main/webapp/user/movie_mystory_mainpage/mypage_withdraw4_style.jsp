<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
      /* 
         ================================================================
         [mypage_frame.html 스타일 그대로 적용]
         ================================================================
      */
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
        background-color: #3e2675; /* 프레임 원본 색상 유지 */
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

      /* 메인 컨텐츠 */
      .main-content {
        flex: 1;
      }

      .page-title {
        font-size: 24px;
        font-weight: 700;
        color: #333;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 2px solid #3e2675;
      }

      /* 
         ================================================================
         [회원탈퇴 페이지 전용 스타일]
         ================================================================
      */

      .withdraw-guide {
        font-size: 14px;
        color: #333;
        line-height: 1.6;
      }

      .guide-intro {
        margin-bottom: 30px;
        color: #666;
      }

      .guide-section {
        margin-bottom: 30px;
      }

      .guide-section h4 {
        font-size: 16px;
        font-weight: 700;
        margin-bottom: 10px;
        color: #333;
      }

      .guide-section ul {
        list-style: none;
        padding-left: 0;
      }

      .guide-section ul li {
        position: relative;
        padding-left: 10px;
        margin-bottom: 5px;
        color: #666;
        font-size: 13px;
        font-weight: 700;
      }

      .guide-section ul li::before {
        content: "•";
        position: absolute;
        left: 0;
        top: 0;
        color: #999;
      }

      .sub-text {
        font-size: 13px;
        color: #888;
        margin-bottom: 10px;
      }

      /* 비밀번호 입력 섹션 */
      .confirm-section {
        margin-top: 40px;
        border-top: 1px solid #eee;
        padding-top: 30px;
      }

      .confirm-section h4 {
        font-size: 16px;
        font-weight: 700;
        margin-bottom: 20px;
      }

      .password-input-box {
        display: flex;
        align-items: center;
        background-color: #f8f8f8;
        padding: 20px;
        border: 1px solid #ddd;
      }

      .password-input-box label {
        font-weight: 700;
        width: 100px;
        font-size: 14px;
      }

      .password-input-box input {
        flex: 1;
        height: 40px;
        border: 1px solid #ddd;
        padding: 0 10px;
        font-size: 14px;
        outline: none;
      }

      .password-input-box input:focus {
        border-color: #3e2675;
      }

      /* 버튼 그룹 */
      .btn-group {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-top: 40px;
      }

      .btn-group button {
        width: 100px;
        height: 45px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        border: 1px solid #ddd;
      }

      .btn-cancel {
        background-color: white;
        color: #3e2675;
        border-color: #3e2675;
      }

      .btn-withdraw {
        background-color: #ccc;
        color: white;
        border: none;
      }

      /* 모달 스타일 */
      .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 1000;
        justify-content: center;
        align-items: center;
      }

      .modal-container {
        background-color: white;
        width: 400px;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        overflow: hidden;
      }

      .modal-header {
        background-color: #3e2675;
        color: white;
        padding: 15px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: 700;
        font-size: 16px;
      }

      .modal-header i {
        cursor: pointer;
      }

      .modal-body {
        padding: 40px 20px;
        text-align: center;
      }

      .modal-body p {
        font-size: 16px;
        margin-bottom: 30px;
        color: #333;
      }

      .btn-confirm {
        background-color: #3e2675;
        color: white;
        border: none;
        padding: 10px 30px;
        font-size: 14px;
        cursor: pointer;
      }
    </style>
