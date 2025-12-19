package reserve;

import java.util.Date;

/**
 * PAYMENT 테이블 DTO
 */
public class PaymentDTO {
    private String paymentCode;      // 결제 코드
    private int paymentPrice;        // 결제 금액
    private String paymentMethod;    // 결제 수단
    private Date paymentTime;        // 결제 시간
    private String paymentState;     // 결제 상태
    private String bookNum;          // 예매 번호
    
    // 기본 생성자
    public PaymentDTO() {}
    
    // 생성자 (INSERT용)
    public PaymentDTO(String paymentCode, int paymentPrice, String paymentMethod, String bookNum) {
        this.paymentCode = paymentCode;
        this.paymentPrice = paymentPrice;
        this.paymentMethod = paymentMethod;
        this.bookNum = bookNum;
        this.paymentState = "완료"; // 기본값
    }
    
    // 전체 생성자
    public PaymentDTO(String paymentCode, int paymentPrice, String paymentMethod, 
                      Date paymentTime, String paymentState, String bookNum) {
        this.paymentCode = paymentCode;
        this.paymentPrice = paymentPrice;
        this.paymentMethod = paymentMethod;
        this.paymentTime = paymentTime;
        this.paymentState = paymentState;
        this.bookNum = bookNum;
    }
    
    // Getters and Setters
    public String getPaymentCode() { return paymentCode; }
    public void setPaymentCode(String paymentCode) { this.paymentCode = paymentCode; }
    
    public int getPaymentPrice() { return paymentPrice; }
    public void setPaymentPrice(int paymentPrice) { this.paymentPrice = paymentPrice; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public Date getPaymentTime() { return paymentTime; }
    public void setPaymentTime(Date paymentTime) { this.paymentTime = paymentTime; }
    
    public String getPaymentState() { return paymentState; }
    public void setPaymentState(String paymentState) { this.paymentState = paymentState; }
    
    public String getBookNum() { return bookNum; }
    public void setBookNum(String bookNum) { this.bookNum = bookNum; }
    
    @Override
    public String toString() {
        return "PaymentDTO [paymentCode=" + paymentCode + ", paymentPrice=" + paymentPrice + 
               ", paymentMethod=" + paymentMethod + ", paymentState=" + paymentState + 
               ", bookNum=" + bookNum + "]";
    }
}