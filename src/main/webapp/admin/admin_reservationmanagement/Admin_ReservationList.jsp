<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 예매 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* [1. 초기화 & 공통] */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f5f6fa;
            color: #333;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        button { border: none; cursor: pointer; font-family: 'Noto Sans KR', sans-serif; }
        input, select { font-family: 'Noto Sans KR', sans-serif; }

        /* [2. 사이드바] */
        .sidebar {
            width: 260px;
            background-color: #1e1e2d;
            color: #a2a3b7;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            transition: all 0.3s;
        }
        .logo-area {
            height: 80px;
            display: flex; align-items: center; justify-content: center;
            background-color: #1b1b28;
            border-bottom: 1px solid #2d2d3f;
        }
        .logo-area img { height: 45px; object-fit: contain; display: block; }
        .menu-list { padding: 20px 0; flex: 1; overflow-y: auto; }
        .menu-category {
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            color: #5e6278; padding: 10px 25px; margin-top: 15px;
        }
        .menu-category:first-child { margin-top: 0; }
        .menu-link {
            display: flex; align-items: center;
            padding: 12px 25px;
            color: #a2a3b7;
            font-size: 14px; font-weight: 500;
            transition: 0.2s; border-left: 3px solid transparent;
        }
        .menu-link:hover, .menu-link.active {
            background-color: #2b2b40; color: #fff; border-left-color: #503396;
        }
        .menu-icon { width: 25px; font-size: 16px; text-align: center; margin-right: 10px; }
        .sidebar-footer {
            padding: 20px; border-top: 1px solid #2d2d3f;
            display: flex; align-items: center; gap: 12px; background-color: #1e1e2d;
        }
        .admin-avatar {
            width: 40px; height: 40px; background-color: #503396;
            border-radius: 50%; display: flex; justify-content: center; align-items: center;
            color: #fff; font-weight: bold; font-size: 14px;
        }
        .admin-info h4 { font-size: 14px; color: #fff; font-weight: 500; margin-bottom: 2px; }
        .admin-info p { font-size: 12px; color: #727589; }

        /* [3. 메인 컨텐츠] */
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        
        .top-header {
            height: 80px; 
            background-color: #ffffff; 
            border-bottom: 1px solid #e1e1e1;
            display: flex; 
            justify-content: space-between; 
            align-items: center;
            padding: 0 30px; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.02);
        }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; letter-spacing: -0.5px; }
        .header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
        .header-right { display: flex; align-items: center; gap: 20px; margin-left: 20px; }
        .logout-btn {
            padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff;
            border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s;
        }
        .logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }

        /* [4. 본문 컨텐츠] */
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }

        /* 상단 탭 (목록만 활성화) */
        .sub-nav { display: flex; gap: 30px; border-bottom: 1px solid #e1e1e1; margin-bottom: 30px; padding-bottom: 15px; }
        .sub-nav-item { font-size: 16px; font-weight: 700; color: #aaa; cursor: pointer; text-decoration: none; position: relative; padding-bottom: 15px; transition: 0.2s; }
        .sub-nav-item:hover { color: #503396; }
        .sub-nav-item.active { color: #1e1e2d; }
        .sub-nav-item.active::after { content: ''; position: absolute; bottom: -1px; left: 0; width: 100%; height: 3px; background-color: #503396; }

        /* 검색 필터 */
        .filter-card { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); margin-bottom: 25px; display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        .filter-label { font-size: 13px; font-weight: 700; color: #555; margin-right: 5px; }
        .filter-input, .filter-select { height: 45px; border: 1px solid #ddd; border-radius: 6px; padding: 0 15px; font-size: 14px; color: #555; }
        .filter-input-long { flex: 1; min-width: 200px; }
        .filter-btn { height: 45px; padding: 0 30px; background-color: #1e1e2d; color: #fff; border-radius: 6px; font-size: 14px; font-weight: 600; transition: 0.2s; }
        .filter-btn:hover { background-color: #333; }
        .reset-btn { height: 45px; padding: 0 20px; background-color: #fff; color: #555; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; font-weight: 600; transition: 0.2s; }
        .reset-btn:hover { background-color: #f9f9f9; }

        /* 테이블 */
        .table-container { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .total-count { font-size: 14px; color: #555; font-weight: 600; }
        .total-count span { color: #503396; }
        
        table { width: 100%; border-collapse: collapse; font-size: 14px; table-layout: fixed; }
        th { background-color: #f9f9f9; color: #5e6278; font-weight: 600; text-align: center; padding: 15px 10px; border-bottom: 1px solid #eee; }
        td { padding: 15px 10px; border-bottom: 1px solid #f5f5f5; color: #3f4254; text-align: center; vertical-align: middle; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        tbody tr { cursor: pointer; transition: 0.2s; }
        tbody tr:hover { background-color: #f8f9fa; }

        .pagination { display: flex; justify-content: center; margin-top: 30px; gap: 5px; }
        .page-link { width: 35px; height: 35px; display: flex; justify-content: center; align-items: center; border: 1px solid #eee; border-radius: 6px; font-size: 13px; color: #555; transition: 0.2s; }
        .page-link:hover { background-color: #f5f5f5; border-color: #ddd; }
        .page-link.active { background-color: #503396; color: #fff; border-color: #503396; font-weight: 700; }

        /* [--- 상세 모달 스타일 (3단 섹션) ---] */
        .modal-overlay {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.5); z-index: 2000;
            justify-content: center; align-items: center;
        }
        .modal-card {
            background-color: #fff; width: 650px; /* 적당한 너비 */
            border-radius: 15px; overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            animation: slideUp 0.3s ease-out;
            display: flex; flex-direction: column;
            max-height: 90vh; 
        }
        @keyframes slideUp { from { transform: translateY(50px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .modal-header {
            padding: 20px 30px; background-color: #f9f9f9; border-bottom: 1px solid #eee;
            display: flex; justify-content: space-between; align-items: center;
        }
        .modal-title { font-size: 20px; font-weight: 800; color: #1e1e2d; }
        .modal-close { font-size: 24px; color: #aaa; cursor: pointer; }
        .modal-close:hover { color: #333; }

        .modal-body { padding: 30px 40px; overflow-y: auto; }

        /* [상세 섹션 구분] */
        .detail-section { margin-bottom: 35px; }
        .detail-section:last-child { margin-bottom: 0; }
        
        .section-title {
            font-size: 16px; font-weight: 700; color: #503396;
            margin-bottom: 15px; padding-bottom: 8px; border-bottom: 2px solid #f0f0f0;
            display: flex; align-items: center; gap: 8px;
        }

        /* 정보 테이블 */
        .info-table { width: 100%; border-collapse: collapse; }
        .info-table th { 
            width: 140px; text-align: left; padding: 10px 0; 
            color: #888; font-weight: 600; font-size: 14px; 
            border-bottom: 1px solid #f9f9f9;
        }
        .info-table td { 
            text-align: right; padding: 10px 0; 
            color: #333; font-size: 15px; font-weight: 500;
            border-bottom: 1px solid #f9f9f9;
        }
        .info-table tr:last-child th, .info-table tr:last-child td { border-bottom: none; }

        .highlight { color: #503396; font-weight: 700; }
        .discount-price { color: #e74c3c; font-weight: 700; }

        /* [모달 하단 버튼 (수정됨)] */
        .modal-footer {
            padding: 20px 30px; background-color: #f9f9f9; border-top: 1px solid #eee;
            display: flex; 
            justify-content: space-between; /* 양쪽 끝으로 배치 */
            align-items: center;
        }
        .btn-close { padding: 10px 25px; border-radius: 6px; background-color: #fff; border: 1px solid #ddd; color: #555; font-weight: 600; cursor: pointer; transition: 0.2s; }
        .btn-close:hover { background-color: #f0f0f0; }
        
        /* 예매 취소 버튼 */
        .btn-cancel-res { padding: 10px 25px; border-radius: 6px; background-color: #fdedec; border: 1px solid #fadbd8; color: #e74c3c; font-weight: 700; cursor: pointer; transition: 0.2s; }
        .btn-cancel-res:hover { background-color: #fceae9; }

        /* [확인 모달] */
        .confirm-card { background-color: #fff; width: 400px; border-radius: 12px; text-align: center; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); }
        .confirm-icon { font-size: 40px; color: #e74c3c; margin-bottom: 20px; } /* 취소 경고라 빨간색 */
        .confirm-text { font-size: 18px; font-weight: 700; color: #333; margin-bottom: 10px; }
        .confirm-sub { font-size: 14px; color: #888; margin-bottom: 30px; }
        .confirm-actions { display: flex; justify-content: center; gap: 10px; }
        .btn-confirm-yes { padding: 10px 30px; border-radius: 6px; background-color: #e74c3c; color: #fff; border: none; font-weight: 700; cursor: pointer; }
        .btn-confirm-no { padding: 10px 30px; border-radius: 6px; background-color: #fff; border: 1px solid #ddd; color: #555; font-weight: 600; cursor: pointer; }

    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="logo-area"><a href="../admin_dashboard/Admin_Dashboard.jsp"><img src="../../resources/img/2GV_LOGO_empty.png"></a></div>
        <div class="menu-list">
            <div class="menu-category">MAIN</div>
            <ul><li><a href="../admin_dashboard/Admin_Dashboard.jsp" class="menu-link"><i class="fa-solid fa-chart-pie menu-icon"></i><span>메인 페이지</span></a></li></ul>
            <div class="menu-category">RESOURCE</div>
            <ul>
                <li><a href="../admin_usermanagement/Admin_UserManagement.jsp" class="menu-link"><i class="fa-solid fa-users menu-icon"></i><span>회원 관리</span></a></li>
                <li><a href="../admin_theatermanagement/Admin_TheaterManagement.jsp" class="menu-link"><i class="fa-solid fa-couch menu-icon"></i><span>상영관 관리</span></a></li>
                <li><a href="../admin_moviemanagement/Admin_MovieList.jsp" class="menu-link"><i class="fa-solid fa-film menu-icon"></i><span>영화 관리</span></a></li>
            </ul>
            <div class="menu-category">SERVICE</div>
            <ul>
                <li><a href="Admin_ReservationList.jsp" class="menu-link active"><i class="fa-solid fa-ticket menu-icon"></i><span>예매 관리</span></a></li>
                <li><a href="../admin_schedulemanagement/Admin_ScreeningList.jsp" class="menu-link"><i class="fa-solid fa-calendar-days menu-icon"></i><span>상영 스케줄 관리</span></a></li>
            </ul>
            <div class="menu-category">BOARD</div>
            <ul>
                <li><a href="../admin_reviewmanagement/Admin_ReviewList.jsp" class="menu-link"><i class="fa-solid fa-comments menu-icon"></i><span>리뷰 관리</span></a></li>
                <li><a href="../admin_noticemanagement/Admin_NoticeList.jsp" class="menu-link"><i class="fa-solid fa-bullhorn menu-icon"></i><span>공지 사항</span></a></li>
            </ul>
        </div>
        <div class="sidebar-footer"><div class="admin-avatar">AD</div><div class="admin-info"><h4>최고관리자</h4><p>Super Admin</p></div></div>
    </nav>

    <main class="main-content">
        <header class="top-header">
            <div class="header-left-title">
                <h2>예매 관리</h2>
                <p>회원들의 예매 내역을 조회하고 상세 정보를 확인합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/Admin_Login.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            
            <div class="sub-nav">
                <a href="Admin_ReservationList.jsp" class="sub-nav-item active">예매 목록 조회</a>
            </div>

            <div class="filter-card">
                <span class="filter-label">예매자 검색</span>
                <input type="text" class="filter-input filter-input-long" placeholder="예매자 이름을 입력하세요">
                <button class="filter-btn">조회</button>
                <button class="reset-btn"><i class="fa-solid fa-rotate-right"></i></button>
            </div>

            <div class="table-container">
                <div class="table-header">
                    <p class="total-count">총 <span>1,250</span>건의 예매가 검색되었습니다.</p>
                </div>

                <table>
                    <colgroup>
                        <col width="15%"> <col width="12%"> <col width="25%"> <col width="15%"> <col width="18%"> <col width="15%"> </colgroup>
                    <thead>
                        <tr>
                            <th>예매 코드</th>
                            <th>예매자 이름</th>
                            <th>영화 제목</th>
                            <th>상영관 이름</th>
                            <th>상영 날짜</th>
                            <th>예매 날짜</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr onclick="openDetailModal('B20251126001', '홍길동', 'user1234', '범죄도시4', 'M001', '1관 (Laser)', 'F5, F6', '2매', '30,000원', '신용카드', '2025-11-26 14:00', '2025-11-20', '통신사 할인', '2,000원')">
                            <td>B20251126001</td>
                            <td>홍길동</td>
                            <td>범죄도시4</td>
                            <td>1관</td>
                            <td>2025-11-26</td>
                            <td>2025-11-20</td>
                        </tr>
                        <tr onclick="openDetailModal('B20251126002', '김철수', 'hong_gd', '퓨리오사: 매드맥스', 'M002', 'MX관', 'G10', '1매', '15,000원', '네이버페이', '2025-11-26 16:30', '2025-11-21', '없음', '0원')">
                            <td>B20251126002</td>
                            <td>김철수</td>
                            <td>퓨리오사: 매드맥스</td>
                            <td>MX관</td>
                            <td>2025-11-26</td>
                            <td>2025-11-21</td>
                        </tr>
                        <tr onclick="openDetailModal('B20251126003', '이영희', 'test_user', '설계자', 'M003', '2관', 'D4, D5, D6', '3매', '45,000원', '카카오페이', '2025-11-26 19:00', '2025-11-22', '쿠폰 할인', '5,000원')">
                            <td>B20251126003</td>
                            <td>이영희</td>
                            <td>설계자</td>
                            <td>2관</td>
                            <td>2025-11-26</td>
                            <td>2025-11-22</td>
                        </tr>
                        <tr onclick="openDetailModal('B20251126004', '박민수', 'admin_01', '인사이드 아웃 2', 'M004', '4관', 'H1, H2', '2매', '28,000원', '신용카드', '2025-11-27 10:00', '2025-11-23', '조조 할인', '2,000원')">
                            <td>B20251126004</td>
                            <td>박민수</td>
                            <td>인사이드 아웃 2</td>
                            <td>4관</td>
                            <td>2025-11-27</td>
                            <td>2025-11-23</td>
                        </tr>
                        <tr onclick="openDetailModal('B20251126005', '최지우', 'movie_lover', '원더랜드', 'M005', '3관', 'E5', '1매', '14,000원', '계좌이체', '2025-11-27 13:00', '2025-11-24', '없음', '0원')">
                            <td>B20251126005</td>
                            <td>최지우</td>
                            <td>원더랜드</td>
                            <td>3관</td>
                            <td>2025-11-27</td>
                            <td>2025-11-24</td>
                        </tr>
                        <tr onclick="openDetailModal('B20251126006', '정재현', 'popcorn123', '하이재킹', 'M006', '5관', 'A1, A2', '2매', '26,000원', '신용카드', '2025-11-28 15:10', '2025-11-25', '없음', '0원')">
                            <td>B20251126006</td>
                            <td>정재현</td>
                            <td>하이재킹</td>
                            <td>5관</td>
                            <td>2025-11-28</td>
                            <td>2025-11-25</td>
                        </tr>
                        <tr onclick="openDetailModal('B20251126007', '강하늘', 'cinema_king', '탈주', 'M007', '1관', 'K5', '1매', '15,000원', '토스페이', '2025-11-28 16:00', '2025-11-25', '통신사 할인', '1,000원')">
                            <td>B20251126007</td>
                            <td>강하늘</td>
                            <td>탈주</td>
                            <td>1관</td>
                            <td>2025-11-28</td>
                            <td>2025-11-25</td>
                        </tr>
                        <tr onclick="openDetailModal('B20251126008', '송혜교', 'blue_sky', '데드풀과 울버린', 'M008', 'IMAX관', 'L10, L11', '2매', '36,000원', '신용카드', '2025-11-29 10:00', '2025-11-26', '없음', '0원')">
                            <td>B20251126008</td>
                            <td>송혜교</td>
                            <td>데드풀과 울버린</td>
                            <td>IMAX관</td>
                            <td>2025-11-29</td>
                            <td>2025-11-26</td>
                        </tr>
                        <tr onclick="openDetailModal('B20251126009', '이정재', 'star_wars', '파일럿', 'M009', '2관', 'C4', '1매', '14,000원', '휴대폰결제', '2025-11-29 12:30', '2025-11-26', '조조 할인', '1,000원')">
                            <td>B20251126009</td>
                            <td>이정재</td>
                            <td>파일럿</td>
                            <td>2관</td>
                            <td>2025-11-29</td>
                            <td>2025-11-26</td>
                        </tr>
                        <tr onclick="openDetailModal('B20251126010', '마동석', 'bad_guy', '리볼버', 'M010', '3관', 'F7, F8', '2매', '30,000원', '신용카드', '2025-11-30 14:20', '2025-11-26', '없음', '0원')">
                            <td>B20251126010</td>
                            <td>마동석</td>
                            <td>리볼버</td>
                            <td>3관</td>
                            <td>2025-11-30</td>
                            <td>2025-11-26</td>
                        </tr>
                    </tbody>
                </table>

                <div class="pagination">
                    <a href="#" class="page-link active">1</a>
                    <a href="#" class="page-link">2</a>
                    <a href="#" class="page-link">3</a>
                    <a href="#" class="page-link">4</a>
                    <a href="#" class="page-link">5</a>
                </div>
            </div>
        </div>
    </main>

    <div id="detailModal" class="modal-overlay">
        <div class="modal-card">
            <div class="modal-header">
                <span class="modal-title">예매 상세 정보</span>
                <i class="fa-solid fa-xmark modal-close" onclick="closeDetailModal()"></i>
            </div>
            
            <div class="modal-body">
                
                <div class="detail-section">
                    <div class="section-title"><i class="fa-solid fa-film"></i> 예매 상세 정보</div>
                    <table class="info-table">
                        <tr><th>예매 영화 코드</th><td id="m_movieCode"></td></tr>
                        <tr><th>영화 제목</th><td id="m_movieTitle" class="highlight"></td></tr>
                        <tr><th>상영관</th><td id="m_theater"></td></tr>
                        <tr><th>좌석 번호</th><td id="m_seats"></td></tr>
                        <tr><th>총 구매 티켓 수</th><td id="m_ticketCount"></td></tr>
                    </table>
                </div>

                <div class="detail-section">
                    <div class="section-title"><i class="fa-solid fa-user"></i> 예매자 상세 정보</div>
                    <table class="info-table">
                        <tr><th>사용자 코드(ID)</th><td id="m_userId"></td></tr>
                        <tr><th>예매자명</th><td id="m_userName"></td></tr>
                        <tr><th>총 결제 금액</th><td id="m_payAmount" class="highlight"></td></tr>
                        <tr><th>결제 수단</th><td id="m_payMethod"></td></tr>
                        <tr><th>예매 일시</th><td id="m_bookDate"></td></tr>
                    </table>
                </div>

                <div class="detail-section">
                    <div class="section-title"><i class="fa-solid fa-tags"></i> 할인 혜택</div>
                    <table class="info-table">
                        <tr><th>할인 수단</th><td id="m_discountType"></td></tr>
                        <tr><th>총 할인 금액</th><td id="m_discountAmount" class="discount-price"></td></tr>
                    </table>
                </div>

            </div>

            <div class="modal-footer">
                <button class="btn-cancel-res" onclick="openCancelConfirm()">예매 취소</button>
                <button class="btn-close" onclick="closeDetailModal()">닫기</button>
            </div>
        </div>
    </div>

    <div id="confirmModal" class="modal-overlay" style="z-index: 2100;">
        <div class="confirm-card">
            <div class="confirm-icon"><i class="fa-solid fa-triangle-exclamation"></i></div>
            <div id="confirmText" class="confirm-text"></div> <div class="confirm-sub">취소된 내역은 복구할 수 없습니다.</div>
            <div class="confirm-actions">
                <button class="btn-confirm-no" onclick="closeConfirmModal()">아니오</button>
                <button class="btn-confirm-yes" onclick="executeCancel()">예, 취소합니다</button>
            </div>
        </div>
    </div>

    <script>
        // 현재 선택된 예매자 이름 저장용 변수
        let currentUserName = '';

        // 상세 모달 열기
        function openDetailModal(bookCode, userName, userId, movieTitle, movieCode, theater, seats, ticketCount, payAmount, payMethod, bookDate, bookDateReal, discountType, discountAmount) {
            
            currentUserName = userName; // 이름 저장 (취소 모달용)

            document.getElementById('m_movieCode').innerText = movieCode;
            document.getElementById('m_movieTitle').innerText = movieTitle;
            document.getElementById('m_theater').innerText = theater;
            document.getElementById('m_seats').innerText = seats;
            document.getElementById('m_ticketCount').innerText = ticketCount;
            document.getElementById('m_userId').innerText = userId;
            document.getElementById('m_userName').innerText = userName;
            document.getElementById('m_payAmount').innerText = payAmount;
            document.getElementById('m_payMethod').innerText = payMethod;
            document.getElementById('m_bookDate').innerText = bookDateReal; // 예매일시

            document.getElementById('m_discountType').innerText = discountType;
            document.getElementById('m_discountAmount').innerText = "-" + discountAmount;

            document.getElementById('detailModal').style.display = 'flex';
        }

        function closeDetailModal() {
            document.getElementById('detailModal').style.display = 'none';
        }

        // [취소 확인 모달 열기]
        function openCancelConfirm() {
            const modal = document.getElementById('confirmModal');
            const text = document.getElementById('confirmText');
            
            // 메시지에 이름 넣기
            text.innerHTML = "'" + currentUserName + "' 님의 예매를<br>취소하시겠습니까?";
            
            modal.style.display = 'flex';
        }

        function closeConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        // [실제 취소 동작]
        function executeCancel() {
            alert('예매가 정상적으로 취소되었습니다.');
            closeConfirmModal(); // 확인창 닫기
            closeDetailModal();  // 상세창 닫기
            // location.reload(); // 실제로는 새로고침
        }

        // 외부 클릭 시 닫기
        window.onclick = function(event) {
            if (event.target == document.getElementById('detailModal')) closeDetailModal();
            if (event.target == document.getElementById('confirmModal')) closeConfirmModal();
        }
    </script>

</body>
</html>