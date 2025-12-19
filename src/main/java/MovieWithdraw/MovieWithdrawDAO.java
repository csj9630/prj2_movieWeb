package MovieWithdraw;

import java.sql.SQLException;
import java.sql.Date;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import DBConnection.DbConn;

public class MovieWithdrawDAO {
    private static MovieWithdrawDAO wDAO;

    private MovieWithdrawDAO() {
    }

    public static MovieWithdrawDAO getInstance() {
        if (wDAO == null) {
            wDAO = new MovieWithdrawDAO();
        }
        return wDAO;
    }

    public boolean selectLogin(String id, String pass) throws SQLException {
        boolean flag = false;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = db.getConn();
            String sql = "SELECT users_id FROM users WHERE users_id=? AND users_pass=?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, id);
            pstmt.setString(2, pass);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                flag = true;
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return flag;
    }

    public MovieWithdrawDTO selectUser(String id) throws SQLException {
        MovieWithdrawDTO dto = null;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            con = db.getConn();
            String sql = "SELECT users_id, users_name, birth, phone_num, email, users_pass FROM users WHERE users_id=?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new MovieWithdrawDTO();
                dto.setUsers_id(rs.getString("users_id"));
                dto.setUsers_name(rs.getString("users_name"));
                dto.setBirth(rs.getDate("birth"));
                dto.setPhone_num(rs.getString("phone_num"));
                dto.setEmail(rs.getString("email"));
                dto.setUsers_pass(rs.getString("users_pass")); // Need pass for check
            }
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        return dto;
    }

    public int updateUser(MovieWithdrawDTO dto) throws SQLException {
        int cnt = 0;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = db.getConn();
            String sql = "UPDATE users SET email=?, phone_num=? WHERE users_id=?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, dto.getEmail());
            pstmt.setString(2, dto.getPhone_num());
            pstmt.setString(3, dto.getUsers_id());
            cnt = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return cnt;
    }

    public int updatePass(String id, String newPass) throws SQLException {
        int cnt = 0;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = db.getConn();
            String sql = "UPDATE users SET users_pass=? WHERE users_id=?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, newPass);
            pstmt.setString(2, id);
            cnt = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return cnt;
    }

    public int updateActive(String id) throws SQLException {
        int cnt = 0;
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        try {
            con = db.getConn();
            // '비활성' means inactive/withdrawn
            String sql = "UPDATE users SET active='비활성' WHERE users_id=?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, id);
            cnt = pstmt.executeUpdate();
        } finally {
            db.dbClose(null, pstmt, con);
        }
        return cnt;
    }
}
