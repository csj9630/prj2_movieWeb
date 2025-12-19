<%@page import="movie.review.ReviewDTO"%>
<%@page import="movie.review.ReviewService"%>
<%@page import="movie.trailer.TrailerDTO"%>
<%@page import="movie.trailer.TrailerService"%>
<%@page import="java.util.List"%>
<%@page import="movie.image.ImageDTO"%>
<%@page import="movie.image.ImageService"%>
<%@page import="movie.detail.DetailService"%>
<%@page import="movie.detail.DetailDTO"%>
<%@page import="movie.detail.DetailDAO"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
String movieCode = request.getParameter("code");

DetailService ds = DetailService.getInstance();
DetailDTO dtDTO = ds.searchMovieDetail(movieCode);

ImageService is = ImageService.getInstance();
List<ImageDTO> imgList = is.searchImageList(movieCode);

TrailerService ts = TrailerService.getInstance();
List<TrailerDTO> trailerList = ts.searchTrailerList(movieCode);

ReviewService rs = ReviewService.getInstance();
List<ReviewDTO> reviewList = rs.searchReviewList(movieCode);

//int reviewCount = reviewList.size();
//영화 평점
double scoreAverage = rs.getScoreAverage(reviewList);

pageContext.setAttribute("detail", dtDTO);
pageContext.setAttribute("imgList", imgList);
pageContext.setAttribute("trailerList", trailerList);
pageContext.setAttribute("reviewList", reviewList);
pageContext.setAttribute("scoreAverage", scoreAverage);


%>
