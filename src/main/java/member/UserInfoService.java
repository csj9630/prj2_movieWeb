package member;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

import kr.co.sist.chipher.DataDecryption;
import kr.co.sist.chipher.DataEncryption;

/*+joinUser(UserDTO) : int // 회원가입
+loginUser(String,String) : UserDTO//로그인
+findUsersId(String, String, String, String) : String // 아이디 찾기
+doubleCheckUserId(String) : boolean//유저 아이디 중복 체크
+findUserPwd(String, String, String, int, String) : boolean // 비밀번호 찾기 ( 비밀번호 변경 실패시 false )
+userDetailPage(String) : UserDTO // 유저 상세 페이지 (나의 무비 스토리, 나의 예매 내역)
+userBooks(String) : UserDTO // 예매내역
+userMovieHistory(String, int) : UserDTO // 나의 무비스토리
+editUserInfo(String) : UserDTO // 내정보 수정
+editUserPass(String userId, String userPass) : int // 사용자 비밀번호 수정
+userWithdrawal(String userId) : int // 회원탈퇴
+checkDormant(String) : char // 사용자 휴먼계정 전환
+checkVerificationCode(int) : boolean // 메일 인증번호 확인 메소드
*/

public class UserInfoService {
	private static UserInfoService uiService;

	private UserInfoService() {
	}// UserInfoService

	public static UserInfoService getInstance() {
		if (uiService == null) {
			uiService = new UserInfoService();
		} // end if
		return uiService;
	}// getInstance

	/**
	 * DB에서 아이디를 조회하여 존재하는 id인지 찾음
	 * 
	 * @param id
	 * @return
	 */
	public boolean searchId(String id) {
		boolean flag = false;

		UserDAO uDAO = UserDAO.getInstance();
		try {
			flag = uDAO.selectId(id);
		} catch (SQLException e) {
			e.printStackTrace();
		} // end catch

		return flag;
	}// searchId

	/**
	 * 회원가입 메소드
	 * 
	 * @param uDTO
	 * @param key
	 * @return
	 */
	public boolean addMember(userDTO uDTO, String key) {

		boolean flag = false;
		UserDAO uDAO = UserDAO.getInstance();

		// 저장될 데이터의 중요도에 따라 일방향 해시, 암호화 처리.
		// null이나 ""는 일방향해시, 암호화를 하면 error 발생.
		if (uDTO.getUsers_pass() != null && !"".equals(uDTO.getUsers_pass())) {
			try {
				uDTO.setUsers_pass((DataEncryption.messageDigest("SHA-1", uDTO.getUsers_pass())));
			} catch (NoSuchAlgorithmException e) {
				e.printStackTrace();
			} // end catch
		} // end if

		// String key="a123456789012345";//키는 반드시 16글자

		DataEncryption de = new DataEncryption(key);
		if (uDTO.getUsers_name() != null && !"".equals(uDTO.getUsers_name())) {
			try {
				System.out.println("유저네임 : " + uDTO.getUsers_name());
				uDTO.setUsers_name(de.encrypt(uDTO.getUsers_name()));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if
		if (uDTO.getEmail() != null && !"".equals(uDTO.getEmail())) {
			try {
				uDTO.setEmail(de.encrypt(uDTO.getEmail()));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if
		if (uDTO.getPhone_num() != null && !"".equals(uDTO.getPhone_num())) {
			try {
				uDTO.setPhone_num(de.encrypt(uDTO.getPhone_num()));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if

		try {
			// 회원 정보 1개
			uDAO.insertMember(uDTO);
			flag = true;
		} catch (SQLException e) {
			e.printStackTrace();
		} // end catch
		return flag;

	}// addMember

	public boolean searchUserId(userDTO uDTO, String key) {
		UserDAO uDAO = UserDAO.getInstance();
		/*
		 * // SiteProperty에 있는 key 가져오기(복호화) String key = SiteProperty.spVO.getKey();
		 * System.out.println("------" + key);
		 */
		// 찾은 아이디를 넣을 변수
		boolean flagId = false;
		DataEncryption de = new DataEncryption(key);
		// 유저 이름, 이메일, 폰번호 암호화 하여 DB데이터와 비교 조회.
		if (uDTO.getUsers_name() != null && !"".equals(uDTO.getUsers_name())) {
			try {
				System.out.println("유저네임2 : " + uDTO.getUsers_name());
				uDTO.setUsers_name(de.encrypt(uDTO.getUsers_name()));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if
		if (uDTO.getEmail() != null && !"".equals(uDTO.getEmail())) {
			try {
				uDTO.setEmail(de.encrypt(uDTO.getEmail()));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if
		if (uDTO.getPhone_num() != null && !"".equals(uDTO.getPhone_num())) {
			try {
				uDTO.setPhone_num(de.encrypt(uDTO.getPhone_num()));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if

		try {
			// id검색 후 결과
			flagId = uDAO.selectUserId(uDTO);
		} catch (SQLException e) {
			e.printStackTrace();
		} // end catch
		return flagId;
	}// searchMember

	// 사용자 정보 확인(비밀번호 변경 시 사용)
	public boolean checkUserPwInfo(userDTO uDTO, String key) {
		// select 결과
		boolean flag = false;

		UserDAO uDAO = UserDAO.getInstance();
		System.out.println("유저 다오 네임 : " + uDTO.getUsers_name());
		System.out.println("유저 다오 메일 : " + uDTO.getEmail());
		DataEncryption de = new DataEncryption(key);
		if (uDTO.getUsers_name() != null && !"".equals(uDTO.getUsers_name())) {
			try {
				uDTO.setUsers_name(de.encrypt(uDTO.getUsers_name()));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if
		if (uDTO.getEmail() != null && !"".equals(uDTO.getEmail())) {
			try {
				uDTO.setEmail(de.encrypt(uDTO.getEmail()));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if
		try {
			//pw찾기에 입력한 데이터 기반으로 DB 조회
			/* flag = uDAO.selectUserPw(uDTO); */
			if (uDAO.selectUserPw(uDTO)) {
				// 검색 결과가 존재한다면 새로운 비밀번호로 update해주기
				if(changePw(uDTO) == 1) {
					//패스워드 변경 선공했으면 true 반환
					return flag=true;
				}//end if
			}//end if
		} catch (SQLException e) {
			e.printStackTrace();
		} // end catch
		return flag;
	}// addMember

	
	//비밀번호 변경 메소드
	public int changePw(userDTO uDTO) {
		UserDAO uDAO = UserDAO.getInstance();
		// 업데이트 결과
		int result = 0;
		// 저장될 데이터의 중요도에 따라 일방향 해시, 암호화 처리.
		// null이나 ""는 일방향해시, 암호화를 하면 error 발생.
		if (uDTO.getUsers_pass() != null && !"".equals(uDTO.getUsers_pass())) {
			try {
				uDTO.setUsers_pass((DataEncryption.messageDigest("SHA-1", uDTO.getUsers_pass())));
			} catch (NoSuchAlgorithmException e) {
				e.printStackTrace();
			} // end catch
		} // end if
		try {
			result = uDAO.updatePw(uDTO);
		} catch (SQLException e) {
			e.printStackTrace();
		}//catch
		return result;
	}//changePw
	
	//로그인메소드
	public userDTO searchLogin( LoginDTO lDTO, String key ) {
		userDTO uDTO = null;
		
		//비밀번호는 일방향 해시
		if(lDTO.getUsers_pass() != null && !lDTO.getUsers_pass().isEmpty()) {
			try {
				lDTO.setUsers_pass(DataEncryption.messageDigest("SHA-1", lDTO.getUsers_pass()));
			} catch (NoSuchAlgorithmException e) {
				e.printStackTrace();
			}//end catch
		}//end if
		
		UserLoginDAO ulDAO = UserLoginDAO.getInstance("jdbc/dbcp");
		try {
			uDTO=ulDAO.selectLogin(lDTO);
			//pDTO에는 아이디, 이름(암호화 > 복호화), 생년월일이 할당
			if (uDTO != null) {
				DataDecryption dd= new DataDecryption(key);//대칭키 : 암호화키와 복호화 키가 같아야 한다.
				try {
					uDTO.setUsers_name(dd.decrypt(uDTO.getUsers_name()));
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return uDTO;
	}//searchLogin
	
	
	
}// class
