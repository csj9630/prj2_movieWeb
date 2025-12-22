<%@page import="movie.review.ReviewDTO"%>
<%@page import="movie.review.ReviewService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");

//파라미터 받기
String movieCode = request.getParameter("movieCode");
String scoreStr = request.getParameter("score");
String content = request.getParameter("content");
String userId = (String) session.getAttribute("userId");


//로그인 확인
if (userId == null) {
 out.print("login_required");
 return;
}

//입력값 검증
if (movieCode == null || scoreStr == null || content == null) {
 out.print("false");
 return;
}

//서비스 호출
ReviewService rs = ReviewService.getInstance();


//영화 봤는지 체크.
String bookCode = rs.checkBookBeforeReview(movieCode,userId);
if(bookCode ==null || bookCode.isEmpty()){
	out.print("noBook");
	 return;
}

//점수 변환
int score = 0;
try {
 score = Integer.parseInt(scoreStr);
 if (score < 1 || score > 10) {
     out.print("false");
     return;
 }
} catch (NumberFormatException e) {
 out.print("false");
 return;
}

//내용 검증
content = content.trim();
if (content.length() < 10 || content.length() > 500) {
 out.print("false");
 return;
}



//DTO 생성


ReviewDTO mrDTO = new ReviewDTO();
mrDTO.setMovieCode(movieCode);
mrDTO.setScore(score);
mrDTO.setContent(content);
mrDTO.setUsers_id(userId);
mrDTO.setBook_code(bookCode);

//System.out.println("프로세스 : " + mrDTO);
//DB 저장

boolean flag = rs.addReview(mrDTO);
//System.out.println("jsp flag : "+flag);
//결과 반환
out.print(flag);


%>