<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // [핵심] 서버에 저장된 세션 정보를 전부 삭제합니다.
    session.invalidate();
%>
<script>
    alert("정상적으로 로그아웃 되었습니다.");
    // 로그아웃 후 로그인 페이지로 이동
    location.href = "Admin_Login.jsp"; 
</script>