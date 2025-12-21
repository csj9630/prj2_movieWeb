<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="movie_mypage_book.BookDAO"%>
<%@ page import="reserve.PaymentDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%
    request.setCharacterEncoding("UTF-8");

    // Toss Payments에서 전달받은 파라미터
    String paymentKey = request.getParameter("paymentKey");
    String orderId = request.getParameter("orderId");
    String amount = request.getParameter("amount");
    
    // 우리가 전달한 파라미터
    String bookNum = request.getParameter("bookNum");
    
    // 로그 출력 (서버 콘솔 확인용)
    System.out.println("[PaymentProcess] paymentKey: " + paymentKey);
    System.out.println("[PaymentProcess] orderId: " + orderId);
    System.out.println("[PaymentProcess] amount: " + amount);
    System.out.println("[PaymentProcess] bookNum: " + bookNum);

    boolean isSuccess = false;
    
    if (bookNum != null && !bookNum.isEmpty()) {
        try {
            // 1. BOOK 테이블 상태 업데이트 (결제대기 -> 결제완료)
            BookDAO bookDAO = BookDAO.getInstance();
            int bookResult = bookDAO.updateBookState(bookNum, "결제완료");
            
            // 2. PAYMENT 테이블 상태 업데이트 (결제중 -> 결제완료)
            // PaymentDAO가 없다면 생성 필요, 혹은 BookDAO에서 처리 등 구조에 따름.
            // 앞서 PaymentDAO를 생성했으므로 호출.
            PaymentDAO paymentDAO = PaymentDAO.getInstance();
            int payResult = paymentDAO.updatePaymentState(bookNum, "결제완료");
            
            if (bookResult > 0 && payResult > 0) {
                isSuccess = true;
            } else {
            	System.out.println("[Error] DB Update Failed. Book: " + bookResult + ", Pay: " + payResult);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[Error] Payment Process Exception: " + e.getMessage());
        }
    } else {
    	System.out.println("[Error] bookNum is null or empty.");
    }

    if (isSuccess) {
        // 성공 페이지로 이동
        response.sendRedirect("paymentSuccess.jsp?bookNum=" + bookNum);
    } else {
        // 실패 시 알림 후 메인으로 이동 (또는 실패 페이지)
%>
        <script>
            alert("결제 처리에 실패했습니다. 고객센터에 문의해주세요.");
            location.href = "../../index/index.jsp";
        </script>
<%
    }
%>
