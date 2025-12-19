<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<%-- <%
	//모든 세션 삭제
    session.invalidate();
	
	String commonURL = (String)application.getAttribute("commonURL");
	
    //메인 페이지로 이동
    response.sendRedirect( commonURL+"/user/main/index.jsp");
%> --%>
<%
    session.invalidate();
    
    // 이전 페이지 URL 가져오기
    String prevPage = request.getHeader("Referer");
    
    // 이전 페이지 정보가 없다면 메인으로, 있다면 이전 페이지로 이동
    if (prevPage == null || prevPage.isEmpty()) {
        String commonURL = (String)application.getAttribute("commonURL");
        response.sendRedirect(commonURL + "/user/main/index.jsp");
    } else {
        response.sendRedirect(prevPage);
    }
%>