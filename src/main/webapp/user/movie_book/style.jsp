<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
      /* 
         [Reset 및 공통 스타일 제외] 
         * { margin:0; padding:0; } 등은 megabox.min.css와 충돌 방지를 위해 제거함.
      */

      /* 헤더 영역 보정 (ID 선택자 사용) */
      #header {
        border-bottom: 1px solid #ddd;
        padding-bottom: 10px;
      }

      /* 브레드크럼 (필수 복구) */
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
        list-style: none; /* megabox 공통 ul 스타일과 충돌 방지 */
        gap: 8px;
        margin: 0; /* 기본 마진 제거 */
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

      /* 탭 */
      .tabs {
        display: inline-flex;
        border: 1px solid #ddd;
        margin-bottom: 20px;
        padding: 0; /* ul reset */
      }

      .tab-item {
        list-style: none;
        padding: 10px 30px;
        font-size: 14px;
        cursor: pointer;
        background-color: white;
        border-right: 1px solid #ddd;
        color: #666;
      }

      .tab-item:last-child {
        border-right: none;
      }

      .tab-item.active {
        background-color: #555;
        color: white;
        font-weight: 600;
      }

      /* 검색 영역 */
      .search-box {
        background-color: #f8f8f8;
        padding: 20px;
        margin-bottom: 30px;
      }

      .search-row {
        display: flex;
        align-items: center;
        gap: 15px;
      }

      .search-label {
        font-size: 14px;
        color: #333;
        font-weight: 600;
        min-width: 60px;
      }

      .radio-group {
        display: flex;
        gap: 20px;
      }

      .radio-item {
        display: flex;
        align-items: center;
        gap: 5px;
        cursor: pointer;
      }

      .radio-item label {
        cursor: pointer;
        font-size: 13px;
      }

      /* 예매내역 고정 텍스트 표시 */
      .date-display {
        padding: 8px 8px;
        border: 1px solid #ddd;
        font-size: 13px;
        font-family: "Noto Sans KR", sans-serif;
        background-color: white;
        width: 150px;
        height: 35px;
        display: inline-block;
        color: #333;
        box-sizing: border-box;
        vertical-align: middle;
        line-height: 17px;
      }

      .date-select {
        padding: 5px 4px;
        border: 1px solid #ddd;
        font-size: 13px;
        font-family: "Noto Sans KR", sans-serif;
        background-color: white;
        cursor: pointer;
        width: 150px;
        height: 35px;
        color: #333;
        box-sizing: border-box;
        vertical-align: middle;
        line-height: 17px;
      }

      .btn-search {
        padding: 8px 20px;
        background-color: #555;
        color: white;
        border: none;
        cursor: pointer;
        font-size: 13px;
      }

      .btn-search:hover {
        background-color: #333;
      }

      .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #999;
        font-size: 14px;
      }

      /* 정보 박스 */
      .info-box {
        border: 1px solid #ddd;
        margin-top: 30px;
      }

      .info-box-header {
        background-color: #f8f8f8;
        padding: 12px 15px;
        font-size: 15px;
        font-weight: 600;
        color: #333;
        border-bottom: 1px solid #ddd;
      }

      .info-table {
        width: 100%;
        border-collapse: collapse;
      }

      .info-table th,
      .info-table td {
        border-bottom: 1px solid #ddd;
        padding: 12px 15px;
        font-size: 13px;
        text-align: center;
      }

      .info-table th {
        background-color: #f8f8f8;
        color: #333;
        font-weight: 600;
      }

      .guide-section {
        margin-top: 30px;
        border: 1px solid #ddd;
      }

      .guide-header {
        background-color: #f8f8f8;
        padding: 12px 15px;
        font-size: 14px;
        font-weight: 600;
        color: #333;
        cursor: pointer;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
      
      .guide-content {
          padding: 20px;
          display: none;
      }
      .guide-content.show {
          display: block;
      }
      .guide-content ul {
          list-style: disc;
          padding-left: 20px;
      }
    </style>
