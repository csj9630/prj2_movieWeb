package send.email;


import java.util.Properties;

import javax.mail.Session;

// SendMail 클래스는 teamProject 패키지 또는 동일 패키지에 있어야 합니다.
// 여기서는 import 없이 MailTest 패키지 내에 있다고 가정하고 작성합니다.
// 만약 SendMail이 teamProject 패키지에 있다면: import teamProject.SendMail; 를 추가해야 합니다.
// 현재 이미지에는 SendMail이 MailTest 패키지에 있다고 가정합니다.

public class MailSender {

    // ⭐️ 이제 String(인증번호)을 반환합니다.
	public static String runEmailSend(String recipient, String authCode) { // ⭐️ 인수로 인증번호를 받습니다.
		 
        boolean mailResult = false; 
        
        // 1. 실제 사용할 계정 정보와 내용을 설정합니다.
        String user_name = "testsist29@gmail.com"; 
        String password = "fwqi ereb pwfv rlrk"; 
        
        // 메일 내용 설정: authCode를 content로 사용
        String title = "2GV 비밀번호 찾기 인증 이메일";
        String content = "인증번호는 <b>" + authCode + "</b>입니다."; // ⭐️ HTML 형식으로 변경
        
        String senderName = "관리자"; 
        
        // 2. SendMail 인스턴스 생성
        SendMail sendMail = new SendMail();
        Properties props = new Properties(); 
        
        // 3. Session을 설정하고 메일 전송
        try {
             Session mailSession = sendMail.setting(props, user_name, password, recipient); 

            mailResult = sendMail.goMail(
                mailSession,
                title,
                content,
                user_name, 
                senderName 
            );
        } catch (Exception e) {
             System.err.println("MailSender 실행 중 예상치 못한 예외 발생: " + e.getMessage());
        }

        // ⭐️ 메일 발송 성공 여부 대신 인증번호(authCode)를 반환합니다.
        return mailResult ? authCode : "MAIL_FAIL"; // 성공하면 인증번호, 실패하면 특정 문자열 반환
	}
	
    public static void main(String[] args) {
    }
}