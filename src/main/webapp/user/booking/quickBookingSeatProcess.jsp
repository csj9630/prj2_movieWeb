<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="seat.booking.SeatBookDTO"%>
<%@page import="seat.booking.SeatBookService"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
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

System.out.println("예약 좌석 : " + seatCodeList);

String bookNum = sbs.processCompleteBooking(sbDTO);

//2. JSON 문자열 생성
String responseJSON = "";
if (bookNum != null) {
    // 성공 시 status를 success로 반환하고, 생성된 예매 번호도 함께 전송
    responseJSON = "{\"status\":\"success\", \"message\":\"예약 정보가 저장되었습니다.\", \"bookNum\":\"" + bookNum + "\"}";
} else {
    // 실패 시 status를 fail로 반환
    responseJSON = "{\"status\":\"fail\", \"message\":\"데이터베이스 저장 중 오류가 발생했습니다.\"}";
}

// 3. 응답 출력 후 종료 (HTML 태그가 섞이지 않도록 주의)
out.print(responseJSON);
out.flush();
%>
