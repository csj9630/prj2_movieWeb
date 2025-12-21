<%@page import="movie.theater_admin.SeatDTO"%>
<%@page import="movie.theater_admin.TheaterDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.admin.AdminTheaterService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
	request.setCharacterEncoding("UTF-8");
	
	String id = request.getParameter("id");
	String mode = "insert";
	TheaterDTO tDTO = null;
	List<SeatDTO> seatList = null;
	
	if(id != null && !id.equals("")){
		mode = "update";
		AdminTheaterService as = AdminTheaterService.getInstance();
		tDTO = as.getTheater(id);
		seatList = as.getSeatList(id);
	}
	
	pageContext.setAttribute("mode", mode);
	pageContext.setAttribute("tDTO", tDTO);
	pageContext.setAttribute("seatList", seatList);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 상영관 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <style>
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
        
        .form-container { background: #fff; border-radius: 12px; padding: 40px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); max-width: 900px; margin: 0 auto; display: flex; flex-direction: column; }
        .input-section { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; padding-bottom: 30px; border-bottom: 1px solid #eee; margin-bottom: 30px; }
        .input-row-wide { grid-column: span 3; display: flex; gap: 20px; }
        .half-width { flex: 1; }
        .form-group { margin-bottom: 0; }
        .form-label { display: block; font-size: 14px; font-weight: 700; color: #333; margin-bottom: 8px; }
        .form-input, .form-select { width: 100%; height: 45px; padding: 0 15px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; color: #555; background-color: #fff; }
        .form-input:read-only { background-color: #f9f9f9; color: #888; cursor: default; border-color: #e1e1e1; }
        .form-input:focus, .form-select:focus { border-color: #503396; }
        
        .seat-section { display: flex; flex-direction: column; align-items: center; width: 100%; }
        .seat-map-title { font-size: 16px; font-weight: 700; margin-bottom: 15px; color: #1e1e2d; }
        .screen { width: 600px; height: 35px; background: linear-gradient(to bottom, #ddd, #fff); border: 1px solid #ccc; margin-bottom: 40px; display: flex; justify-content: center; align-items: center; font-size: 14px; color: #555; border-radius: 4px; font-weight: 800; letter-spacing: 2px; box-shadow: 0 5px 10px rgba(0,0,0,0.1); }
        .seat-grid { display: grid; grid-template-columns: repeat(10, 1fr); gap: 10px; }
        .seat { width: 40px; height: 40px; background-color: #503396; border-radius: 8px; display: flex; justify-content: center; align-items: center; font-size: 12px; color: #fff; font-weight: 600; cursor: pointer; transition: 0.2s; box-shadow: 0 2px 5px rgba(80, 51, 150, 0.3); }
        .seat:hover { transform: scale(1.1); }
        .seat.disabled { background-color: #e0e0e0; color: #999; box-shadow: none; }
        
        .form-actions { width: 100%; display: flex; justify-content: center; gap: 10px; margin-top: 40px; padding-top: 20px; border-top: 1px solid #eee; }
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
                <h2>상영관 등록/수정</h2>
                <p>상영관의 상세 정보를 수정하고 좌석을 관리합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/admin_logout.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            <div class="form-container">
                <form id="theaterForm">
                    <input type="hidden" id="mode" value="${ mode }">
                    
                    <div class="input-section">
                        <div class="form-group">
                            <label class="form-label">상영관 ID</label>
                            <input type="text" id="theaterId" class="form-input" 
                            	value="${ tDTO.theatherNum }" ${ mode eq 'update' ? 'readonly' : '' } 
                            	placeholder="예: tn001">
                        </div>
                        <div class="form-group">
                            <label class="form-label">상영관 이름</label>
                            <input type="text" id="theaterName" class="form-input" value="${ tDTO.theatherName }" placeholder="예: 1상영관">
                        </div>
                        <div class="form-group">
                            <label class="form-label">총 좌석 수</label>
                            <input type="text" class="form-input" value="100석" readonly>
                        </div>

                        <div class="input-row-wide">
                            <div class="form-group half-width">
                                <label class="form-label">사운드 시스템</label>
                                <select class="form-select" id="soundSystem">
                                    <option value="tn001" ${ tDTO.soundCode eq 'tn001' ? 'selected' : '' }>Dolby Digital 7.1</option>
                                    <option value="tn002" ${ tDTO.soundCode eq 'tn002' ? 'selected' : '' }>DTS Digital Surround</option>
                                    <option value="tn003" ${ tDTO.soundCode eq 'tn003' ? 'selected' : '' }>Dolby Atmos</option>
                                </select>
                            </div>
                            <div class="form-group half-width">
                                <label class="form-label">사용 가능 여부</label>
                                <select class="form-select" id="isAvailable">
                                    <option value="T" ${ tDTO.availability eq 'T' ? 'selected' : '' }>사용중</option>
                                    <option value="F" ${ tDTO.availability eq 'F' ? 'selected' : '' }>미사용중</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="seat-section">
                        <h3 class="seat-map-title">좌석 배치도 (10x10)</h3>
                        <div class="screen">SCREEN</div>
                        
                        <div class="seat-grid" id="seatGrid"></div>
                        
                        <div style="margin-top:15px; font-size:13px; color:#888;">
                            <i class="fa-solid fa-circle-info"></i> 
                            <c:choose>
                            	<c:when test="${ mode eq 'update' }">
                            		좌석을 클릭하여 <strong>고장/수리중</strong> 상태로 변경할 수 있습니다. (즉시 반영)
                            	</c:when>
                            	<c:otherwise>
                            		신규 등록 시 모든 좌석은 '사용 가능' 상태로 생성됩니다.
                            	</c:otherwise>
                            </c:choose>
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
    	const seatData = {};
    	<c:if test="${ not empty seatList }">
    		<c:forEach var="s" items="${ seatList }">
    			seatData['${s.seatCode}'] = '${s.availableSeat}';
    		</c:forEach>
    	</c:if>
    	
    	const currentMode = "${ mode }";
    	const theaterIdVal = "${ tDTO.theatherNum }";

        window.onload = function() {
            createSeats();
        };

        function createSeats() {
            const grid = document.getElementById('seatGrid');
            const rows = ['A','B','C','D','E','F','G','H','I','J'];
            let html = '';
            
            rows.forEach(row => {
                for (let i = 1; i <= 10; i++) {
                	let tempSeatCode = theaterIdVal + "-" + row + i; 
                	
                	let statusClass = "seat";
                	if(currentMode === 'update' && seatData[tempSeatCode] === 'F'){
                		statusClass += " disabled";
                	}
                	
                    html += '<div class="'+statusClass+'" onclick="toggleSeat(this, \''+tempSeatCode+'\')">' + row + i + '</div>';
                }
            });
            grid.innerHTML = html;
        }

        function toggleSeat(element, seatCode) {
        	if(currentMode !== 'update') {
        		alert("신규 등록 중에는 좌석 상태를 변경할 수 없습니다.\n등록 후 수정 페이지에서 관리해주세요.");
        		return;
        	}
        	
        	let currentStatus = element.classList.contains('disabled') ? 'F' : 'T';
        	
        	$.ajax({
        		url: "admin_seat_status_process.jsp",
        		type: "post",
        		dataType: "json",
        		data: { 
        			seatCode: seatCode, 
        			status: currentStatus 
        		},
        		success: function(json){
        			if(json.result){
        				element.classList.toggle('disabled');
        			} else {
        				alert("좌석 상태 변경 실패");
        			}
        		},
        		error: function(){
        			alert("서버 통신 오류");
        		}
        	});
        }

        function saveTheater() {
        	let id = $("#theaterId").val();
        	let name = $("#theaterName").val();
        	let sound = $("#soundSystem").val();
        	let status = $("#isAvailable").val();
        	
        	if(id == "" || name == ""){
        		alert("필수 정보를 입력해주세요.");
        		return;
        	}
        	
        	$.ajax({
        		url: "admin_theater_register_process.jsp",
        		type: "post",
        		dataType: "json",
        		data: {
        			mode: currentMode,
        			id: id,
        			name: name,
        			sound: sound,
        			status: status
        		},
        		success: function(json){
        			if(json.result){
        				alert("저장이 완료되었습니다.");
        				location.href = "Admin_TheaterManagement.jsp";
        			} else {
        				alert("저장에 실패했습니다.");
        			}
        		},
        		error: function(){
        			alert("서버 통신 오류");
        		}
        	});
        }
    </script>
</body>
</html>