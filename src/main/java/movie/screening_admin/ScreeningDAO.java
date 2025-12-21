package movie.screening_admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import DBConnection.DbConn;

public class ScreeningDAO {
	private static ScreeningDAO sDAO;
	
	private ScreeningDAO() {}
	
	public static ScreeningDAO getInstance() {
		if(sDAO == null) sDAO = new ScreeningDAO();
		return sDAO;
	}
	
	/**
	 * 상영 스케줄 목록 조회 (관리자용, 페이징 포함, 삭제된 스케줄 제외)
	 */
	public List<ScreeningDTO> selectScreeningList(int startNum, int endNum, String field, String query) throws SQLException {
		List<ScreeningDTO> list = new ArrayList<>();
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			
			sql.append(" SELECT screen_code, movie_name, theather_name, screen_date, screen_open, rnum ")
			   .append(" FROM ( ")
			   .append("     SELECT si.screen_code, m.movie_name, ti.theather_name, ")
			   .append("            TO_CHAR(si.screen_date, 'YYYY-MM-DD') screen_date, ")
			   .append("            TO_CHAR(si.screen_open, 'HH24:MI') screen_open, ")
			   .append("            ROW_NUMBER() OVER(ORDER BY si.screen_date DESC, si.screen_open ASC) rnum ")
			   .append("     FROM SCREEN_INFO si ")
			   .append("     JOIN MOVIE m ON si.movie_code = m.movie_code ")
			   .append("     JOIN THEATHER_INFO ti ON si.theather_num = ti.theather_num ")
			   
			   // [수정 1] 삭제되지 않은('F') 데이터만 조회하는 기본 조건 추가
			   .append("     WHERE si.screen_delete = 'N' "); 
			
			// [수정 2] 검색어가 있을 경우, 위에서 이미 WHERE를 썼으므로 AND로 연결
			if(query != null && !query.isEmpty()) {
				if("movie".equals(field)) {
					sql.append(" AND m.movie_name LIKE '%'||?||'%' ");
				} else if("theater".equals(field)) {
					sql.append(" AND ti.theather_name LIKE '%'||?||'%' ");
				}
			}
			
			sql.append(" ) WHERE rnum BETWEEN ? AND ? ");
			
			pstmt = con.prepareStatement(sql.toString());
			
			int idx = 1;
			if(query != null && !query.isEmpty()) {
				pstmt.setString(idx++, query);
			}
			pstmt.setInt(idx++, startNum);
			pstmt.setInt(idx++, endNum);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ScreeningDTO dto = new ScreeningDTO();
				dto.setScreenCode(rs.getString("screen_code"));
				dto.setMovieName(rs.getString("movie_name"));
				dto.setTheaterName(rs.getString("theather_name"));
				dto.setScreenDate(rs.getString("screen_date"));
				dto.setScreenTime(rs.getString("screen_open"));
				list.add(dto);
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return list;
	}
	
	/**
	 * 총 게시물 수 조회 (페이징용)
	 */
	public int selectTotalCount(String field, String query) throws SQLException {
		int count = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			
			sql.append(" SELECT count(*) FROM SCREEN_INFO si ")
			   .append(" JOIN MOVIE m ON si.movie_code = m.movie_code ")
			   .append(" JOIN THEATHER_INFO ti ON si.theather_num = ti.theather_num ")
			   .append(" WHERE si.screen_delete = 'N' ");
			
			if(query != null && !query.isEmpty()) {
				if("movie".equals(field)) {
					sql.append(" WHERE m.movie_name LIKE '%'||?||'%' ");
				} else if("theater".equals(field)) {
					sql.append(" WHERE ti.theather_name LIKE '%'||?||'%' ");
				}
			}
			
			pstmt = con.prepareStatement(sql.toString());
			if(query != null && !query.isEmpty()) {
				pstmt.setString(1, query);
			}
			
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
			
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return count;
	}

	/**
	 * 스케줄 상세 조회 (수정 폼용)
	 */
	public ScreeningDTO selectScreeningDetail(String screenCode) throws SQLException {
		ScreeningDTO dto = null;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			sql.append(" SELECT si.screen_code, si.movie_code, si.theather_num, ")
			   .append("        TO_CHAR(si.screen_date, 'YYYY-MM-DD') screen_date, ")
			   .append("        TO_CHAR(si.screen_open, 'HH24:MI') screen_open, ")
			   .append("        m.movie_name, ti.theather_name ")
			   .append(" FROM SCREEN_INFO si ")
			   .append(" JOIN MOVIE m ON si.movie_code = m.movie_code ")
			   .append(" JOIN THEATHER_INFO ti ON si.theather_num = ti.theather_num ")
			   .append(" WHERE si.screen_code = ? ");
			
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, screenCode);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dto = new ScreeningDTO();
				dto.setScreenCode(rs.getString("screen_code"));
				dto.setMovieCode(rs.getString("movie_code"));
				dto.setTheaterNum(rs.getString("theather_num"));
				dto.setScreenDate(rs.getString("screen_date"));
				dto.setScreenTime(rs.getString("screen_open"));
				dto.setMovieName(rs.getString("movie_name"));
				dto.setTheaterName(rs.getString("theather_name"));
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return dto;
	}

	// ==========================================================
	// 2. 등록 기능 (Create)
	// ==========================================================

	public int insertScreening(ScreeningDTO dto) throws SQLException {
	    int cnt = 0;
	    DbConn db = DbConn.getInstance("jdbc/dbcp");
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    
	    try {
	        con = db.getConn();
	        
	        // 1. 중복 체크 (기존 유지)
	        if(isOverlap(con, dto)) {
	            return -1;
	        }
	        
	        // 2. PK 생성 (기존 유지)
	        String newScreenCode = generateNextScreenCode(con);
	        
	        // 3. INSERT 실행 (테이블 구조 반영)
	        StringBuilder sql = new StringBuilder();
	        sql.append(" INSERT INTO SCREEN_INFO ( ")
	           .append("    screen_code, movie_code, theather_num, screen_date, ")
	           .append("    screen_open, screen_end, ")  // 시작/종료 일시
	           .append("    screen_price, screen_delete, screen_showing ") // 가격, 삭제, 상영여부
	           .append(" ) VALUES ( ")
	           .append("    ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ")
	           // [중요] 날짜(screenDate)와 시간(screenTime)을 합쳐서 TO_DATE 처리
	           .append("    TO_DATE(? || ' ' || ?, 'YYYY-MM-DD HH24:MI'), ") // SCREEN_OPEN
	           .append("    TO_DATE(? || ' ' || ?, 'YYYY-MM-DD HH24:MI'), ") // SCREEN_END
	           .append("    ?, 'N', 'Y' ") // PRICE, DELETE='F', SHOWING='Y' (기본값)
	           .append(" ) ");
	        
	        pstmt = con.prepareStatement(sql.toString());
	        
	        int idx = 1;
	        pstmt.setString(idx++, newScreenCode);      // 1. screen_code
	        pstmt.setString(idx++, dto.getMovieCode()); // 2. movie_code
	        pstmt.setString(idx++, dto.getTheaterNum());// 3. theather_num
	        pstmt.setString(idx++, dto.getScreenDate());// 4. screen_date (2025-10-11)
	        
	        // 5. screen_open (날짜 + 시작시간 결합)
	        pstmt.setString(idx++, dto.getScreenDate());
	        pstmt.setString(idx++, dto.getScreenTime());
	        
	        // 6. screen_end (날짜 + 종료시간 결합)
	        pstmt.setString(idx++, dto.getScreenDate());
	        pstmt.setString(idx++, dto.getScreenEndTime());
	        
	        // 7. screen_price	
	        pstmt.setInt(idx++, 15000); // 14000 -> 15000
	        
	        cnt = pstmt.executeUpdate();
	        
	    } finally {
	        db.dbClose(null, pstmt, con);
	    }
	    return cnt;
	}
	
	/**
	 * 영화 코드로 러닝타임(분) 가져오기 (종료 시간 계산용)
	 */
	public int getMovieRuntime(String movieCode) throws SQLException {
		int runtime = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			String sql = "SELECT running_time FROM MOVIE WHERE movie_code = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, movieCode);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				try {
					runtime = Integer.parseInt(rs.getString("running_time"));
				} catch(Exception e) { runtime = 0; }
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return runtime;
	}
	
	/**
	 * 중복 체크 (private helper method)
	 * 해당 날짜, 해당 상영관, 해당 시간에 이미 등록된 스케줄이 있는지 확인
	 */
	private boolean isOverlap(Connection con, ScreeningDTO dto) throws SQLException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean result = false;
		
		try {
			StringBuilder sql = new StringBuilder();
			sql.append(" SELECT count(*) FROM SCREEN_INFO ")
			   .append(" WHERE theather_num = ? ")
			   .append(" AND TO_CHAR(screen_date, 'YYYY-MM-DD') = ? ")
			   .append(" AND TO_CHAR(screen_open, 'HH24:MI') = ? ");
			
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, dto.getTheaterNum());
			pstmt.setString(2, dto.getScreenDate());
			pstmt.setString(3, dto.getScreenTime());
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getInt(1) > 0) result = true; // 중복 있음
			}
		} finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
		}
		return result;
	}
	
	/**
	 * [수정됨] 상영코드 생성기 (DB 조회 후 +1 방식)
	 * 예: scc003 -> scc004
	 */
	private String generateNextScreenCode(Connection con) throws SQLException {
		String newCode = "scc001"; // 데이터가 없을 때 초기값
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			// 가장 큰 screen_code 조회
			String sql = "SELECT MAX(screen_code) FROM SCREEN_INFO";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				String lastCode = rs.getString(1);
				if(lastCode != null && lastCode.length() > 3) {
					// 'scc' 뒤의 숫자 부분만 추출하여 +1
					String prefix = lastCode.substring(0, 3); // "scc"
					String numStr = lastCode.substring(3);    // "003"
					int num = Integer.parseInt(numStr);
					num++;
					
					// 다시 3자리 숫자로 포맷팅 (scc + 004)
					newCode = prefix + String.format("%03d", num);
				}
			}
		} finally {
			if(rs != null) rs.close();
			if(pstmt != null) pstmt.close();
		}
		return newCode;
	}

	// ==========================================================
	// 3. 수정 및 삭제 기능 (Update & Delete)
	// ==========================================================

	/**
	 * 예매 존재 여부 확인 (수정/삭제 전 검증용)
	 */
	public boolean checkBookingExist(String screenCode) throws SQLException {
		boolean isExist = false;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			// 취소(F)되지 않은 유효한 예매가 있는지 확인
			String sql = "SELECT count(*) FROM BOOK WHERE screen_code = ? AND book_state != '결제취소'"; 
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, screenCode);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				if(rs.getInt(1) > 0) isExist = true;
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return isExist;
	}

	/**
	 * 스케줄 정보 수정
	 */
	public int updateScreening(ScreeningDTO dto) throws SQLException {
		int cnt = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			sql.append(" UPDATE SCREEN_INFO ")
			   .append(" SET movie_code=?, theather_num=?, ")
			   .append("     screen_date = TO_DATE(?, 'YYYY-MM-DD'), ")
			   // [핵심] 날짜(YYYY-MM-DD)와 시간(HH:mm)을 합쳐서 업데이트해야 날짜가 꼬이지 않음
			   .append("     screen_open = TO_DATE(? || ' ' || ?, 'YYYY-MM-DD HH24:MI'), ")
			   .append("     screen_end  = TO_DATE(? || ' ' || ?, 'YYYY-MM-DD HH24:MI') ")
			   .append(" WHERE screen_code = ? ");
			
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, dto.getMovieCode());
			pstmt.setString(2, dto.getTheaterNum());
			
			// 3. SCREEN_DATE (날짜만)
			pstmt.setString(3, dto.getScreenDate());
			
			// 4. SCREEN_OPEN (날짜 + 시간)
			pstmt.setString(4, dto.getScreenDate());
			pstmt.setString(5, dto.getScreenTime());
			
			// 5. SCREEN_END (날짜 + 시간) - Service에서 계산된 값
			pstmt.setString(6, dto.getScreenDate());
			pstmt.setString(7, dto.getScreenEndTime());
			
			// 6. PK
			pstmt.setString(8, dto.getScreenCode());
			
			cnt = pstmt.executeUpdate();
			
		} finally {
			db.dbClose(null, pstmt, con);
		}
		return cnt;
	}
	
	/**
	 * 스케줄 삭제 (논리적 삭제: Update)
	 * SCREEN_DELETE -> 'T', SCREEN_SHOWING -> 'N'
	 */
	public int deleteScreening(String screenCode) throws SQLException {
	    int cnt = 0;
	    DbConn db = DbConn.getInstance("jdbc/dbcp");
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    
	    try {
	        con = db.getConn();
	        
	        // StringBuilder를 사용하여 쿼리 작성
	        StringBuilder sql = new StringBuilder();
	        sql.append("UPDATE SCREEN_INFO ");
	        sql.append("SET SCREEN_DELETE = 'T', SCREEN_SHOWING = 'N' ");
	        sql.append("WHERE SCREEN_CODE = ?");
	        
	        // sql.toString()으로 String 변환하여 전달
	        pstmt = con.prepareStatement(sql.toString());
	        pstmt.setString(1, screenCode);
	        
	        cnt = pstmt.executeUpdate();
	        
	    } finally {
	        db.dbClose(null, pstmt, con);
	    }
	    return cnt;
	}
}