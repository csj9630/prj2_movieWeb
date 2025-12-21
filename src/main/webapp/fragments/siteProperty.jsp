<%@ page language="java" contentType="text/html; charset=UTF-8"
   trimDirectiveWhitespaces="true" pageEncoding="UTF-8"%>
<%--
 # URL 수정해주는 파트
 
 ## 사용법 
 1. 원하는 jsp 상단에 다음 코드 주석 빼고 추가
<%@ include file="../../fragments/siteProperty.jsp"%>
 
 2.경로 필요한 부분을 다음과 같이 수정
 ctrl+F 눌러서 http://localhost/sist_prj2_movieWeb 선택 후 ${commonURL}로 일괄 수정
 
 예)
 <link rel="stylesheet" href="http://localhost/sist_prj2_movieWeb/resources/css/megabox.min.css" />
 ==> <link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css" />
 
--%>
    
<% 
String movieImgPath = "resources/images/movieImg";

application.setAttribute("commonURL","http://localhost/prj2_movieWeb");
//application.setAttribute("commonURL","http://tgv.sist.co.kr");
application.setAttribute("movieImgPath",movieImgPath );   
%>