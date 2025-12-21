<%@page import="movie.admin.AdminService"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // AJAX 통신용 프로세스 파일
    String userId = request.getParameter("userId");
    String statusMode = request.getParameter("status"); // 'active' or 'inactive'
    
    // [중요 수정] DB 저장 값: '활성화' / '비활성화' (3글자)
    String dbStatus = "비활성화";
    if("active".equals(statusMode)){
        dbStatus = "활성화";
    }
    
    boolean result = false;
    if(userId != null && !"".equals(userId)){
        AdminService as = AdminService.getInstance();
        result = as.modifyUserStatus(userId, dbStatus);
    }
    
    // JSON 응답 생성
    JSONObject json = new JSONObject();
    json.put("result", result);
    
    out.print(json.toJSONString());
%>