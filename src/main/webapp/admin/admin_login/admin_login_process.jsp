<%@page import="movie.admin.AdminDTO"%>
<%@page import="movie.admin.AdminService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 1. 요청 파라미터 인코딩
    request.setCharacterEncoding("UTF-8");

    // 2. 파라미터 받기
    String id = request.getParameter("id");
    String pass = request.getParameter("pass");
    
    // 3. 유효성 검증 (Backend)
    if(id == null || "".equals(id.trim()) || pass == null || "".equals(pass.trim())){
        response.sendRedirect("Admin_Login.jsp"); // 입력값 없으면 돌려보냄
        return;
    }
    
    // 4. Service 호출하여 로그인 시도
    AdminService as = AdminService.getInstance();
    AdminDTO aDTO = as.login(id, pass); // 성공 시 DTO, 실패 시 null 반환
    
    // 5. 결과 처리
    if(aDTO != null){ // 로그인 성공
        // 세션에 관리자 ID 저장
        session.setAttribute("adminId", aDTO.getAdminId());
        // 세션 유지 시간 설정 (예: 60분 = 3600초)
        session.setMaxInactiveInterval(60 * 60);
        
        // 대시보드로 이동
        response.sendRedirect("../admin_dashboard/Admin_Dashboard.jsp");
        
    } else { // 로그인 실패
%>
        <script type="text/javascript">
            alert("아이디나 비밀번호를 확인해주세요.");
            // history.back()은 입력한 값이 남아있어서 다시 시도하기 편함
            history.back(); 
        </script>
<%
    }
%>