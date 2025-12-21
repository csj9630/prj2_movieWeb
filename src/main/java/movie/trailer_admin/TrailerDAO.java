package movie.trailer_admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class TrailerDAO {
    // ------싱글톤 패턴------------------------
    private static TrailerDAO trDAO;

    private TrailerDAO() {}

    public static TrailerDAO getInstance() {
        if (trDAO == null) {
            trDAO = new TrailerDAO();
        }
        return trDAO;
    }
    // --------------------------싱글톤 패턴----

    // [기존 팀원 코드: 조회]
    public List<TrailerDTO> selectTrailer(String code) throws SQLException {
        List<TrailerDTO> list = new ArrayList<TrailerDTO>();
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dbCon.getConn();
            StringBuilder selectTrailer = new StringBuilder();
            selectTrailer.append(" select trailer_code, url_path, movie_code ")
                         .append(" from TRAILER ")
                         .append(" where movie_code=? ");

            pstmt = con.prepareStatement(selectTrailer.toString());
            pstmt.setString(1, code);

            rs = pstmt.executeQuery();
            
            TrailerDTO trDTO = null;
            while (rs.next()) {
                trDTO = new TrailerDTO();
                trDTO.setTrailer_code(rs.getString("trailer_code"));
                trDTO.setUrl_path(rs.getString("url_path"));
                trDTO.setMovie_code(rs.getString("movie_code"));
                list.add(trDTO);
            } 
        } finally {
            dbCon.dbClose(rs, pstmt, con);
        }
        return list;
    }
    
    // [★추가된 코드: 트레일러 등록]
    public int insertTrailer(String urlPath, String movieCode) throws SQLException {
        int cnt = 0;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = db.getConn();
            // SQL 파일 시퀀스: trailer_seq
            // PK 형식: tc001, tc002 ...
            String sql = "INSERT INTO TRAILER(trailer_code, url_path, movie_code) "
                       + "VALUES ('tc'||LPAD(trailer_seq.NEXTVAL, 3, '0'), ?, ?)";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, urlPath);
            pstmt.setString(2, movieCode);
            
            cnt = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return cnt;
    }

    // [★추가된 코드: 트레일러 삭제]
    public int deleteTrailers(String movieCode) throws SQLException {
        int cnt = 0;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = db.getConn();
            String sql = "DELETE FROM TRAILER WHERE movie_code = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, movieCode);
            cnt = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return cnt;
    }
}