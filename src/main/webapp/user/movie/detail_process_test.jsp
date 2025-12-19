<%@page import="movie.review.ReviewDTO"%>
<%@page import="movie.review.ReviewService"%>
<%@page import="movie.image.ImageDTO"%>
<%@page import="movie.trailer.TrailerDTO"%>
<%@page import="movie.trailer.TrailerService"%>
<%@page import="java.util.List"%>
<%@page import="movie.image.ImageService"%>
<%@page import="movie.detail.DetailDTO"%>
<%@page import="movie.detail.DetailService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% 
//DAO,Service 만들고 DB 데이터 잘 들어오는지 테스트하는 페이지.

String movieCode = "mc001";

DetailService ds = DetailService.getInstance();

//영화 누적 관객수 업데이트 테스트.
//System.out.println(ds.modifyAudience(5555, 10000, movieCode));

//String str = dtDAO.selectDetail("mc2").toString();
DetailDTO dtDTO = ds.searchMovieDetail(movieCode);
application.setAttribute("result",dtDTO);

//ImageService 테스트
ImageService is = ImageService.getInstance();
List<ImageDTO> imagelist =is.searchImageList(movieCode);
pageContext.setAttribute("img",imagelist);

//TrailerService 테스트
TrailerService ts = TrailerService.getInstance();
List<TrailerDTO> trailerList= ts.searchTrailerList(movieCode);
pageContext.setAttribute("trailerList",trailerList);

//리뷰 테스트
ReviewService rs = ReviewService.getInstance();
List<ReviewDTO> reviewList = rs.searchReviewList(movieCode);
pageContext.setAttribute("reviewList", reviewList);

%>
<h5>리뷰 로드</h5>
${reviewList }

	<hr><hr><hr>
<h5>영화 상세</h5>
${result}

<%
String code= "mc";
for(int i = 0; i<50; i++){
	code = "mc";
	code += String.format("%3s", i + 1).replace(" ", "0");

	dtDTO = ds.searchMovieDetail(code);
	out.print(dtDTO.toString());
	%>
	<hr><hr><hr>
	<%
}

%>



<hr><hr><hr>
<h5>이미지</h5>
${img}
<hr><hr><hr>
<h5>트레일러</h5>
${trailerList}