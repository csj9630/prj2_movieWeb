package reserve;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import DBConnection.DbConn;

/**
 * PAYMENT 테이블 DAO
 */
public class PaymentDAO {
	private static PaymentDAO pDAO;
	
	private PaymentDAO() {}
	
	public static PaymentDAO getInstance() {
		if(pDAO == null) {
			pDAO = new PaymentDAO();
		}
		return pDAO;
	}
	
	/**
	 * 결제 상태 변경 (결제대기/중 -> 결제완료 등)
	 * @param bookNum 예매 번호 (Payment는 BookNum을 FK로 가짐)
	 * @param state 변경할 상태
	 * @return 성공 여부
	 * @throws SQLException
	 */
	public int updatePaymentState(String bookNum, String state) throws SQLException {
		int result = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			// 해당 예매 번호에 연결된 결제 내역의 상태를 업데이트
			String sql = "UPDATE PAYMENT SET payment_state = ?, payment_time = SYSDATE WHERE book_num = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, state);
			pstmt.setString(2, bookNum);
			
			result = pstmt.executeUpdate();
			
		} finally {
			db.dbClose(null, pstmt, con);
		}
		
		return result;
	}
}
