package movie;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class MovieDAO {
	private static MovieDAO mDAO;
	
	private MovieDAO() {
		
	}
	
	public static MovieDAO getInstance() {
		if(mDAO==null) {
			mDAO=new MovieDAO();
		}//end if
		
		return mDAO;
	}//getInstance
	
	//좌석 페이지 선택 페이지 이미지 가져오기2
	public String selectMovieByCode(String movie_code) throws SQLException {
		DbConn dbCon=DbConn.getInstance("jdbc/dbcp");
		String img=null;
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			con=dbCon.getConn();
			String selectImg="select main_image from movie where movie_code=?";
			pstmt=con.prepareStatement(selectImg);
			pstmt.setString(1, movie_code);
			
			rs=pstmt.executeQuery();
			if(rs.next()) {
				img=rs.getString("main_image");
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		
		return img;
	}//countAllMovie
	
	//박스오피스 영화 수를 계산
	public int countBoxoffice() throws SQLException {
		int cnt=0;
		DbConn dbCon=DbConn.getInstance("jdbc/dbcp");
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			con=dbCon.getConn();
			String countAll="select count(*) cnt from movie where release_date<sysdate";
			pstmt=con.prepareStatement(countAll);
			
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				cnt=rs.getInt(1);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return cnt;
	}//countAllMovie
	
	//상영예정작 영화 수를 계산
	public int countUpcomming() throws SQLException {
		int cnt=0;
		DbConn dbCon=DbConn.getInstance("jdbc/dbcp");
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			con=dbCon.getConn();
			String countAll="select count(*) cnt from movie where release_date > sysdate";
			pstmt=con.prepareStatement(countAll);
			
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				cnt=rs.getInt(1);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		return cnt;
	}//countAllMovie
	
	//전체 영화 리스트(페이지 네이션 없는)
	public List<MovieDTO> selectAllMovie() throws SQLException {
		List<MovieDTO> allMovieList=new ArrayList<MovieDTO>();
		DbConn dbCon=DbConn.getInstance("jdbc/dbcp");
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			con=dbCon.getConn();
			StringBuilder selectAll=new StringBuilder();
			selectAll
			.append(" SELECT movie_code, main_image, ")
			.append("        CASE REGEXP_SUBSTR(movie_grade, '^(전체|12|15|청소년)') ")
			.append("            WHEN '전체' THEN 'all' ")
			.append("            WHEN '청소년' THEN '19' ")
			.append("            ELSE REGEXP_SUBSTR(movie_grade, '^(전체|12|15|청소년)') ")
			.append("        END AS movie_grade, ")
			.append("        movie_name, release_date ")
			.append(" FROM movie ");
			
			pstmt=con.prepareStatement(selectAll.toString());
			
			rs=pstmt.executeQuery();
			MovieDTO mDTO=null;
			
			while(rs.next()) {
				mDTO=new MovieDTO();
				mDTO.setMoviecode(rs.getString("movie_code"));
				mDTO.setMoviemainimg(rs.getString("main_image"));
				mDTO.setMoviegrade(rs.getString("movie_grade"));
				mDTO.setMoviename(rs.getString("movie_name"));
				mDTO.setMoviereleasedate(rs.getString("release_date"));
				
				allMovieList.add(mDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		
		return allMovieList;
	}//selectAllMovie
	
	//전체 이용가 영화 리스트
	public List<MovieDTO> selectAgeAllMovie() throws SQLException {
		List<MovieDTO> ageAllMovieList=new ArrayList<MovieDTO>();
		DbConn dbCon=DbConn.getInstance("jdbc/dbcp");
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			con=dbCon.getConn();
			StringBuilder selectAll=new StringBuilder();
			selectAll
			.append(" SELECT movie_code, main_image, ")
			.append("        CASE REGEXP_SUBSTR(movie_grade, '^(전체|12|15|청소년)') ")
			.append("            WHEN '전체' THEN 'all' ")
			.append("            WHEN '청소년' THEN '19' ")
			.append("            ELSE REGEXP_SUBSTR(movie_grade, '^(전체|12|15|청소년)') ")
			.append("        END AS movie_grade, ")
			.append("        movie_name, release_date ")
			.append(" FROM movie ")
			.append(" WHERE movie_grade = '전체 이용가' ");
			
			pstmt=con.prepareStatement(selectAll.toString());
			
			rs=pstmt.executeQuery();
			MovieDTO mDTO=null;
			
			while(rs.next()) {
				mDTO=new MovieDTO();
				mDTO.setMoviecode(rs.getString("movie_code"));
				mDTO.setMoviemainimg(rs.getString("main_image"));
				mDTO.setMoviegrade(rs.getString("movie_grade"));
				mDTO.setMoviename(rs.getString("movie_name"));
				mDTO.setMoviereleasedate(rs.getString("release_date"));
				
				ageAllMovieList.add(mDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		
		return ageAllMovieList;
	}//selectAgeAllMovie
	
	//12세 이용가 영화 리스트
	public List<MovieDTO> selectAgeTwelveMovie() throws SQLException {
		List<MovieDTO> ageTwelveList=new ArrayList<MovieDTO>();
		DbConn dbCon=DbConn.getInstance("jdbc/dbcp");
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			con=dbCon.getConn();
			StringBuilder selectAll=new StringBuilder();
			selectAll
			.append("	select movie_code, main_image, REGEXP_SUBSTR(movie_grade, '^(전체|12|15|청소년)') AS movie_grade, movie_name, release_date 	")
			.append("	from movie	")
			.append("	where movie_grade='12세 이용가'	");
			
			pstmt=con.prepareStatement(selectAll.toString());
			
			rs=pstmt.executeQuery();
			MovieDTO mDTO=null;
			
			while(rs.next()) {
				mDTO=new MovieDTO();
				mDTO.setMoviecode(rs.getString("movie_code"));
				mDTO.setMoviemainimg(rs.getString("main_image"));
				mDTO.setMoviegrade(rs.getString("movie_grade"));
				mDTO.setMoviename(rs.getString("movie_name"));
				mDTO.setMoviereleasedate(rs.getString("release_date"));
				
				ageTwelveList.add(mDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		
		return ageTwelveList;
	}//selectAgeTwelveMovie
	
	//15세 이용가 영화 리스트
	public List<MovieDTO> selectAgeFifteenMovie() throws SQLException {
		List<MovieDTO> ageFiftenList=new ArrayList<MovieDTO>();
		DbConn dbCon=DbConn.getInstance("jdbc/dbcp");
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			con=dbCon.getConn();
			StringBuilder selectAll=new StringBuilder();
			selectAll
			.append("	select movie_code, main_image, REGEXP_SUBSTR(movie_grade, '^(전체|12|15|청소년)') AS movie_grade, movie_name, release_date 	")
			.append("	from movie	")
			.append("	where movie_grade='15세 이용가'	");
			
			pstmt=con.prepareStatement(selectAll.toString());
			
			rs=pstmt.executeQuery();
			MovieDTO mDTO=null;
			
			while(rs.next()) {
				mDTO=new MovieDTO();
				mDTO.setMoviecode(rs.getString("movie_code"));
				mDTO.setMoviemainimg(rs.getString("main_image"));
				mDTO.setMoviegrade(rs.getString("movie_grade"));
				mDTO.setMoviename(rs.getString("movie_name"));
				mDTO.setMoviereleasedate(rs.getString("release_date"));
				
				ageFiftenList.add(mDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		
		return ageFiftenList;
	}//selectAgeTwelveMovie
	
	//19세 이용가 영화 리스트
	public List<MovieDTO> selectAgeNineteenMovie() throws SQLException {
		List<MovieDTO> ageNineteenList=new ArrayList<MovieDTO>();
		DbConn dbCon=DbConn.getInstance("jdbc/dbcp");
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try {
			con=dbCon.getConn();
			StringBuilder selectAll=new StringBuilder();
			selectAll
			.append(" SELECT movie_code, main_image, ")
			.append("        CASE REGEXP_SUBSTR(movie_grade, '^(전체|12|15|청소년)') ")
			.append("            WHEN '전체' THEN 'all' ")
			.append("            WHEN '청소년' THEN '19' ")
			.append("            ELSE REGEXP_SUBSTR(movie_grade, '^(전체|12|15|청소년)') ")
			.append("        END AS movie_grade, ")
			.append("        movie_name, release_date ")
			.append(" FROM movie ")
			.append(" WHERE movie_grade = '청소년 관람불가' ");
			
			pstmt=con.prepareStatement(selectAll.toString());
			
			rs=pstmt.executeQuery();
			MovieDTO mDTO=null;
			
			while(rs.next()) {
				mDTO=new MovieDTO();
				mDTO.setMoviecode(rs.getString("movie_code"));
				mDTO.setMoviemainimg(rs.getString("main_image"));
				mDTO.setMoviegrade(rs.getString("movie_grade"));
				mDTO.setMoviename(rs.getString("movie_name"));
				mDTO.setMoviereleasedate(rs.getString("release_date"));
				
				ageNineteenList.add(mDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		
		return ageNineteenList;
	}//selectAgeTwelveMovie

	//전체 영화 리스트(페이지 네이션)
	public List<MovieDTO> selectMoviePage(int currentPage, int size) throws SQLException {
		List<MovieDTO> pageMovieList=new ArrayList<MovieDTO>();
		DbConn dbCon=DbConn.getInstance("jdbc/dbcp");
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		int offset=(currentPage-1) * size;
		
		try {
			con=dbCon.getConn();
			StringBuilder selectPage=new StringBuilder();
			// min.css에 맞춰서 영화 등급 아이콘이 나오게 하기 위해서 sql문에서 정규표현식 사용
			selectPage
			.append(" SELECT m.movie_code, m.main_image, ")
			.append("   CASE REGEXP_SUBSTR(m.movie_grade, '^(전체|12|15|청소년)') ")
			.append("     WHEN '전체'   THEN 'all' ")
			.append("     WHEN '12'     THEN '12' ")
			.append("     WHEN '15'     THEN '15' ")
			.append("     WHEN '청소년' THEN '19' ")
			.append("     ELSE m.movie_grade ")
			.append("   END AS movie_grade, ")
			.append("   m.movie_name, m.release_date, NVL(b.book_rate, 0) AS book_rate ")
			.append(" FROM movie m ")
			.append(" LEFT JOIN book_rate b ")
			.append("   ON b.movie_code = m.movie_code ")
			.append(" WHERE m.release_date < sysdate AND  m.movie_delete ='F' ")
			.append(" ORDER BY NVL(TO_NUMBER(b.book_rate), 0) DESC ")
			.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

			
			pstmt=con.prepareStatement(selectPage.toString());
			pstmt.setInt(1, offset);
			pstmt.setInt(2, size);
			
			rs=pstmt.executeQuery();
			MovieDTO mDTO=null;
			
			while(rs.next()) {
				mDTO=new MovieDTO();
				mDTO.setMoviecode(rs.getString("movie_code"));
				mDTO.setMoviemainimg(rs.getString("main_image"));
				mDTO.setMoviegrade(rs.getString("movie_grade"));
				mDTO.setMoviename(rs.getString("movie_name"));
				mDTO.setMoviereleasedate(rs.getString("release_date"));
				mDTO.setBookrate(rs.getDouble("book_rate"));
				
				pageMovieList.add(mDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		
		return pageMovieList;
	}//selectMoviePage
	
	//상영 예정작 영화 리스트
	public List<MovieDTO> selectUpcommingMoviePage(int currentPage, int size) throws SQLException {
		List<MovieDTO> pageMovieList=new ArrayList<MovieDTO>();
		DbConn dbCon=DbConn.getInstance("jdbc/dbcp");
		
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		int offset=(currentPage-1) * size;
		
		try {
			con=dbCon.getConn();
			StringBuilder selectPage=new StringBuilder();
			selectPage
			.append("    SELECT m.movie_code, m.main_image ")
			.append("         , CASE REGEXP_SUBSTR(m.movie_grade, '^(전체|12|15|청소년)') ")
			.append("             WHEN '전체'   THEN 'all' ")
			.append("             WHEN '12'     THEN '12' ")
			.append("             WHEN '15'     THEN '15' ")
			.append("             WHEN '청소년' THEN '19' ")
			.append("             ELSE m.movie_grade ")
			.append("           END AS movie_grade ")
			.append("         , m.movie_name ")
			.append("         , m.release_date ")
			.append("         , NVL(b.book_rate, 0) AS book_rate ")
			.append("    FROM movie m ")
			.append("    LEFT JOIN book_rate b ")
			.append("        ON b.movie_code = m.movie_code ")
			.append("    WHERE m.release_date > SYSDATE AND  m.movie_delete ='F' ")
			.append("    ORDER BY NVL(TO_NUMBER(b.book_rate), 0) DESC ")
			.append("    OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");

			pstmt=con.prepareStatement(selectPage.toString());
			pstmt.setInt(1, offset);
			pstmt.setInt(2, size);
			
			rs=pstmt.executeQuery();
			MovieDTO mDTO=null;
			
			while(rs.next()) {
				mDTO=new MovieDTO();
				mDTO.setMoviecode(rs.getString("movie_code"));
				mDTO.setMoviemainimg(rs.getString("main_image"));
				mDTO.setMoviegrade(rs.getString("movie_grade"));
				mDTO.setMoviename(rs.getString("movie_name"));
				mDTO.setMoviereleasedate(rs.getString("release_date"));
				mDTO.setBookrate(rs.getDouble("book_rate"));
				
				pageMovieList.add(mDTO);
			}
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		}
		
		return pageMovieList;
	}//selectReleaseMoviePage
	
}//class