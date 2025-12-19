package seat.booking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;


public class SeatBookDAO {
	private static SeatBookDAO sbDAO;

	private SeatBookDAO() {

	}
	
	public static SeatBookDAO getInstance() {
		if (sbDAO == null) {
			sbDAO = new SeatBookDAO();
		} // end if
		return sbDAO;
	}//getInstance
	
	//빠른 예매 페이지에서 페이지 로딩시 좌석 그리기
	public List<SeatBookDTO> selectAllSeatBook(String screen_code) throws SQLException {
		List<SeatBookDTO> list = new ArrayList<SeatBookDTO>();

		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// 1. JNDI사용객체 생성
			// 2. DataSource 얻기
			// 3. Connection 얻기
			con = dbCon.getConn();
			// 4. 쿼리문생성객체 얻기
			StringBuilder selectSeatBook = new StringBuilder();
			selectSeatBook
			.append("select seat_code")
			.append("from seat_book")
			.append("where screen_code = ?");
			pstmt = con.prepareStatement(selectSeatBook.toString());
			// 5. 바인드변수 값 설정
			int pstmtIdx = 0;
			pstmt.setString(1, screen_code);

			// 6. 조회결과 얻기
			SeatBookDTO sDTO = null;

			rs = pstmt.executeQuery();

			while (rs.next()) {
				sDTO = new SeatBookDTO();
				sDTO.setSeat_code(rs.getString("seat_code"));
				list.add(sDTO);
			} // end while
		} finally {
			// 7. 연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end finally
		return list;
	}// selectAllRestaurant
	
	
}//class
