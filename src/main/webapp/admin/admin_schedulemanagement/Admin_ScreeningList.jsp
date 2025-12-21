<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="movie.screening_admin.ScreeningDTO" %>
<%@ page import="movie.admin.AdminScreeningService" %>
<%@ page import="movie.admin.AdminMovieService" %> <%@ page import="movie.movie_admin.MovieDTO" %> 
<%@ page import="movie.theater_admin.TheaterDAO" %>
<%@ page import="movie.theater_admin.TheaterDTO" %>
<%
    // [세션 검사] 로그인 안 된 상태면 로그인 화면으로 튕겨냄
    String adminId = (String) session.getAttribute("adminId");
    if (adminId == null) {
%>
    <script>
        alert("로그인이 필요한 서비스입니다.");
        location.href = "../admin_login/Admin_Login.jsp";
    </script>
<%
        return; // 밑에 있는 HTML이나 자바 코드가 실행되지 않도록 여기서 멈춤
    }
%>
<%
    // 1. 서비스 및 DAO 초기화
    AdminScreeningService screeningService = AdminScreeningService.getInstance();
    AdminMovieService movieService = AdminMovieService.getInstance(); // [추가] 영화 서비스
    TheaterDAO tDAO = TheaterDAO.getInstance();

    // 2. 파라미터 처리 (페이징)
    String pageNum = request.getParameter("pageNum");
    int currentPage = 1;
    if(pageNum != null && !pageNum.equals("")){
        currentPage = Integer.parseInt(pageNum);
    }
    int pageSize = 10;

    // 3. 데이터 조회 (스케줄)
    List<ScreeningDTO> list = screeningService.getScreeningList(currentPage, pageSize, null, null);
    int totalCount = screeningService.getTotalCount(null, null);
    
    // [수정 핵심] 수정 폼에서 사용할 영화 목록을 '스케줄 등록용(상영종료 제외)' 메서드로 교체
    // 기존: List<MovieDTO> movieList = mDAO.selectMovieList(1, 100, ""); 
    List<MovieDTO> movieList = movieService.getMoviesForSchedule(); 
    
    List<TheaterDTO> theaterList = tDAO.selectTheaterList(1, 100);

    // 4. 페이징 계산
    int totalPage = (int)Math.ceil((double)totalCount / pageSize);
    int pageBlock = 5;
    int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
    int endPage = startPage + pageBlock - 1;
    if(endPage > totalPage) endPage = totalPage;
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 상영 스케줄 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 기존 CSS와 동일 (생략) */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f5f6fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        button { border: none; cursor: pointer; font-family: 'Noto Sans KR', sans-serif; }
        input, select { font-family: 'Noto Sans KR', sans-serif; }
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
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .top-header { height: 80px; background-color: #ffffff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; letter-spacing: -0.5px; }
        .header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
        .header-right { display: flex; align-items: center; gap: 20px; margin-left: 20px; }
        .logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s; }
        .logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }
        .sub-nav { display: flex; gap: 30px; border-bottom: 1px solid #e1e1e1; margin-bottom: 30px; padding-bottom: 15px; }
        .sub-nav-item { font-size: 16px; font-weight: 700; color: #aaa; cursor: pointer; text-decoration: none; position: relative; padding-bottom: 15px; transition: 0.2s; }
        .sub-nav-item:hover { color: #503396; }
        .sub-nav-item.active { color: #1e1e2d; }
        .sub-nav-item.active::after { content: ''; position: absolute; bottom: -1px; left: 0; width: 100%; height: 3px; background-color: #503396; }
        .sort-info-area { display: flex; justify-content: flex-end; margin-bottom: 15px; }
        .sort-info { font-size: 13px; color: #888; display: flex; align-items: center; gap: 5px; }
        .table-container { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .total-count { font-size: 14px; color: #555; font-weight: 600; }
        .total-count span { color: #503396; }
        table { width: 100%; border-collapse: collapse; font-size: 14px; table-layout: fixed; }
        th { background-color: #f9f9f9; color: #5e6278; font-weight: 600; text-align: center; padding: 15px 10px; border-bottom: 1px solid #eee; }
        td { padding: 15px 10px; border-bottom: 1px solid #f5f5f5; color: #3f4254; text-align: center; vertical-align: middle; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        tbody tr { transition: 0.2s; }
        tbody tr:hover { background-color: #f8f9fa; }
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
        <div class="sidebar-footer">
    <div class="admin-avatar">
        <%= adminId != null && adminId.length() >= 2 ? adminId.substring(0, 2).toUpperCase() : "AD" %>
    </div>
    <div class="admin-info">
        <h4><%= adminId %></h4>
        <p>Admin Account</p>
    </div>
</div>
    </nav>

    <main class="main-content">
        <header class="top-header">
            <div class="header-left-title">
                <h2>상영 스케줄 관리</h2>
                <p>영화 상영 일정을 조회, 등록, 수정, 삭제합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/admin_logout.jsp'">로그아웃</button></div>
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
                    <p class="total-count">총 <span><%= totalCount %></span>건의 스케줄이 있습니다.</p>
                </div>

                <form name="actionForm" method="post">
                    <input type="hidden" name="screen_code" id="formScreenCode">
                    <input type="hidden" name="movie_code" id="formMovieCode">
                    <input type="hidden" name="theater_num" id="formTheaterNum">
                    <input type="hidden" name="screen_date" id="formScreenDate">
                    <input type="hidden" name="screen_time" id="formScreenTime">
                </form>

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
                    <% 
                    if(list == null || list.isEmpty()) { 
                    %>
                        <tr><td colspan="6">등록된 스케줄이 없습니다.</td></tr>
                    <% 
                    } else {
                        for(ScreeningDTO dto : list) {
                            String rowId = dto.getScreenCode();
                    %>
                        <tr id="row_<%= rowId %>">
                            <td><input type="checkbox" class="row-check" value="<%= rowId %>" onclick="checkOnlyOne(this)"></td>
                            
                            <td>
                                <span class="view-mode"><%= dto.getTheaterName() %></span>
                                <select class="edit-mode edit-select" id="theater_<%= rowId %>">
                                    <% 
                                    // [수정 완료] 오직 Availability가 'T'인 상영관만 표시
                                    // 기존의 '|| isCurrent' 조건 제거 -> 폐쇄된 상영관은 아예 목록에 안 뜸
                                    for(TheaterDTO tDto : theaterList) { 
                                        if (tDto.getAvailability() != null && "T".equalsIgnoreCase(tDto.getAvailability().trim())) {
                                            boolean isSelected = tDto.getTheatherNum().equals(dto.getTheaterNum());
                                    %>
                                        <option value="<%= tDto.getTheatherNum() %>" 
                                            <%= isSelected ? "selected" : "" %>>
                                            <%= tDto.getTheatherName() %>
                                        </option>
                                    <% 
                                        } 
                                    } 
                                    %>
                                </select>
                            </td>

                            <td>
                                <span class="view-mode"><%= dto.getMovieName() %></span>
                                <div class="movie-wrapper edit-mode movie-edit-wrapper">
                                    <select class="edit-select" style="width:100%" id="movie_<%= rowId %>">
                                        <% for(MovieDTO mDto : movieList) { %>
                                            <option value="<%= mDto.getMovieCode() %>"
                                                <%= mDto.getMovieName().equals(dto.getMovieName()) ? "selected" : "" %>>
                                                <%= mDto.getMovieName() %>
                                            </option>
                                        <% } %>
                                    </select>
                                </div>
                            </td>

                            <td>
                                <span class="view-mode"><%= dto.getScreenDate() %></span>
                                <input type="date" class="edit-mode edit-input" id="date_<%= rowId %>" value="<%= dto.getScreenDate() %>">
                            </td>

                            <td>
                                <span class="view-mode"><%= dto.getScreenTime() %></span>
                                <input type="time" class="edit-mode edit-input" id="time_<%= rowId %>" value="<%= dto.getScreenTime() %>">
                            </td>

                            <td>
                                <div class="row-actions">
                                    <button class="btn-row-ok" onclick="openConfirmModal('save', '<%= rowId %>')">확인</button>
                                    <button class="btn-row-cancel" onclick="cancelRowEdit('<%= rowId %>')">취소</button>
                                </div>
                            </td>
                        </tr>
                    <% 
                        } 
                    } 
                    %>
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
                    <% if(startPage > pageBlock) { %>
                        <a href="Admin_ScreeningList.jsp?pageNum=<%= startPage-1 %>" class="page-link"><i class="fa-solid fa-angle-left"></i></a>
                    <% } %>
                    
                    <% for(int i=startPage; i<=endPage; i++) { %>
                        <a href="Admin_ScreeningList.jsp?pageNum=<%= i %>" class="page-link <%= i == currentPage ? "active" : "" %>"><%= i %></a>
                    <% } %>
                    
                    <% if(endPage < totalPage) { %>
                        <a href="Admin_ScreeningList.jsp?pageNum=<%= endPage+1 %>" class="page-link"><i class="fa-solid fa-angle-right"></i></a>
                    <% } %>
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
            
            var rowId = selected.value; // PK
            var editingRows = document.querySelectorAll('tr.editing');
            editingRows.forEach(function(tr) { tr.classList.remove('editing'); });
            
            var tr = document.getElementById('row_' + rowId);
            tr.classList.add('editing');
        }

        function cancelRowEdit(rowId) {
            document.getElementById('row_' + rowId).classList.remove('editing');
        }

        function openConfirmModal(action, rowId) {
            if (action === 'delete') {
                var selected = document.querySelector('.row-check:checked');
                if (!selected) { alert("삭제할 스케줄을 선택해주세요."); return; }
                currentRowId = selected.value; // 삭제할 PK
            } else {
                currentRowId = rowId;
            }
            
            currentAction = action;
            
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
            var frm = document.actionForm;

            if (currentAction === 'save') {
                var rowId = currentRowId;
                var movieCode = document.getElementById('movie_' + rowId).value;
                var theaterNum = document.getElementById('theater_' + rowId).value;
                var sDate = document.getElementById('date_' + rowId).value;
                var sTime = document.getElementById('time_' + rowId).value;

                frm.screen_code.value = rowId;
                frm.movie_code.value = movieCode;
                frm.theater_num.value = theaterNum;
                frm.screen_date.value = sDate;
                frm.screen_time.value = sTime;
                
                frm.action = "admin_screening_update_process.jsp";
                frm.submit();

            } else {
                frm.screen_code.value = currentRowId;
                frm.action = "admin_screening_delete_process.jsp";
                frm.submit();
            }
            closeConfirmModal();
        }
    </script>
</body>
</html>