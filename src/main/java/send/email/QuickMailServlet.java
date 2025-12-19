package send.email;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.util.Random; // 난수 생성을 위해 추가

@WebServlet("/quickMail")
public class QuickMailServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        response.setContentType("text/plain;charset=UTF-8"); 
        
        // 1. 화면에서 보낸 이메일 주소 받기
        String email = request.getParameter("email");
        String result = "FAIL"; 
        
        // 2. 난수 (인증번호) 생성
        Random random = new Random();
        String authCode = "";
        for(int i = 0; i < 5; i++) {
            authCode += String.valueOf(random.nextInt(10));
        }

        try {
            // 3. 메일 발송 실행 (생성된 난수 전달)
            // 🚨 MailSender가 인증번호 또는 "MAIL_FAIL"을 반환하도록 수정되었습니다.
            String mailResultCode = MailSender.runEmailSend(email, authCode);
            
            if (mailResultCode.equals(authCode)) { // ⭐️ 메일 발송 성공
                // 4. 세션에 인증번호 저장 (인증 비교를 위해)
                HttpSession session = request.getSession();
                session.setAttribute("authCode", authCode); // ⭐️ 인증번호 저장
                session.setMaxInactiveInterval(3 * 60); // 예: 3분 동안 유효

                result = "OK";
                System.out.println("메일 발송 완료. 인증번호 세션 저장됨: " + authCode);
            } else { // ⭐️ 메일 발송 실패
                result = "MAIL_FAIL";
                System.out.println("메일 발송 실패.");
            }
        
        } catch (Exception e) {
             e.printStackTrace();
             result = "SERVER_ERROR";
        }
        
        // 5. 응답
        response.getWriter().write(result); 
    }
}