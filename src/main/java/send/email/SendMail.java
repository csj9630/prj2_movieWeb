package send.email;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class SendMail {

    final String ENCODING = "UTF-8";
    final String PORT = "587"; // TLS 포트
    final String SMTPHOST = "smtp.gmail.com";
    String TO = ""; // 수신자 이메일 주소를 임시 저장할 필드

    /**
     * Session 셋팅
     * @param props Properties 객체
     * @param user_name 발신자 이메일 주소
     * @param password 앱 비밀번호
     * @param TO 최종 수신자 이메일 주소 (클래스 내부 필드에 저장됨)
     * @return 설정된 Session 객체
     */
    public Session setting(Properties props, String user_name, String password, String TO) {
        
        Session session = null;
        this.TO = TO; // 수신자 주소를 필드에 저장
        
        try {
            // 메일 전송 프로토콜 설정
            props.put("mail.transport.protocol", "smtp");
            
            // SMTP 호스트 및 포트 설정
            props.put("mail.smtp.host", SMTPHOST);
            props.put("mail.smtp.port", PORT);
            
            // 인증 및 TLS 설정 (587 포트 사용 표준 설정)
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.ssl.enable", "false"); // TLS이므로 SSL은 비활성화
            props.put("mail.smtp.starttls.enable", "true"); // TLS 사용
            props.put("mail.smtp.ssl.trust", SMTPHOST);
            
            // SSL Handshake 오류 방지를 위한 프로토콜 명시
            props.put("mail.smtp.ssl.protocols", "TLSv1.2"); 
            
            // 세션 인스턴스 생성 및 인증 정보 설정
            session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(user_name, password);
                }
            });
            
            // 디버그 모드 활성화 (선택 사항: 서버 로그 상세 확인용)
            // session.setDebug(true);

        } catch (Exception e) {
            System.out.println("Session Setting 실패");
            e.printStackTrace();
            // 에러가 발생하면 session은 null로 반환됨
        }
        
        return session;
    }

    /**
     * 메시지 세팅 후 메일 전송
     * @param session 설정된 Session 객체
     * @param title 메일 제목
     * @param content 메일 내용 (인증번호)
     * @param senderEmail 발신자 이메일 주소
     * @param senderName 발신자 이름
     * @return 메일 전송 성공 시 true, 실패 시 false 반환 (⭐️ 수정됨)
     */
    public boolean goMail(Session session, String title, String content, String senderEmail, String senderName) {
        
        if (session == null) {
            System.out.println("메일 전송 실패: Session이 유효하지 않습니다.");
            return false; // 세션 무효 시 실패
        }

        Message msg = new MimeMessage(session);
        try {
            // 발신자 설정
            msg.setFrom(new InternetAddress(senderEmail, senderName, ENCODING)); 
            
            // 수신자 설정 (필드에 저장된 TO 사용)
            msg.addRecipient(Message.RecipientType.TO, new InternetAddress(TO));
            
            // 제목 및 내용 설정
            msg.setSubject(title);
            msg.setContent(content, "text/html; charset=" + ENCODING);

            Transport.send(msg); // 메일 전송
            
            System.out.println("메일 보내기 성공");
            return true; // ⭐️ 성공 시 true 반환
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("메일 보내기 실패");
            return false; // ⭐️ 실패 시 false 반환
        }
    }
}