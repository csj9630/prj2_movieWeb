package movie.movie_admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class MovieDAO {
	private static MovieDAO mDAO;
	
	private MovieDAO() {}
	
	public static MovieDAO getInstance() {
		if(mDAO == null) mDAO = new MovieDAO();
		return mDAO;
	}
	
	/**
	 * 총 영화 수 조회 (삭제되지 않은 영화만)
	 */
	public int selectTotalCount(String keyword) throws SQLException {
		int count = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			sql.append("SELECT count(*) FROM MOVIE WHERE movie_delete = 'F' "); 
			
			if(keyword != null && !keyword.isEmpty()) {
				sql.append(" AND movie_name LIKE '%'||?||'%' ");
			}
			
			pstmt = con.prepareStatement(sql.toString());
			if(keyword != null && !keyword.isEmpty()) {
				pstmt.setString(1, keyword);
			}
			
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return count;
	}
	
	/**
	 * 영화 리스트 조회 (수정됨: 영화코드 오름차순 정렬)
	 */
	public List<MovieDTO> selectMovieList(int startNum, int endNum, String keyword) throws SQLException {
	    List<MovieDTO> list = new ArrayList<>();
	    DbConn db = DbConn.getInstance("jdbc/dbcp");
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    try {
	        con = db.getConn();
	        StringBuilder sql = new StringBuilder();
	        // [수정] running_time 컬럼 추가함
	        sql.append(" SELECT movie_code, movie_name, movie_genre, running_time, release_date, showing, main_image, rnum ")
	           .append(" FROM ( ")
	           .append("    SELECT movie_code, movie_name, movie_genre, running_time, release_date, showing, main_image, ")
	           .append("           ROW_NUMBER() OVER(ORDER BY movie_code ASC) rnum ")
	           .append("    FROM MOVIE ")
	           .append("    WHERE movie_delete = 'F' ");
	        
	        if(keyword != null && !keyword.isEmpty()) {
	            sql.append(" AND movie_name LIKE '%'||?||'%' ");
	        }
	        
	        sql.append(" ) WHERE rnum BETWEEN ? AND ? ");
	        
	        pstmt = con.prepareStatement(sql.toString());
	        int idx = 1;
	        if(keyword != null && !keyword.isEmpty()) {
	            pstmt.setString(idx++, keyword);
	        }
	        pstmt.setInt(idx++, startNum);
	        pstmt.setInt(idx++, endNum);
	        
	        rs = pstmt.executeQuery();
	        
	        while(rs.next()) {
	            MovieDTO mDTO = new MovieDTO();
	            mDTO.setMovieCode(rs.getString("movie_code"));
	            mDTO.setMovieName(rs.getString("movie_name"));
	            mDTO.setMovieGenre(rs.getString("movie_genre"));
	            
	            // [수정] DTO에 running_time 세팅 추가
	            mDTO.setRunningTime(rs.getString("running_time")); 
	            
	            String rDate = rs.getString("release_date");
	            if(rDate != null && rDate.length() > 10) rDate = rDate.substring(0, 10);
	            mDTO.setReleaseDate(rDate);
	            
	            mDTO.setShowing(rs.getString("showing"));
	            mDTO.setMainImage(rs.getString("main_image"));
	            list.add(mDTO);
	        }
	    } finally {
	        db.dbClose(rs, pstmt, con);
	    }
	    return list;
	}
	
	/**
     * 영화 상세 조회 (JOIN을 사용하여 감독, 배우 이름 가져오기)
     */
    public MovieDTO selectMovie(String movieCode) throws SQLException {
        MovieDTO mDTO = null;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = db.getConn();
            StringBuilder sql = new StringBuilder();
            sql.append(" SELECT m.*, ");
            // 오라클 LISTAGG 함수를 사용해 여러명의 감독/배우를 쉼표로 합쳐서 가져옴
            sql.append(" (SELECT LISTAGG(d.director_name, ', ') WITHIN GROUP (ORDER BY d.director_name) ");
            sql.append("  FROM MOVIE_DIRECTOR md JOIN DIRECTOR d ON md.director_code = d.director_code ");
            sql.append("  WHERE md.movie_code = m.movie_code) as directors, ");
            sql.append(" (SELECT LISTAGG(a.actor_name, ', ') WITHIN GROUP (ORDER BY a.actor_name) ");
            sql.append("  FROM CAST c JOIN ACTOR a ON c.actor_code = a.actor_code ");
            sql.append("  WHERE c.movie_code = m.movie_code) as actors ");
            sql.append(" FROM MOVIE m WHERE m.movie_code = ? ");

            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, movieCode);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                mDTO = new MovieDTO();
                mDTO.setMovieCode(rs.getString("movie_code"));
                mDTO.setMovieName(rs.getString("movie_name"));
                mDTO.setMovieGenre(rs.getString("movie_genre"));
                mDTO.setRunningTime(rs.getString("running_time"));
                mDTO.setMovieGrade(rs.getString("movie_grade"));
                
                String rDate = rs.getString("release_date");
                if(rDate != null && rDate.length() > 10) rDate = rDate.substring(0, 10);
                mDTO.setReleaseDate(rDate);
                
                mDTO.setIntro(rs.getString("intro"));
                mDTO.setMainImage(rs.getString("main_image"));
                mDTO.setBgImage(rs.getString("bg_image"));
                mDTO.setDailyAudience(rs.getString("daily_audience"));
                mDTO.setTotalAudience(rs.getString("total_audience"));
                mDTO.setShowing(rs.getString("showing"));
                
                // [DTO에 담기]
                mDTO.setDirectorNames(rs.getString("directors")); // 예: "봉준호, 박찬욱"
                mDTO.setActorNames(rs.getString("actors"));       // 예: "송강호, 이선균"
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return mDTO;
    }

    /**
     * 영화 등록 (트랜잭션 처리 필요)
     */
    public void insertMovie(MovieDTO mDTO) throws SQLException {
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null; // 시퀀스 조회용
        
        try {
            con = db.getConn();
            con.setAutoCommit(false); // 트랜잭션 시작

            // 1. MOVIE 테이블 Insert
            // 시퀀스 값을 먼저 가져와야 MOVIE_DIRECTOR 등에 넣을 수 있음
            String seqSql = "SELECT 'mc' || LPAD(movie_seq.nextval, 3, '0') FROM DUAL";
            pstmt = con.prepareStatement(seqSql);
            rs = pstmt.executeQuery();
            String newMovieCode = "";
            if(rs.next()) newMovieCode = rs.getString(1);
            rs.close(); pstmt.close();

            String sql = "INSERT INTO MOVIE(movie_code, movie_name, movie_genre, running_time, movie_grade, release_date, intro, main_image, bg_image, daily_audience, total_audience, movie_delete, showing) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, '0', '0', 'F', ?)";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, newMovieCode);
            pstmt.setString(2, mDTO.getMovieName());
            pstmt.setString(3, mDTO.getMovieGenre());
            pstmt.setString(4, mDTO.getRunningTime());
            pstmt.setString(5, mDTO.getMovieGrade());
            pstmt.setString(6, mDTO.getReleaseDate());
            pstmt.setString(7, mDTO.getIntro());
            pstmt.setString(8, mDTO.getMainImage());
            pstmt.setString(9, mDTO.getBgImage());
            pstmt.setString(10, mDTO.getShowing());
            pstmt.executeUpdate();
            pstmt.close();

            // 2. 감독 연결 (이름으로 코드 찾아서 MOVIE_DIRECTOR에 Insert)
            insertDirectors(con, newMovieCode, mDTO.getDirectorNames());

            // 3. 배우 연결 (이름으로 코드 찾아서 CAST에 Insert)
            insertActors(con, newMovieCode, mDTO.getActorNames());

            con.commit(); // 성공 시 커밋
        } catch(SQLException e) {
            if(con != null) con.rollback(); // 실패 시 롤백
            throw e;
        } finally {
            if(con != null) con.setAutoCommit(true);
            db.dbClose(rs, pstmt, con);
        }
    }

    /**
     * 영화 수정
     */
    public int updateMovie(MovieDTO mDTO) throws SQLException {
        int cnt = 0;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = db.getConn();
            con.setAutoCommit(false);

            // 1. 영화 기본 정보 수정
            String sql = "UPDATE MOVIE SET movie_name=?, movie_genre=?, running_time=?, movie_grade=?, release_date=?, intro=?, showing=?, main_image=?, bg_image=? WHERE movie_code=?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, mDTO.getMovieName());
            pstmt.setString(2, mDTO.getMovieGenre());
            pstmt.setString(3, mDTO.getRunningTime());
            pstmt.setString(4, mDTO.getMovieGrade());
            pstmt.setString(5, mDTO.getReleaseDate());
            pstmt.setString(6, mDTO.getIntro());
            pstmt.setString(7, mDTO.getShowing());
            pstmt.setString(8, mDTO.getMainImage());
            pstmt.setString(9, mDTO.getBgImage());
            pstmt.setString(10, mDTO.getMovieCode());
            cnt = pstmt.executeUpdate();
            pstmt.close();

            // 2. 기존 감독/배우 연결 삭제 (싹 지우고 다시 등록하는게 가장 깔끔)
            String delDirSql = "DELETE FROM MOVIE_DIRECTOR WHERE movie_code=?";
            pstmt = con.prepareStatement(delDirSql);
            pstmt.setString(1, mDTO.getMovieCode());
            pstmt.executeUpdate();
            pstmt.close();

            String delActorSql = "DELETE FROM CAST WHERE movie_code=?";
            pstmt = con.prepareStatement(delActorSql);
            pstmt.setString(1, mDTO.getMovieCode());
            pstmt.executeUpdate();
            pstmt.close();

            // 3. 새로운 감독/배우 연결
            insertDirectors(con, mDTO.getMovieCode(), mDTO.getDirectorNames());
            insertActors(con, mDTO.getMovieCode(), mDTO.getActorNames());

            con.commit();
        } catch(SQLException e) {
            if(con != null) con.rollback();
            throw e;
        } finally {
            if(con != null) con.setAutoCommit(true);
            db.dbClose(null, pstmt, con);
        }
        return cnt;
    }
    
    // --- [Helper Methods] ---

    // 감독 이름들을 파싱하여 코드를 찾아 저장하는 메소드
    private void insertDirectors(Connection con, String movieCode, String directorNames) throws SQLException {
        if(directorNames == null || directorNames.trim().isEmpty()) return;
        
        String[] names = directorNames.split(",");
        PreparedStatement pstmtFind = null;
        PreparedStatement pstmtIns = null;
        ResultSet rs = null;

        String findSql = "SELECT director_code FROM DIRECTOR WHERE director_name = ?"; // 정확히 일치해야 함
        String insSql = "INSERT INTO MOVIE_DIRECTOR(director_code, movie_code) VALUES(?, ?)";

        try {
            pstmtFind = con.prepareStatement(findSql);
            pstmtIns = con.prepareStatement(insSql);

            for(String name : names) {
                name = name.trim();
                if(name.isEmpty()) continue;

                pstmtFind.setString(1, name);
                rs = pstmtFind.executeQuery();
                if(rs.next()) {
                    String dCode = rs.getString(1);
                    // 매핑 테이블 저장
                    pstmtIns.setString(1, dCode);
                    pstmtIns.setString(2, movieCode);
                    pstmtIns.executeUpdate();
                }
                // (옵션) 만약 DB에 없는 감독이면 넘어가거나, 새로 등록하는 로직 추가 가능
                rs.close();
            }
        } finally {
            if(rs != null) rs.close();
            if(pstmtFind != null) pstmtFind.close();
            if(pstmtIns != null) pstmtIns.close();
        }
    }

    // 배우 이름들을 파싱하여 코드를 찾아 저장하는 메소드
    private void insertActors(Connection con, String movieCode, String actorNames) throws SQLException {
        if(actorNames == null || actorNames.trim().isEmpty()) return;

        String[] names = actorNames.split(",");
        PreparedStatement pstmtFind = null;
        PreparedStatement pstmtIns = null;
        ResultSet rs = null;

        String findSql = "SELECT actor_code FROM ACTOR WHERE actor_name = ?";
        String insSql = "INSERT INTO CAST(actor_code, movie_code) VALUES(?, ?)";

        try {
            pstmtFind = con.prepareStatement(findSql);
            pstmtIns = con.prepareStatement(insSql);

            for(String name : names) {
                name = name.trim();
                if(name.isEmpty()) continue;

                pstmtFind.setString(1, name);
                rs = pstmtFind.executeQuery();
                if(rs.next()) {
                    String aCode = rs.getString(1);
                    pstmtIns.setString(1, aCode);
                    pstmtIns.setString(2, movieCode);
                    pstmtIns.executeUpdate();
                }
                rs.close();
            }
        } finally {
            if(rs != null) rs.close();
            if(pstmtFind != null) pstmtFind.close();
            if(pstmtIns != null) pstmtIns.close();
        }
    }

    // deleteMovie는 기존 코드(movie_delete='T' 업데이트) 그대로 사용하면 됩니다.
    public int deleteMovie(String movieCode) throws SQLException {
		int cnt = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		try {
			con = db.getConn();
			String sql = "UPDATE MOVIE SET movie_delete = 'T' WHERE movie_code = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, movieCode);
			cnt = pstmt.executeUpdate();
		} finally {
			db.dbClose(null, pstmt, con);
		}
		return cnt;
	}
    
 // [추가] 상영 스케줄 등록용 영화 리스트 조회 (상영종료 제외)
    public List<MovieDTO> selectMoviesForSchedule() throws SQLException {
        List<MovieDTO> list = new ArrayList<>();
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = db.getConn();
            StringBuilder sql = new StringBuilder();
            
            // [수정] running_time 컬럼 추가!
            sql.append(" SELECT movie_code, movie_name, showing, running_time ");
            sql.append(" FROM MOVIE ");
            sql.append(" WHERE movie_delete = 'F' ");
            sql.append(" AND showing IN ('상영중', '개봉예정') "); 
            sql.append(" ORDER BY movie_name ASC ");

            pstmt = con.prepareStatement(sql.toString());
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                MovieDTO mDTO = new MovieDTO();
                mDTO.setMovieCode(rs.getString("movie_code"));
                mDTO.setMovieName(rs.getString("movie_name"));
                mDTO.setShowing(rs.getString("showing"));
                
                // [수정] DTO에 러닝타임 세팅
                mDTO.setRunningTime(rs.getString("running_time"));
                
                list.add(mDTO);
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return list;
    }
    
 // 가장 최근에 등록된 영화 코드 조회 (스틸컷 저장을 위해 필요)
    public String selectMaxMovieCode() throws SQLException {
        String code = null;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = db.getConn();
            // 문자열 PK(mc001)라도 MAX 함수는 동작합니다. (mc100이 mc099보다 큼)
            String sql = "SELECT max(movie_code) FROM movie"; 
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                code = rs.getString(1);
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return code;
    }
    
}