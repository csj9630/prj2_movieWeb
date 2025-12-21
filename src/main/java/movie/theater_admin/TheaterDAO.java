package movie.theater_admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class TheaterDAO {
	private static TheaterDAO tDAO;
	
	private TheaterDAO() {
	}
	
	public static TheaterDAO getInstance() {
		if(tDAO == null) tDAO = new TheaterDAO();
		return tDAO;
	}
	
	/**
	 * 상영관 총 개수 조회
	 */
	public int selectTotalCount() throws SQLException {
		int count = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			String sql = "SELECT count(*) FROM THEATHER_INFO";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return count;
	}
	
	/**
	 * 상영관 리스트 조회
	 */
	public List<TheaterDTO> selectTheaterList(int startNum, int endNum) throws SQLException {
		List<TheaterDTO> list = new ArrayList<TheaterDTO>();
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			// THEATHER_INFO에 SOUND_CODE가 있고, SOUND 테이블과 조인
			sql.append(" SELECT theather_num, theather_name, total_seat, availability, sound_name, rnum ")
			   .append(" FROM ( ")
			   .append("    SELECT t.theather_num, t.theather_name, t.total_seat, t.availability, s.sound_name, ")
			   .append("           ROW_NUMBER() OVER(ORDER BY t.theather_num ASC) rnum ")
			   .append("    FROM THEATHER_INFO t ")
			   .append("    LEFT JOIN SOUND s ON t.sound_code = s.sound_code ")
			   .append(" ) WHERE rnum BETWEEN ? AND ? ");
			
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setInt(1, startNum);
			pstmt.setInt(2, endNum);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				TheaterDTO tDTO = new TheaterDTO();
				tDTO.setTheatherNum(rs.getString("theather_num"));
				tDTO.setTheatherName(rs.getString("theather_name"));
				tDTO.setTotalSeat(rs.getInt("total_seat"));
				// DB 값 'T'/'F' 공백 제거 후 저장
				String av = rs.getString("availability");
				tDTO.setAvailability(av == null ? "F" : av.trim());
				tDTO.setSoundName(rs.getString("sound_name"));
				list.add(tDTO);
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return list;
	}
	
	/**
	 * 상영관 상세 조회 (1건) - 수정폼용
	 */
	public TheaterDTO selectTheater(String theatherNum) throws SQLException {
		TheaterDTO tDTO = null;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			sql.append(" SELECT t.theather_num, t.theather_name, t.total_seat, t.availability, s.sound_name, t.sound_code ")
			   .append(" FROM THEATHER_INFO t ")
			   .append(" LEFT JOIN SOUND s ON t.sound_code = s.sound_code ")
			   .append(" WHERE t.theather_num = ? ");
			
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, theatherNum);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				tDTO = new TheaterDTO();
				tDTO.setTheatherNum(rs.getString("theather_num"));
				tDTO.setTheatherName(rs.getString("theather_name"));
				tDTO.setTotalSeat(rs.getInt("total_seat"));
				
				String av = rs.getString("availability");
				tDTO.setAvailability(av == null ? "F" : av.trim());
				
				// 수정 페이지에서 select box 선택을 위해 sound_code도 저장
				tDTO.setSoundCode(rs.getString("sound_code"));
				tDTO.setSoundName(rs.getString("sound_name"));
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return tDTO;
	}
	
	/**
	 * [트랜잭션] 상영관 등록
	 */
	public void insertTheater(TheaterDTO tDTO) throws SQLException {
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			con.setAutoCommit(false); // 트랜잭션 시작
			
			// 1. 상영관 정보 Insert
			// sound_code를 직접 넣습니다. (tn001 등)
			String insertInfo = "INSERT INTO THEATHER_INFO(theather_num, theather_name, total_seat, availability, cinema_num, sound_code) VALUES (?, ?, ?, ?, ?, ?)";
			pstmt = con.prepareStatement(insertInfo);
			pstmt.setString(1, tDTO.getTheatherNum());
			pstmt.setString(2, tDTO.getTheatherName());
			pstmt.setInt(3, 100); 
			pstmt.setString(4, tDTO.getAvailability()); // 'T' or 'F'
			pstmt.setString(5, "cn001"); // 고정값
			pstmt.setString(6, tDTO.getSoundCode()); // 화면에서 넘어온 코드
			pstmt.executeUpdate();
			pstmt.close();
			
			// 2. 좌석 100개 자동 생성 Insert
			String insertSeat = "INSERT INTO SEAT(seat_code, seat_row, seat_col, theather_num) VALUES (?, ?, ?, ?)";
			pstmt = con.prepareStatement(insertSeat);
			
			char[] rows = {'A','B','C','D','E','F','G','H','I','J'};
			for(char r : rows) {
				for(int c=1; c<=10; c++) {
					String seatCode = tDTO.getTheatherNum() + "-" + r + c;
					pstmt.setString(1, seatCode);
					pstmt.setString(2, String.valueOf(r));
					pstmt.setString(3, String.valueOf(c)); // DB 컬럼이 VARCHAR2
					pstmt.setString(4, tDTO.getTheatherNum());
					pstmt.addBatch();
				}
			}
			pstmt.executeBatch();
			
			con.commit();
		} catch(SQLException e) {
			if(con != null) con.rollback();
			throw e;
		} finally {
			if(con != null) con.setAutoCommit(true);
			db.dbClose(null, pstmt, con);
		}
	}
	
	/**
	 * 상영관 정보 수정
	 */
	public int updateTheater(TheaterDTO tDTO) throws SQLException {
		int cnt = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			String updateInfo = "UPDATE THEATHER_INFO SET theather_name=?, availability=?, sound_code=? WHERE theather_num=?";
			pstmt = con.prepareStatement(updateInfo);
			pstmt.setString(1, tDTO.getTheatherName());
			pstmt.setString(2, tDTO.getAvailability());
			pstmt.setString(3, tDTO.getSoundCode());
			pstmt.setString(4, tDTO.getTheatherNum());
			cnt = pstmt.executeUpdate();
		} finally {
			db.dbClose(null, pstmt, con);
		}
		return cnt;
	}
	
	/**
	 * 좌석 상태 목록 조회
	 */
	public List<SeatDTO> selectSeatList(String theatherNum) throws SQLException {
		List<SeatDTO> list = new ArrayList<>();
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			String sql = "SELECT seat_code, seat_row, seat_col FROM SEAT WHERE theather_num=? ORDER BY seat_code";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, theatherNum);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				SeatDTO sDTO = new SeatDTO();
				sDTO.setSeatCode(rs.getString("seat_code"));
				sDTO.setSeatRow(rs.getString("seat_row"));
				sDTO.setSeatCol(rs.getString("seat_col"));
				
				list.add(sDTO);
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return list;
	}
	
//	/**
//	 * 좌석 상태 개별 변경
//	 */
//	public int updateSeatStatus(String seatCode, String status) throws SQLException {
//		int cnt = 0;
//		DbConn db = DbConn.getInstance("jdbc/dbcp");
//		Connection con = null;
//		PreparedStatement pstmt = null;
//		
//		try {
//			con = db.getConn();
//			String sql = "UPDATE SEAT SET available_seat=? WHERE seat_code=?";
//			pstmt = con.prepareStatement(sql);
//			pstmt.setString(1, status); // 'T' or 'F'
//			pstmt.setString(2, seatCode);
//			cnt = pstmt.executeUpdate();
//		} finally {
//			db.dbClose(null, pstmt, con);
//		}
//		return cnt;
//	}
	
	/**
	 * 상영관 상태 변경 (비활성화 등)
	 */
	public int updateTheaterStatus(String theatherNum, String status) throws SQLException {
		int cnt = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		try {
			con = db.getConn();
			String sql = "UPDATE THEATHER_INFO SET availability=? WHERE theather_num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, status); // 'T' or 'F'
			pstmt.setString(2, theatherNum);
			cnt = pstmt.executeUpdate();
		} finally {
			db.dbClose(null, pstmt, con);
		}
		return cnt;
	}
}