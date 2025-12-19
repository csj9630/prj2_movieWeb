<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 상영관 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* [1. 공통 스타일 유지] */
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
        .sidebar { width: 260px; background-color: #1e1e2d; color: #a2a3b7; display: flex; flex-direction: column; flex-shrink: 0; transition: all 0.3s; }
        .logo-area { height: 80px; display: flex; align-items: center; justify-content: center; background-color: #1b1b28; border-bottom: 1px solid #2d2d3f; }
        .logo-area img { height: 45px; object-fit: contain; display: block; }
        .menu-list { padding: 20px 0; flex: 1; overflow-y: auto; }
        .menu-category { font-size: 11px; font-weight: 700; text-transform: uppercase; color: #5e6278; padding: 10px 25px; margin-top: 15px; }
        .menu-category:first-child { margin-top: 0; }
        .menu-link { display: flex; align-items: center; padding: 12px 25px; color: #a2a3b7; font-size: 14px; font-weight: 500; transition: 0.2s; border-left: 3px solid transparent; }
        .menu-link:hover, .menu-link.active { background-color: #2b2b40; color: #fff; border-left-color: #503396; }
        .menu-icon { width: 25px; font-size: 16px; text-align: center; margin-right: 10px; }
        .sidebar-footer { padding: 20px; border-top: 1px solid #2d2d3f; display: flex; align-items: center; gap: 12px; background-color: #1e1e2d; }
        .admin-avatar { width: 40px; height: 40px; background-color: #503396; border-radius: 50%; display: flex; justify-content: center; align-items: center; color: #fff; font-weight: bold; font-size: 14px; }
        .admin-info h4 { font-size: 14px; color: #fff; font-weight: 500; margin-bottom: 2px; }
        .admin-info p { font-size: 12px; color: #727589; }

        /* [3. 메인 컨텐츠] */
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .top-header { height: 80px; background-color: #ffffff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; letter-spacing: -0.5px; }
        .header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
        .header-right { display: flex; align-items: center; gap: 20px; margin-left: 20px; }
        .logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s; }
        .logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }
        
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }

        /* [4. 폼 컨테이너 스타일 (수정됨: 상하 배치)] */
        .form-container {
            background: #fff; border-radius: 12px; padding: 40px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.03); 
            max-width: 900px; margin: 0 auto;
            display: flex; flex-direction: column; /* 세로 배치 */
        }

        /* [4-1. 상단 입력 폼 (Grid 적용)] */
        .input-section {
            display: grid;
            grid-template-columns: repeat(3, 1fr); /* 3열 그리드 */
            gap: 20px;
            padding-bottom: 30px;
            border-bottom: 1px solid #eee;
            margin-bottom: 30px;
        }

        /* 사운드 시스템과 사용여부는 한 줄에 꽉 차게 */
        .input-row-wide {
            grid-column: span 3; /* 3칸 차지 */
            display: flex; gap: 20px;
        }
        .half-width { flex: 1; }

        .form-group { margin-bottom: 0; } /* 그리드라 마진 제거 */
        .form-label { display: block; font-size: 14px; font-weight: 700; color: #333; margin-bottom: 8px; }
        
        .form-input, .form-select {
            width: 100%; height: 45px; padding: 0 15px;
            border: 1px solid #ddd; border-radius: 6px;
            font-size: 14px; color: #555; background-color: #fff;
        }
        .form-input:read-only {
            background-color: #f9f9f9; color: #888; cursor: default; border-color: #e1e1e1;
        }
        .form-input:focus, .form-select:focus { border-color: #503396; }

        /* [4-2. 하단 좌석 배치도 (중앙 정렬)] */
        .seat-section {
            display: flex; flex-direction: column; align-items: center;
            width: 100%;
        }
        .seat-map-title { font-size: 16px; font-weight: 700; margin-bottom: 15px; color: #1e1e2d; }
        
        .screen {
            width: 600px; height: 35px; 
            background: linear-gradient(to bottom, #ddd, #fff); /* 스크린 느낌 */
            border: 1px solid #ccc;
            margin-bottom: 40px;
            display: flex; justify-content: center; align-items: center;
            font-size: 14px; color: #555; border-radius: 4px; font-weight: 800; letter-spacing: 2px;
            box-shadow: 0 5px 10px rgba(0,0,0,0.1);
        }

        .seat-grid {
            display: grid;
            grid-template-columns: repeat(10, 1fr); /* 10열 */
            gap: 10px;
        }
        
        .seat {
            width: 40px; height: 40px;
            background-color: #503396; /* 사용가능 */
            border-radius: 8px;
            display: flex; justify-content: center; align-items: center;
            font-size: 12px; color: #fff; font-weight: 600;
            cursor: pointer; transition: 0.2s;
            box-shadow: 0 2px 5px rgba(80, 51, 150, 0.3);
        }
        .seat:hover { transform: scale(1.1); }
        
        /* 비활성 좌석 스타일 */
        .seat.disabled { 
            background-color: #e0e0e0; color: #999; 
            box-shadow: none;
        }


        /* [5. 하단 버튼] */
        .form-actions {
            width: 100%;
            display: flex; justify-content: center; gap: 10px; margin-top: 40px; 
            padding-top: 20px; border-top: 1px solid #eee;
        }
        .btn-save { background-color: #503396; color: #fff; padding: 12px 30px; border-radius: 6px; font-weight: 700; transition: 0.2s; font-size: 15px; }
        .btn-save:hover { background-color: #3e257a; }
        .btn-cancel { background-color: #fff; border: 1px solid #ddd; color: #555; padding: 12px 30px; border-radius: 6px; font-weight: 600; transition: 0.2s; font-size: 15px; }
        .btn-cancel:hover { background-color: #f9f9f9; }

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
                <li><a href="../admin_theatermanagement/Admin_TheaterManagement.jsp" class="menu-link active"><i class="fa-solid fa-couch menu-icon"></i><span>상영관 관리</span></a></li>
                <li><a href="../admin_moviemanagement/Admin_MovieList.jsp" class="menu-link"><i class="fa-solid fa-film menu-icon"></i><span>영화 관리</span></a></li>
            </ul>
            <div class="menu-category">SERVICE</div>
            <ul>
                <li><a href="../admin_reservationmanagement/Admin_ReservationList.jsp" class="menu-link"><i class="fa-solid fa-ticket menu-icon"></i><span>예매 관리</span></a></li>
                <li><a href="../admin_schedulemanagement/Admin_ScreeningList.jsp" class="menu-link"><i class="fa-solid fa-calendar-days menu-icon"></i><span>상영 스케줄 관리</span></a></li>
            </ul>
            <div class="menu-category">BOARD</div>
            <ul>
                <li><a href="../admin_reviewmanagement/Admin_ReviewList.jsp" class="menu-link"><i class="fa-solid fa-comments menu-icon"></i><span>리뷰 관리</span></a></li>
                <li><a href="../admin_noticemanagement/Admin_NoticeList.jsp" class="menu-link"><i class="fa-solid fa-bullhorn menu-icon"></i><span>공지 사항</span></a></li>
            </ul>
        </div>
        <div class="sidebar-footer">
            <div class="admin-avatar">AD</div>
            <div class="admin-info"><h4>최고관리자</h4><p>Super Admin</p></div>
        </div>
    </nav>

    <main class="main-content">
        <header class="top-header">
            <div class="header-left-title">
                <h2>상영관 등록/수정</h2>
                <p>상영관의 상세 정보를 수정하고 좌석을 관리합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/Admin_Login.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            
            <div class="form-container">
                <form id="theaterForm">
                    
                    <div class="input-section">
                        <div class="form-group">
                            <label class="form-label">상영관 ID</label>
                            <input type="text" id="theaterId" class="form-input" readonly>
                        </div>
                        <div class="form-group">
                            <label class="form-label">상영관 이름</label>
                            <input type="text" id="theaterName" class="form-input" readonly>
                        </div>
                        <div class="form-group">
                            <label class="form-label">총 좌석 수</label>
                            <input type="text" class="form-input" value="100석" readonly>
                        </div>

                        <div class="input-row-wide">
                            <div class="form-group half-width">
                                <label class="form-label">사운드 시스템</label>
                                <select class="form-select" id="soundSystem">
                                    <option value="Dolby Digital 7.1">Dolby Digital 7.1</option>
                                    <option value="Dolby Atmos">Dolby Atmos</option>
                                    <option value="DTS Digital Surround">DTS Digital Surround</option>
                                    <option value="Meyer Sound">Meyer Sound</option>
                                </select>
                            </div>
                            <div class="form-group half-width">
                                <label class="form-label">사용 가능 여부</label>
                                <select class="form-select" id="isAvailable">
                                    <option value="사용중">사용중</option>
                                    <option value="미사용중">미사용중</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="seat-section">
                        <h3 class="seat-map-title">좌석 배치도 (10x10)</h3>
                        <div class="screen">SCREEN</div>
                        
                        <div class="seat-grid" id="seatGrid"></div>
                        
                        <div style="margin-top:15px; font-size:13px; color:#888;">
                            <i class="fa-solid fa-circle-info"></i> 좌석을 클릭하여 <strong>고장/수리중</strong> 상태로 변경할 수 있습니다.
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                        <button type="button" class="btn-save" onclick="saveTheater()">저장 완료</button>
                    </div>

                </form>
            </div>

        </div>
    </main>

    <script>
        window.onload = function() {
            // URL 파라미터 처리 (id=cinema1)
            const urlParams = new URLSearchParams(window.location.search);
            const theaterId = urlParams.get('id');

            if (theaterId) {
                document.getElementById('theaterId').value = theaterId;
                const num = theaterId.replace(/[^0-9]/g, "");
                document.getElementById('theaterName').value = num + "상영관";
            } else {
                document.getElementById('theaterId').value = "cinema1";
                document.getElementById('theaterName').value = "1상영관";
            }

            createSeats();
        };

        function createSeats() {
            const grid = document.getElementById('seatGrid');
            const rows = ['A','B','C','D','E','F','G','H','I','J'];
            
            let html = '';
            rows.forEach(row => {
                for (let i = 1; i <= 10; i++) {
                    const seatId = row + i;
                    html += '<div class="seat" onclick="toggleSeat(this)" title="'+seatId+'">' + seatId + '</div>';
                }
            });
            grid.innerHTML = html;
        }

        function toggleSeat(element) {
            element.classList.toggle('disabled');
        }

        function saveTheater() {
            alert('상영관 정보 수정이 완료되었습니다.');
            location.href = 'Admin_TheaterManagement.jsp';
        }
    </script>

</body>
</html>