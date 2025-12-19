<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 상영 스케줄 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* [1. 초기화 & 공통] */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f5f6fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
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

        /* [4. 상단 탭] */
        .sub-nav { display: flex; gap: 30px; border-bottom: 1px solid #e1e1e1; margin-bottom: 30px; padding-bottom: 15px; }
        .sub-nav-item { font-size: 16px; font-weight: 700; color: #aaa; cursor: pointer; text-decoration: none; position: relative; padding-bottom: 15px; transition: 0.2s; }
        .sub-nav-item:hover { color: #503396; }
        .sub-nav-item.active { color: #1e1e2d; }
        .sub-nav-item.active::after { content: ''; position: absolute; bottom: -1px; left: 0; width: 100%; height: 3px; background-color: #503396; }

        /* [5. 정렬 안내] */
        .sort-info-area { display: flex; justify-content: flex-end; margin-bottom: 15px; }
        .sort-info { font-size: 13px; color: #888; display: flex; align-items: center; gap: 5px; }

        /* [6. 테이블] */
        .table-container { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .total-count { font-size: 14px; color: #555; font-weight: 600; }
        .total-count span { color: #503396; }
        
        table { width: 100%; border-collapse: collapse; font-size: 14px; table-layout: fixed; }
        th { background-color: #f9f9f9; color: #5e6278; font-weight: 600; text-align: center; padding: 15px 10px; border-bottom: 1px solid #eee; }
        td { padding: 15px 10px; border-bottom: 1px solid #f5f5f5; color: #3f4254; text-align: center; vertical-align: middle; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        tbody tr { transition: 0.2s; }
        tbody tr:hover { background-color: #f8f9fa; }

        /* 인라인 수정 스타일 */
        .edit-input, .edit-select { width: 90%; height: 34px; border: 1px solid #503396; border-radius: 4px; text-align: center; font-size: 13px; background-color: #fff; }
        .movie-edit-wrapper { display: flex; align-items: center; justify-content: center; gap: 5px; }
        .movie-search-btn { width: 30px; height: 34px; background-color: #503396; color: #fff; border-radius: 4px; border: none; cursor: pointer; display: flex; justify-content: center; align-items: center; }

        .row-actions { display: none; justify-content: center; gap: 5px; }
        .btn-row-ok { padding: 5px 10px; border-radius: 4px; background-color: #1bc5bd; color: #fff; font-size: 11px; font-weight: bold; }
        .btn-row-cancel { padding: 5px 10px; border-radius: 4px; background-color: #eee; color: #555; font-size: 11px; font-weight: bold; }

        tr.editing .row-actions { display: flex; }
        tr.editing .view-mode { display: none; }
        tr.editing .edit-mode { display: block; }
        tr.editing .movie-wrapper { display: flex; }
        
        .edit-mode, .movie-wrapper { display: none; }

        /* 하단 버튼 */
        .bottom-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
        .action-btn-lg { padding: 10px 20px; border-radius: 6px; font-size: 14px; font-weight: 700; border: 1px solid transparent; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 6px; }
        
        .btn-edit-mode { background-color: #503396; color: #fff; }
        .btn-edit-mode:hover { background-color: #3e257a; }
        .btn-delete-mode { background-color: #fdedec; color: #e74c3c; border-color: #fadbd8; }
        .btn-delete-mode:hover { background-color: #fceae9; }

        .pagination { display: flex; justify-content: center; margin-top: 30px; gap: 5px; }
        .page-link { width: 35px; height: 35px; display: flex; justify-content: center; align-items: center; border: 1px solid #eee; border-radius: 6px; font-size: 13px; color: #555; transition: 0.2s; }
        .page-link:hover { background-color: #f5f5f5; border-color: #ddd; }
        .page-link.active { background-color: #503396; color: #fff; border-color: #503396; font-weight: 700; }

        /* 확인 모달 */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 2000; justify-content: center; align-items: center; }
        .confirm-card { background-color: #fff; width: 400px; border-radius: 12px; text-align: center; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); }
        .confirm-icon { font-size: 40px; margin-bottom: 20px; }
        .confirm-text { font-size: 18px; font-weight: 700; color: #333; margin-bottom: 10px; }
        .confirm-sub { font-size: 14px; color: #888; margin-bottom: 30px; }
        .confirm-actions { display: flex; justify-content: center; gap: 10px; }
        .btn-confirm-yes { padding: 10px 30px; border-radius: 6px; border: none; font-weight: 700; cursor: pointer; color: #fff; }
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
                <li><a href="../admin_reservationmanagement/Admin_ReservationList.jsp" class="menu-link"><i class="fa-solid fa-ticket menu-icon"></i><span>예매 관리</span></a></li>
                <li><a href="Admin_ScreeningList.jsp" class="menu-link active"><i class="fa-solid fa-calendar-days menu-icon"></i><span>상영 스케줄 관리</span></a></li>
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
                <h2>상영 스케줄 관리</h2>
                <p>영화 상영 일정을 조회, 등록, 수정, 삭제합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/Admin_Login.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            
            <div class="sub-nav">
                <a href="Admin_ScreeningList.jsp" class="sub-nav-item active">스케줄 조회</a>
                <a href="Admin_ScreeningRegister.jsp" class="sub-nav-item">스케줄 추가</a>
            </div>

            <div class="sort-info-area">
                <span class="sort-info"><i class="fa-solid fa-arrow-down-wide-short"></i> 상영 일시 최신순 정렬</span>
            </div>

            <div class="table-container">
                <div class="table-header">
                    <p class="total-count">총 <span>45</span>건의 스케줄이 있습니다.</p>
                </div>

                <table>
                    <colgroup>
                        <col width="5%"> <col width="15%"> <col width="30%"> <col width="20%"> <col width="15%"> <col width="15%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>선택</th>
                            <th>상영관 이름</th>
                            <th>영화 제목</th>
                            <th>상영 날짜</th>
                            <th>상영 시간</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody id="scheduleTableBody">
                        </tbody>
                </table>

                <div class="bottom-actions">
                    <button class="action-btn-lg btn-edit-mode" onclick="enableRowEdit()">
                        <i class="fa-solid fa-pen-to-square"></i> 수정
                    </button>
                    <button class="action-btn-lg btn-delete-mode" onclick="openConfirmModal('delete')">
                        <i class="fa-solid fa-trash-can"></i> 삭제
                    </button>
                </div>

                <div class="pagination">
                    <a href="#" class="page-link active">1</a>
                    <a href="#" class="page-link">2</a>
                    <a href="#" class="page-link">3</a>
                </div>
            </div>
        </div>
    </main>

    <div id="confirmModal" class="modal-overlay" style="z-index: 2100;">
        <div class="confirm-card">
            <div class="confirm-icon" id="confirmIcon"></div>
            <div id="confirmTitle" class="confirm-text"></div>
            <div id="confirmSub" class="confirm-sub"></div>
            <div class="confirm-actions">
                <button class="btn-confirm-no" onclick="closeConfirmModal()">아니오</button>
                <button class="btn-confirm-yes" onclick="executeAction()">예</button>
            </div>
        </div>
    </div>

    <script>
        window.onload = function() {
            renderTable();
        };

        function renderTable() {
            const tbody = document.getElementById('scheduleTableBody');
            var html = ""; // var로 선언

            var movies = [
                "범죄도시4", "퓨리오사: 매드맥스", "인사이드 아웃 2", "설계자", "원더랜드", 
                "하이재킹", "콰이어트 플레이스", "탈주", "데드풀과 울버린", "파일럿",
                "리볼버", "에이리언: 로물루스", "행복의 나라", "베테랑2", "조커: 폴리 아 되"
            ];

            var times = ["22:30", "21:25", "21:00", "20:47", "20:15", "19:50", "19:20", "18:45", "18:00", "17:30", "16:15", "15:40", "14:20", "13:00", "11:30"];

            // 상영관 옵션 생성 (문자열 연결 방식)
            var theaterOptions = "";
            for(var k=1; k<=15; k++) {
                theaterOptions += '<option value="' + k + '상영관">' + k + '상영관</option>';
            }

            // 영화 옵션 생성
            var movieOptions = "";
            for(var j=0; j<movies.length; j++) {
                var m = movies[j];
                movieOptions += '<option value="' + m + '">' + m + '</option>';
            }

            // 15개 데이터 생성
            for (var i = 0; i < 15; i++) {
                var movie = movies[i % movies.length]; 
                var time = times[i]; 
                var theaterNum = (i % 15) + 1;
                var theater = theaterNum + "상영관";
                var rowId = i + 1;

                // ★ [수정] 따옴표와 더하기(+)를 사용한 안전한 문자열 연결
                html += '<tr id="row_' + rowId + '">';
                
                // 1. 체크박스
                html += '<td><input type="checkbox" class="row-check" onclick="checkOnlyOne(this)"></td>';
                
                // 2. 상영관
                html += '<td>';
                html += '<span class="view-mode">' + theater + '</span>';
                html += '<select class="edit-mode edit-select">' + theaterOptions + '</select>';
                html += '</td>';
                
                // 3. 영화
                html += '<td>';
                html += '<span class="view-mode">' + movie + '</span>';
                html += '<div class="movie-wrapper edit-mode movie-edit-wrapper">';
                html += '<select class="edit-select" style="width:80%">' + movieOptions + '</select>';
                html += '<button type="button" class="movie-search-btn" title="영화 검색"><i class="fa-solid fa-magnifying-glass"></i></button>';
                html += '</div>';
                html += '</td>';

                // 4. 날짜
                html += '<td>';
                html += '<span class="view-mode">2025-12-06</span>';
                html += '<input type="date" class="edit-mode edit-input" value="2025-12-06">';
                html += '</td>';

                // 5. 시간
                html += '<td>';
                html += '<span class="view-mode">' + time + '</span>';
                html += '<input type="time" class="edit-mode edit-input" value="' + time + '">';
                html += '</td>';

                // 6. 관리 버튼
                html += '<td>';
                html += '<div class="row-actions">';
                html += '<button class="btn-row-ok" onclick="openConfirmModal(\'save\', ' + rowId + ')">확인</button>';
                html += '<button class="btn-row-cancel" onclick="cancelRowEdit(' + rowId + ')">취소</button>';
                html += '</div>';
                html += '</td>';
                
                html += '</tr>';
            }
            tbody.innerHTML = html;
            
            // 생성 후 초기값 세팅 (선택된 값 유지)
            for(var i=0; i<15; i++) {
                var theaterNum = (i % 15) + 1;
                var theaterVal = theaterNum + "상영관";
                var movieVal = movies[i % movies.length];
                
                var theaterSelect = document.querySelector('#row_' + (i+1) + ' td:nth-child(2) select');
                if(theaterSelect) theaterSelect.value = theaterVal;

                var movieSelect = document.querySelector('#row_' + (i+1) + ' td:nth-child(3) select');
                if(movieSelect) movieSelect.value = movieVal;
            }
        }

        var currentAction = '';
        var currentRowId = '';

        function checkOnlyOne(element) {
            var allChecks = document.querySelectorAll('.row-check');
            allChecks.forEach(function(cb) { cb.checked = false; });
            element.checked = true;
        }

        function enableRowEdit() {
            var selected = document.querySelector('.row-check:checked');
            if (!selected) { alert("수정할 스케줄을 선택해주세요."); return; }
            
            var editingRows = document.querySelectorAll('tr.editing');
            editingRows.forEach(function(tr) { tr.classList.remove('editing'); });
            
            var tr = selected.closest('tr');
            tr.classList.add('editing');
        }

        function cancelRowEdit(rowId) {
            document.getElementById('row_' + rowId).classList.remove('editing');
        }

        function openConfirmModal(action, rowId) {
            if (action === 'delete') {
                var selected = document.querySelector('.row-check:checked');
                if (!selected) { alert("삭제할 스케줄을 선택해주세요."); return; }
            }
            currentAction = action;
            currentRowId = rowId;

            var modal = document.getElementById('confirmModal');
            var icon = document.getElementById('confirmIcon');
            var title = document.getElementById('confirmTitle');
            var sub = document.getElementById('confirmSub');
            var btn = document.querySelector('.btn-confirm-yes');

            if (action === 'save') {
                title.innerText = "수정하시겠습니까?";
                sub.innerText = "변경된 내용이 스케줄에 반영됩니다.";
                icon.innerHTML = '<i class="fa-solid fa-circle-check" style="color:#503396"></i>';
                btn.style.backgroundColor = "#503396";
            } else {
                title.innerText = "삭제하시겠습니까?";
                sub.innerText = "선택한 상영 스케줄을 삭제합니다.";
                icon.innerHTML = '<i class="fa-solid fa-trash-can" style="color:#e74c3c"></i>';
                btn.style.backgroundColor = "#e74c3c";
            }
            modal.style.display = 'flex';
        }

        function closeConfirmModal() { document.getElementById('confirmModal').style.display = 'none'; }

        function executeAction() {
            if (currentAction === 'save') {
                alert('수정이 완료되었습니다.');
                cancelRowEdit(currentRowId);
            } else {
                alert('삭제가 완료되었습니다.');
            }
            closeConfirmModal();
        }
    </script>

</body>
</html>