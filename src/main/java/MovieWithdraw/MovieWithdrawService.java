package MovieWithdraw;

import kr.co.sist.chipher.DataDecryption;
import SiteProperty.SitePropertyVO;
import java.sql.SQLException;
import java.security.NoSuchAlgorithmException;
import kr.co.sist.chipher.DataEncryption;

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
    	// 비밀번호 암호화 (SHA-1)
    	if(pass != null && !pass.isEmpty()) {
    		try {
				pass = DataEncryption.messageDigest("SHA-1", pass);
			} catch (NoSuchAlgorithmException e) {
				e.printStackTrace();
			}
    	}
    	
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
        MovieWithdrawDTO dto = null;
        try {
            dto = dao.selectUser(id);
            // 복호화 (이메일, 휴대폰 번호)
			if (dto != null) {
				SitePropertyVO sp = new SitePropertyVO();
				String key = sp.getKey();
				DataDecryption dd = new DataDecryption(key);
				try {
					if (dto.getEmail() != null) {
						dto.setEmail(dd.decrypt(dto.getEmail()));
					}
					if (dto.getPhone_num() != null) {
						dto.setPhone_num(dd.decrypt(dto.getPhone_num()));
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dto;
    }

    public boolean updateUserInfo(MovieWithdrawDTO dto) {
		// 암호화 로직 추가
		SitePropertyVO sp = new SitePropertyVO();
		String key = sp.getKey();
		DataEncryption de = new DataEncryption(key);
		
		try {
			if(dto.getEmail() != null && !dto.getEmail().isEmpty()) {
				dto.setEmail(de.encrypt(dto.getEmail()));
			}
			if(dto.getPhone_num() != null && !dto.getPhone_num().isEmpty()) {
				dto.setPhone_num(de.encrypt(dto.getPhone_num()));
			}
		} catch (Exception e1) {
			e1.printStackTrace();
		}

		MovieWithdrawDAO dao = MovieWithdrawDAO.getInstance();
		try {
			return dao.updateUser(dto) > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

    public int updatePassword(String id, String newPass) {
    	// 비밀번호 암호화 (SHA-1)
    	String hashedPass = "";
    	if(newPass != null && !newPass.isEmpty()) {
    		try {
    			hashedPass = DataEncryption.messageDigest("SHA-1", newPass);
			} catch (NoSuchAlgorithmException e) {
				e.printStackTrace();
			}
    	}
    	
        MovieWithdrawDAO dao = MovieWithdrawDAO.getInstance();
        try {
        	// 기존 비밀번호 확인 (중복 방지)
        	MovieWithdrawDTO userInfo = dao.selectUser(id);
        	if(userInfo != null) {
        		String currentPass = userInfo.getUsers_pass();
        		if(currentPass != null && currentPass.equals(hashedPass)) {
        			return -1; // 기존 비밀번호와 동일함
        		}
        	}
        	
            // 변경 진행
        	return dao.updatePass(id, hashedPass); // 성공 시 1, 실패 시 0
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // SQL 오류 등실패
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
