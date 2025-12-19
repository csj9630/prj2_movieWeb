<%@page import="java.sql.SQLException"%>
<%@page import="java.util.ArrayList"%>
<%@page import="reserve.SeatBookDTO"%>
<%@page import="java.util.List"%>
<%@page import="reserve.BookDTO"%>
<%@page import="reserve.ReserveDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
ReserveDAO sbDAO = ReserveDAO.getInstance();
String screenCode = "scc001", seatCode="st001";

boolean flag = sbDAO.selectSeatStatus(screenCode, seatCode);

String result = "예약 불가능";

if(flag){
	result ="예약 가능";
}

out.print("자리 조회 결과 : "+ result);
%>
<hr>
<%
// BookDTO 생성 (book_num은 설정 안 해도 됨!)
BookDTO bookDTO = new BookDTO();
bookDTO.setScreenCode("scc001");
bookDTO.setUsersId("test1");
bookDTO.setTotalBookNum(2);
bookDTO.setBookState("예약중");

// SeatBookDTO 리스트 (seat_book_code도 설정 안 해도 됨!)
List<SeatBookDTO> seatList = new ArrayList<>();

SeatBookDTO seat1 = new SeatBookDTO();
seat1.setSeatCode("st001");
seat1.setScreenCode("scc001");
seat1.setDiscountCode("dc001");
seatList.add(seat1);

SeatBookDTO seat2 = new SeatBookDTO();
seat2.setSeatCode("st002");
seat2.setScreenCode("scc001");
seat2.setDiscountCode("dc002");
seatList.add(seat2);

ReserveDAO dao = ReserveDAO.getInstance();

try {
    // 시퀀스로 자동 생성된 예매번호 반환
    String bookNum = dao.insertBookingTransaction(bookDTO, seatList);
    
    out.println("생성된 예매번호: " + bookNum);  // BN00000001
    
    session.setAttribute("bookNum", bookNum);
    //response.sendRedirect("payment.jsp");
    
} catch (SQLException e) {
    e.printStackTrace();
}
%>