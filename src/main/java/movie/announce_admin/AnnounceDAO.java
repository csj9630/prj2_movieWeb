package movie.announce_admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class AnnounceDAO {
	private static AnnounceDAO aDAO;
	
	private AnnounceDAO() {}
	
	public static AnnounceDAO getInstance() {
		if(aDAO == null) aDAO = new AnnounceDAO();
		return aDAO;
	}
	
	/**
	 * 공지 목록 조회 (페이징 + 검색)
	 */
	public List<AnnounceDTO> selectAnnounceList(int startNum, int endNum, String field, String query) throws SQLException {
		List<AnnounceDTO> list = new ArrayList<>();
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			
			sql.append(" SELECT announce_num, announce_name, announce_views, announce_date, admin_id, rnum ")
			   .append(" FROM ( ")
			   .append("    SELECT announce_num, announce_name, announce_views, announce_date, admin_id, ")
			   .append("           ROW_NUMBER() OVER(ORDER BY announce_num DESC) rnum ")
			   .append("    FROM ANNOUNCE ");
			
			if(query != null && !query.isEmpty()) {
				if("title".equals(field)) {
					sql.append(" WHERE announce_name LIKE '%'||?||'%' ");
				} else if("content".equals(field)) {
					sql.append(" WHERE announce_content LIKE '%'||?||'%' ");
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
				AnnounceDTO dto = new AnnounceDTO();
				dto.setAnnounceNum(rs.getInt("announce_num"));
				dto.setAnnounceName(rs.getString("announce_name"));
				dto.setAnnounceViews(rs.getInt("announce_views"));
				dto.setAnnounceDate(rs.getDate("announce_date"));
				dto.setAdminId(rs.getString("admin_id"));
				
				list.add(dto);
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return list;
	}
	
	/**
	 * 총 게시물 수
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
			sql.append(" SELECT count(*) FROM ANNOUNCE ");
			
			if(query != null && !query.isEmpty()) {
				if("title".equals(field)) {
					sql.append(" WHERE announce_name LIKE '%'||?||'%' ");
				} else if("content".equals(field)) {
					sql.append(" WHERE announce_content LIKE '%'||?||'%' ");
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
	 * 공지 등록 (SEQ_ANNOUNCE 사용)
	 */
	public int insertAnnounce(AnnounceDTO dto) throws SQLException {
		int cnt = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			// views는 0, date는 sysdate, admin_id는 DTO에서 가져옴
			String sql = "INSERT INTO ANNOUNCE(announce_num, announce_name, announce_content, announce_views, announce_date, admin_id) "
					   + "VALUES (SEQ_ANNOUNCE.NEXTVAL, ?, ?, 0, SYSDATE, ?)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, dto.getAnnounceName());
			pstmt.setString(2, dto.getAnnounceContent());
			pstmt.setString(3, dto.getAdminId()); // 보통 'admin' 고정 혹은 세션값
			
			cnt = pstmt.executeUpdate();
		} finally {
			db.dbClose(null, pstmt, con);
		}
		return cnt;
	}
	
	/**
	 * 상세 조회 + 조회수 증가
	 */
	public AnnounceDTO selectAnnounceDetail(int announceNum) throws SQLException {
		AnnounceDTO dto = null;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			
			// 1. 조회수 증가
			String updateSql = "UPDATE ANNOUNCE SET announce_views = announce_views + 1 WHERE announce_num = ?";
			pstmt = con.prepareStatement(updateSql);
			pstmt.setInt(1, announceNum);
			pstmt.executeUpdate();
			pstmt.close();
			
			// 2. 상세 조회
			String selectSql = "SELECT * FROM ANNOUNCE WHERE announce_num = ?";
			pstmt = con.prepareStatement(selectSql);
			pstmt.setInt(1, announceNum);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dto = new AnnounceDTO();
				dto.setAnnounceNum(rs.getInt("announce_num"));
				dto.setAnnounceName(rs.getString("announce_name"));
				dto.setAnnounceContent(rs.getString("announce_content"));
				dto.setAnnounceViews(rs.getInt("announce_views"));
				dto.setAnnounceDate(rs.getDate("announce_date"));
				dto.setAdminId(rs.getString("admin_id"));
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return dto;
	}
	
	/**
	 * 공지 수정
	 */
	public int updateAnnounce(AnnounceDTO dto) throws SQLException {
		int cnt = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			String sql = "UPDATE ANNOUNCE SET announce_name=?, announce_content=? WHERE announce_num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, dto.getAnnounceName());
			pstmt.setString(2, dto.getAnnounceContent());
			pstmt.setInt(3, dto.getAnnounceNum());
			
			cnt = pstmt.executeUpdate();
		} finally {
			db.dbClose(null, pstmt, con);
		}
		return cnt;
	}
	
	/**
	 * 공지 삭제
	 */
	public int deleteAnnounce(int announceNum) throws SQLException {
		int cnt = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			String sql = "DELETE FROM ANNOUNCE WHERE announce_num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, announceNum);
			cnt = pstmt.executeUpdate();
		} finally {
			db.dbClose(null, pstmt, con);
		}
		return cnt;
	}
}