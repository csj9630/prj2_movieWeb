package movie.image_admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class AdminImageDAO {
    private static AdminImageDAO dao;
    
    private AdminImageDAO() {}
    
    public static AdminImageDAO getInstance() {
        if (dao == null) dao = new AdminImageDAO();
        return dao;
    }

    /**
     * [추가된 메소드] 영화의 스틸컷 리스트 조회
     */
    public List<AdminImageDTO> selectStillCuts(String movieCode) throws SQLException {
        List<AdminImageDTO> list = new ArrayList<>();
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = db.getConn();
            String sql = "SELECT img_code, img_path, movie_code "
                       + "FROM MOVIE_IMAGE "
                       + "WHERE movie_code = ? "
                       + "ORDER BY img_code ASC"; 
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, movieCode);
            
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                AdminImageDTO dto = new AdminImageDTO();
                dto.setImg_code(rs.getString("img_code"));
                dto.setImg_path(rs.getString("img_path"));
                dto.setMovie_code(rs.getString("movie_code"));
                
                list.add(dto);
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return list;
    }

    /**
     * 스틸컷 1개를 MOVIE_IMAGE 테이블에 저장하는 메소드
     */
    public int insertMovieImage(String imgPath, String movieCode) throws SQLException {
        int cnt = 0;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = db.getConn();
            String sql = "INSERT INTO MOVIE_IMAGE(img_code, img_path, movie_code) "
                       + "VALUES ('img'||LPAD(movie_img_seq.nextval, 3, '0'), ?, ?)";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, imgPath);
            pstmt.setString(2, movieCode);
            
            cnt = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return cnt;
    }

    /**
     * [★신규 추가] 특정 파일명을 가진 스틸컷 삭제 (수정 시 중복 방지용)
     * 예: mc011_still002.jpg가 들어오면 기존 DB에서 해당 파일명 데이터를 삭제함
     */
    public int deleteImageByPath(String imgPath) throws SQLException {
        int cnt = 0;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = db.getConn();
            String sql = "DELETE FROM MOVIE_IMAGE WHERE img_path = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, imgPath);
            cnt = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return cnt;
    }

    /**
     * 영화 수정 시, 기존 스틸컷들을 싹 지우기 위한 메소드
     */
    public int deleteStillCuts(String movieCode) throws SQLException {
        int cnt = 0;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = db.getConn();
            String sql = "DELETE FROM MOVIE_IMAGE WHERE movie_code = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, movieCode);
            cnt = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return cnt;
    }
}