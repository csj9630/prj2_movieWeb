package announcement;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class AnnouncementDAO {

	private static AnnouncementDAO aDAO;
	
	private AnnouncementDAO() {
		
	}
	
	public static AnnouncementDAO getInstance() {
		if(aDAO == null) {
			aDAO = new AnnouncementDAO();
		} // end if
		return aDAO;
	} // getInstance
	
	public int selectAnnounceTotalCnt(RangeDTO rDTO) throws SQLException {
		int totalCnt = 0;
		
		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			// 1. JNDI 사용 객체 생성
			
			// 2. DataSource 얻기
			
			// 3. DataSource에서 Connection 얻기
			con = dbCon.getConn();
			
			// 4. 쿼리문 생성 객체 얻기
			// 검색 키워드가 없다면 모든 글을 총 개수 검색
			StringBuilder selectTotal = new StringBuilder(); 
			selectTotal.append("select count(*) cnt from announce");
			
			// dynamic query: 검색 키워드가 있다면 검색 키워드에 해당하는 글의 개수 검색
			if(rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
				selectTotal
				.append(" where instr(")
				.append(rDTO.getFieldStr())
				.append(", ?) != 0");
			} // end if
			
			pstmt = con.prepareStatement(selectTotal.toString());
			
			// 5. 바인드 변수 값 설정
			if(rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
				pstmt.setString(1, rDTO.getKeyword());
			} // end if
			
			// 6. 쿼리문 수행 후 결과 얻기
			rs = pstmt.executeQuery();
			if(rs.next()) {
				totalCnt = rs.getInt("cnt");
			} // end if
		} finally {
			// 7. 연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end try ~ finally
		
		return totalCnt;
	} // selectAnnounceTotalCnt
	
	public List<AnnouncementDTO> selectRangeAnnouncement(RangeDTO rDTO) throws SQLException {
		List<AnnouncementDTO> list = new ArrayList<AnnouncementDTO>();
		
		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// 1. JDNI사용 객체 생성
			// 2. DataSource 얻기
			// 3. Connection 얻기
			con = dbCon.getConn();
			// 4. 쿼리문 생성 객체 얻기
			StringBuilder selectBoard = new StringBuilder();
			selectBoard
			.append("	select	announce_num, announce_name, announce_date, announce_views					")
			.append("	from	(	select		announce_num, announce_name, announce_date, announce_views,	")
			.append("							row_number() over(order by announce_num desc) rnum			")
			.append("				from		announce													")
			.append("				order by	announce_num desc											");

			// dynamic query: 검색 키워드가 있다면 검색 키워드에 해당하는 글의 개수 검색
			if(rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
				selectBoard
				.append("	where instr(	")
				.append(rDTO.getFieldStr())
				.append("	, ?) != 0		");
			} // end if
			selectBoard
			.append("	)	where		rnum between ? and ?	");
			
			pstmt = con.prepareStatement(selectBoard.toString());
			// 5. 바인드 변수 값 설정
			int pstmtIdx = 0;
			if(rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
				pstmt.setString(++pstmtIdx, rDTO.getKeyword());
			} // end if
			pstmt.setInt(++pstmtIdx, rDTO.getStartNum());
			pstmt.setInt(++pstmtIdx, rDTO.getEndNum());

			// 6. 조회결과 얻기
			AnnouncementDTO bDTO = null;
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				bDTO = new AnnouncementDTO();
				bDTO.setAnnounce_num(rs.getInt("announce_num"));
				bDTO.setAnnounce_name(rs.getString("announce_name"));
				bDTO.setAnnounce_date(rs.getDate("announce_date"));
				bDTO.setAnnounce_views(rs.getInt("announce_views"));
				list.add(bDTO);
			} // end while
		} finally {
			// 7. 연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end finally
		return list;
	} // selectRangeAnnounce
	
	public AnnouncementDTO selectAnnounceDetail(int num) throws SQLException {
		AnnouncementDTO aDTO = null;
		
		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			// 1. JNDI 사용 객체 생성
			// 2. DataSource 얻기
			// 3. DataSource에서 Connection 얻기
			con = dbCon.getConn();
			// 4. 쿼리문 생성 객체 얻기
			StringBuilder selectDetail = new StringBuilder();
			selectDetail
			.append("	select	announce_name, announce_content, announce_date, announce_views	")
			.append("	from	announce														")
			.append("	where	announce_num = ?												");
			
			pstmt = con.prepareStatement(selectDetail.toString());
			// 5. 바인드 변수 값 설정
			pstmt.setInt(1, num);
			// 6. 쿼리문 수행 후 결과 얻기
			rs = pstmt.executeQuery();
			if(rs.next()) {
				aDTO = new AnnouncementDTO();
				aDTO.setAnnounce_name(rs.getString("announce_name"));
				aDTO.setAnnounce_content(rs.getString("announce_content"));
				aDTO.setAnnounce_date(rs.getDate("announce_date"));
				aDTO.setAnnounce_views(rs.getInt("announce_views"));
				
			} // end if
		} finally {
			// 7. 연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end try ~ finally
		
		return aDTO;
	} // selectAnnounceDetail
	
	/**
	 * 게시글을 읽었을 때 announce_views를 증가시킨다.
	 * @param num
	 * @throws SQLException
	 */
	public void updateAnnounceViews(int num) throws SQLException {
		
		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
		
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			// 1. JNDI 사용 객체 생성
			// 2. DataSource 얻기
			// 3. DataSource에서 Connection 얻기
			con = dbCon.getConn();
			// 4. 쿼리문 생성 객체 얻기
			StringBuilder updateAnnounceViews = new StringBuilder();
			updateAnnounceViews
			.append("	update	announce							")
			.append("	set		announce_views = announce_views + 1	")
			.append("	where	announce_num = ?					");
			
			pstmt = con.prepareStatement(updateAnnounceViews.toString());
			// 5. 바인드 변수 값 설정
			pstmt.setInt(1, num);
			// 6. 쿼리문 수행 후 결과 얻기
			pstmt.executeUpdate();
		} finally {
			// 7. 연결 끊기
			dbCon.dbClose(null, pstmt, con);
		} // end try ~ finally
		
	} // updateBoardCnt
	
}
