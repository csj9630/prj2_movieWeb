<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="seat.booking.SeatBookDTO"%>
<%@page import="seat.booking.SeatBookService"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
SeatBookService sbs = SeatBookService.getInstance();
SeatBookDTO sbDTO = new SeatBookDTO();
//Parameter값 받아오기
String userId = (String) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");
String movieCode = request.getParameter("movieCode");
String screenCode = request.getParameter("screenCode");
String theaterNum = request.getParameter("theaterNum");
int totalPrice = Integer.parseInt(request.getParameter("totalPrice"));
//사용자가 선택한 좌석 이름들 (A10,B10,C4,D8,D9,E8 식으로 넘어옴)
String selectedSeats = request.getParameter("selectedSeatNames");
//할인 코드(dc001 dc002...)
String discounts = request.getParameter("discountCodeList");

/* ---좌석네임(st001..) 값을 넘겨주기 위해서 List 변환 로직 시작 --- */
List<String> seatNamesList = new ArrayList<>();
if (selectedSeats != null && !selectedSeats.isEmpty()) {
    // split(",")을 통해 배열로 만든 뒤, List로 변환
    String[] tempArray = selectedSeats.split(",");
    seatNamesList = Arrays.asList(tempArray);
}
/* --- List 변환 로직 끝 --- */

/* ---할인코드 값(dc001,,,) 리스트에 넣어주기 --- */
List<String> discountCodeList = new ArrayList<>();
if (discounts != null && !discounts.isEmpty()) {
    // split(",")을 통해 배열로 만든 뒤, List로 변환
    String[] tempArray = discounts.split(",");
    discountCodeList = Arrays.asList(tempArray);
}
/* --- List 변환 로직 끝 --- */

/* seatNamesList : 사용자가 선택한 좌석의 seat_code값 리스트로 잘 나오는 거 확인 완료. st001 st009 ... */
List<String> seatCodeList = sbs.getSeatCodes(seatNamesList, theaterNum);

/* DTO에 값 넣기 */
sbDTO.setUserId(userId);
sbDTO.setMovieCode(movieCode);
sbDTO.setScreenCode(screenCode);
sbDTO.setTotalPrice(totalPrice);
sbDTO.setSeatCodes(seatCodeList);
sbDTO.setDiscountCodes(discountCodeList);
System.out.println("넘어온 상영관번호: " + theaterNum);
System.out.println("넘어온 좌석이름들: " + selectedSeats);
System.out.println("예약 좌석 : " + seatCodeList);
//4. 응답 처리 로직
String responseJSON = "";

//[보완] 좌석이 선택되지 않았을 경우 처리
if (seatCodeList == null || seatCodeList.isEmpty()) {
 responseJSON = "{\"status\":\"fail\", \"message\":\"선택된 좌석 정보가 없습니다.\"}";
} else {
 // 5. 중복 예약 여부 체크
 boolean isReserved = sbs.checkSeatAvailability(seatCodeList, screenCode);

 if (isReserved) {
     responseJSON = "{\"status\":\"fail\", \"message\":\"다른 분이 좌석을 선점하셨습니다. 다시 선택해주세요.\"}";
 } else {
     // 중복이 없을 경우에만 성공 응답
     responseJSON = "{\"status\":\"success\"}";
 }
}

out.print(responseJSON);
out.flush();
%>