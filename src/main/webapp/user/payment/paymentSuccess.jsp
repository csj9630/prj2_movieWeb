<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<%
	String bookNum = request.getParameter("bookNum");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예매 완료</title>
<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css" media="all">
<script src="https://cdn.tailwindcss.com"></script>
<style>
    body { font-family: '맑은 고딕', 'Malgun Gothic', sans-serif; }
</style>
</head>
<body>
    <header id="header">
        <jsp:include page="../../fragments/header.jsp" />
    </header>

    <div class="w-full flex justify-center py-20 bg-[#f2f4f8] min-h-[600px]">
        <div class="bg-white p-10 rounded shadow-lg text-center max-w-2xl w-full flex flex-col items-center justify-center">
            
            <div class="mb-6 text-[#503396]">
                <i class="fas fa-check-circle text-6xl"></i>
            </div>
            
            <h1 class="text-3xl font-bold mb-4 text-black">예매가 완료되었습니다!</h1>
            <p class="text-gray-600 mb-8">
                회원님의 예매 번호는 <span class="font-bold text-[#503396] text-lg"><%= bookNum %></span> 입니다.<br>
                자세한 예매 내역은 마이페이지에서 확인하실 수 있습니다.
            </p>

            <div class="flex gap-4">
                <a href="${commonURL}/user/main/index.jsp" 
                   class="px-6 py-3 bg-gray-500 text-white rounded hover:bg-gray-600 font-bold transition">
                    홈으로 가기
                </a>
                <a href="${commonURL}/user/movie_mypage/mypage_main.jsp" 
                   class="px-6 py-3 bg-[#503396] text-white rounded hover:bg-[#3d2575] font-bold transition">
                    마이페이지 확인
                </a>
            </div>
            
        </div>
    </div>

    <footer id="footer">
        <jsp:include page="../../fragments/footer.jsp" />
    </footer>
</body>
</html>
