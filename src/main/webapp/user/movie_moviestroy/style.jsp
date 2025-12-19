<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
      /* ----------------------------------------------------------- */
      /* [Movie Story Common & Specific Styles] */
      /* ----------------------------------------------------------- */

      /* [디자인] 전체를 감싸는 박스 (보더 포함) */
      .year-selector-wrap {
        display: flex;
        align-items: center;
        border: 1px solid #ddd; /* 전체 테두리 */
        height: 60px;
        background: #fff;
        padding: 0 10px; /* 화살표와 테두리 사이 간격 */
        margin-bottom: 30px;
      }

      /* Swiper 영역 (가운데 5칸) */
      .swiper.year-swiper {
        flex: 1; /* 남은 공간 다 차지 */
        height: 100%;
        margin: 0 10px; /* 화살표와의 간격 */
        cursor: default;
      }

      .swiper-initialized:not(.swiper-locked) {
        cursor: grab;
      }

      /* 슬라이드(연도) 개별 스타일 */
      .swiper-slide {
        text-align: center;
        line-height: 60px; /* 세로 중앙 정렬 */
        font-size: 16px;
        color: #333;
        cursor: pointer;
        position: relative;
      }

      /* 선택된 연도 스타일 (보라색 밑줄) */
      .swiper-slide-thumb-active {
        font-weight: bold;
        color: #000;
      }
      /* 밑줄을 가상요소로 만들어서 디자인 디테일 살리기 */
      .swiper-slide-thumb-active::after {
        content: "";
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 4px;
        background-color: #6c5ce7; /* 보라색 */
      }

      /* 화살표 커스텀 */
      .nav-btn {
        width: 30px;
        height: 30px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #999;
        cursor: pointer;
        z-index: 10;
        font-weight: bold;
        font-family: monospace; /* 화살표 모양 유지를 위해 */
      }
      /* Swiper 내장 클래스 활용하지만 위치는 flex로 제어 */
      .swiper-button-disabled {
        opacity: 0.3;
        cursor: default;
      }

      /* ----------------------------------------------------------- */
      /* [Timeline List Styles] */
      /* ----------------------------------------------------------- */
      .timeline-list {
        position: relative;
        /* [스크롤 적용] 높이를 고정하고 넘치면 스크롤 발생 */
        height: 700px;
        overflow-y: auto;
        padding-top: 30px; /* 뱃지가 잘리지 않도록 여백 추가 */
        padding-bottom: 50px;
        padding-right: 10px; /* 스크롤바 공간 확보 */
        border-top: 1px solid #eee;
        border-bottom: 1px solid #eee; /* 하단 마감 선 */
      }

      /* 스크롤바 커스텀 (Webkit) */
      .timeline-list::-webkit-scrollbar {
        width: 8px;
      }

      .timeline-list::-webkit-scrollbar-thumb {
        background-color: #ccc;
        border-radius: 4px;
      }

      .timeline-list::-webkit-scrollbar-track {
        background-color: #f1f1f1;
      }

      .timeline-item {
        position: relative;
        padding-top: 40px;
        padding-bottom: 20px;
        border-top: 2px solid #5bb0ba; /* 이미지의 청록색 선 */
        margin-bottom: 20px;
      }

      /* 날짜 뱃지 */
      .date-badge {
        position: absolute;
        top: -15px;
        left: 50%;
        transform: translateX(-50%);
        background-color: #5bb0ba;
        color: white;
        padding: 5px 20px;
        border-radius: 20px;
        font-size: 14px;
        font-weight: bold;
        z-index: 1;
      }

      .movie-content {
        display: flex;
        gap: 20px;
        align-items: flex-start;
        padding: 0 20px;
      }

      .poster {
        width: 100px;
        height: 140px;
        background: #eee;
        border-radius: 4px;
        object-fit: cover;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
      }

      .info {
        flex: 1;
      }

      .info h3 {
        margin: 0 0 5px 0;
        font-size: 18px;
        color: #333;
      }

      .info p {
        margin: 5px 0;
        color: #666;
        font-size: 14px;
      }

      .tag {
        display: inline-block;
        border: 1px solid #999;
        border-radius: 15px;
        padding: 2px 10px;
        font-size: 12px;
        color: #666;
        margin-bottom: 8px;
      }

      /* 탭 메뉴 스타일 */
      .tab-menu {
        display: flex;
        border: 1px solid #ddd;
        border-bottom: none;
        margin-bottom: 30px;
      }

      .tab-item {
        flex: 1;
        text-align: center;
        padding: 15px 0;
        font-size: 15px;
        color: #666;
        background-color: #fff;
        border-right: 1px solid #ddd;
        cursor: pointer;
        transition: all 0.2s;
      }

      .tab-item:last-child {
        border-right: none;
      }

      .tab-item:hover {
        background-color: #f9f9f9;
      }

      .tab-item.active {
        background-color: #503396;
        color: #fff;
        font-weight: 700;
      }

      /* ----------------------------------------------------------- */
      /* [Review List Specific Styles] */
      /* ----------------------------------------------------------- */

      /* Scrollable Container */
      .review-list-container {
        /* 5개 이상이면 스크롤 생기도록 높이 제한 */
        max-height: 650px;
        overflow-y: auto;
        padding-right: 10px; /* 스크롤바 공간 */
      }

      /* Scrollbar Customization */
      .review-list-container::-webkit-scrollbar {
        width: 8px;
      }

      .review-list-container::-webkit-scrollbar-thumb {
        background-color: #ccc;
        border-radius: 4px;
      }

      .review-list-container::-webkit-scrollbar-track {
        background-color: #f1f1f1;
      }

      .review-item {
        display: flex;
        gap: 20px;
        margin-bottom: 20px;
        padding-bottom: 20px;
        border-bottom: 1px solid #eee;
        align-items: flex-start;
      }

      /* Left: Reviewer Info */
      .reviewer-info {
        width: 110px;
        text-align: center;
        flex-shrink: 0;
      }

      .avatar {
        width: 50px;
        height: 50px;
        background-color: #eee;
        border-radius: 50%;
        margin: 0 auto 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
      }

      .avatar i {
        font-size: 24px;
        color: #555;
      }

      .username {
        font-size: 13px;
        color: #333;
        font-weight: 500;
        word-break: break-all;
      }

      /* Right: Review Content Wrapper */
      .review-content-wrap {
        flex: 1;
        background-color: #fff;
      }

      .review-box {
        display: flex;
        justify-content: space-between;
        align-items: flex-start; /* 텍스트 많을 때 상단 정렬 */
        position: relative; /* 메뉴 드롭다운 위치 기준 */
        margin-bottom: 5px;
      }

      .review-left {
        display: flex;
        flex-wrap: wrap; /* 내용 길면 줄바꿈 */
        align-items: baseline;
        gap: 10px;
        flex: 1;
        margin-right: 10px;
      }

      .review-badge {
        font-size: 12px;
        color: #666;
      }

      .review-score {
        font-size: 18px;
        font-weight: bold;
        color: #333;
      }

      .review-separator {
        display: inline-block;
        width: 1px;
        height: 12px;
        background: #ddd;
        margin: 0 2px;
      }

      .review-text-group {
        display: flex;
        flex-direction: column;
        gap: 5px;
        flex: 1;
      }

      .movie-title {
        font-size: 15px;
        font-weight: bold;
        color: #333;
      }

      .review-text {
        font-size: 14px;
        color: #666;
        line-height: 1.5;
        word-break: break-all;
      }
      
      .review-meta {
      	font-size: 12px;
      	color: #999;
      	margin-top: 5px;
      }

      /* Menu Button & Dropdown */
      .menu-btn {
        cursor: pointer;
        padding: 5px;
        color: #999;
      }
      
      .menu-btn:hover {
      	color: #333;
      }

      .menu-dropdown {
        display: none; /* 기본 숨김 */
        position: absolute;
        top: 25px;
        right: 0;
        width: 80px;
        background: #fff;
        border: 1px solid #ddd;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        z-index: 10;
        border-radius: 4px;
      }

      .menu-dropdown.show {
        display: block;
      }

      .menu-dropdown-item {
        padding: 8px 10px;
        font-size: 13px;
        color: #333;
        cursor: pointer;
        text-align: center;
        border-bottom: 1px solid #eee;
      }

      .menu-dropdown-item:last-child {
        border-bottom: none;
      }

      .menu-dropdown-item:hover {
        background-color: #f5f5f5;
      }
      
      .menu-dropdown-item.delete {
      	color: #e74c3c;
      }

      /* Inline Edit Styles */
      .review-score-input {
      	width: 60px;
      	padding: 3px;
      	font-size: 14px;
      }
      
      .review-edit-input {
      	width: 100%;
      	height: 60px;
      	padding: 5px;
      	font-size: 14px;
      	margin-top: 5px;
      	resize: none;
      	border: 1px solid #ddd;
      	border-radius: 4px;
      }
      
      .edit-buttons {
      	margin-top: 5px;
      	display: flex;
      	gap: 5px;
      }
      
      .btn-save, .btn-cancel {
      	padding: 5px 10px;
      	font-size: 12px;
      	cursor: pointer;
      	border: none;
      	border-radius: 3px;
      }
      
      .btn-save {
      	background: #503396;
      	color: #fff;
      }
      
      .btn-cancel {
      	background: #eee;
      	color: #333;
      }
</style>
