package MovieWithdraw;

import java.sql.SQLException;

public class MovieWithdrawService {
    private static MovieWithdrawService service;

    private MovieWithdrawService() {
    }

    public static MovieWithdrawService getInstance() {
        if (service == null) {
            service = new MovieWithdrawService();
        }
        return service;
    }

    public boolean loginCheck(String id, String pass) {
        MovieWithdrawDAO dao = MovieWithdrawDAO.getInstance();
        try {
            return dao.selectLogin(id, pass);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public MovieWithdrawDTO getUserInfo(String id) {
        MovieWithdrawDAO dao = MovieWithdrawDAO.getInstance();
        try {
            return dao.selectUser(id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUserInfo(MovieWithdrawDTO dto) {
        MovieWithdrawDAO dao = MovieWithdrawDAO.getInstance();
        try {
            return dao.updateUser(dto) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePassword(String id, String newPass) {
        MovieWithdrawDAO dao = MovieWithdrawDAO.getInstance();
        try {
            // 여기서 암호화 로직(DataEncryption)을 탈 수 있음. 현재는 Mock.
            return dao.updatePass(id, newPass) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean withdrawUser(String id) {
        MovieWithdrawDAO dao = MovieWithdrawDAO.getInstance();
        try {
            return dao.updateActive(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
