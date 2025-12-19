package member;
	
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import DBConnection.DbConn;
	
	
	/*+selectOneUser(String) : UserDTO // 사용자 한명 검색 
	+selectUserList() : List<UserDTO> // 모든 사용자 검색 
	+insertUser(UsersDTO) : int // 사용자 추가
	+updateUser(UsersDTO) : int  // 사용자 정보 변경
	+selectMovieHistory(String, int) : List<UserDTO) // 무비스토리 원하는 년도 기준으로 구하기
	+updateActive(String) : int // 사용자 활성화 여부 변경
	+selectDormantList(Char): UserDTO // 휴면 사용자 검색
	+selectDoubleCheckId(String) : String //아이디 중복체크
	+insertVerificationCodel(int) : int //메일 인증번호 테이블에 삽입
	+selectLogin(String,String) :UserDTO //로그인 
	*/
	public class UserDAO {
		private static UserDAO mDAO;
		
		private UserDAO() {
		}
		
		public static UserDAO getInstance() {
			if(mDAO == null) {
				mDAO = new UserDAO();
			}//end if
			return mDAO;
		}//getInstance
		
		/**
		 * 사용자 ID 검색(중복체크 등에 사용)
		 * @param id
		 * @return
		 * @throws SQLException
		 */
		public boolean selectId(String id) throws SQLException {
			boolean resultFlag=false; 
			
			DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			
			try {
			//1.JNDI 사용객체 생성
			//2.DataSource 얻기
			//3.DataSource에서 Connection 얻기
				con=dbCon.getConn();//1,2,3번 끝.
				System.out.println("con : "+ "con");
			//4.쿼리문 생성객체 얻기
				String selectId="select users_id from users where users_id=?";
				pstmt=con.prepareStatement(selectId);
			//5.바인드변수 값 설정
				pstmt.setString(1, id);
			//6.쿼리문 수행 후 결과 얻기
				rs=pstmt.executeQuery();
				
				resultFlag=!rs.next();//아이디가 존재하면 true - 사용불가, 아이디가 존재하지 않으면 false - 사용가능.
			}finally {
			//7.연결 끊기.
				dbCon.dbClose(rs, pstmt, con);
			}//end finally
			return resultFlag;
			
		}//selectId
		
		/**
		 * 유저 회원가입
		 * @param pDTO
		 * @throws SQLException
		 */
		public void insertMember(userDTO uDTO) throws SQLException {
			DbConn db = DbConn.getInstance("jdbc/dbcp");
	
			Connection con = null;
			PreparedStatement pstmt = null;
			
			try {
				// 1. JNDI사용객체 생성
				// 2. DBCP에서 DataSource 얻기
				// 3. DataSource에서 Connection 얻기
				con = db.getConn();
				// 4. 쿼리문 생성객체 얻기
				String insertmMember = "insert into USERS(USERS_ID, USERS_PASS, EMAIL, USERS_NAME, BIRTH, GENDER,RECENT_LOGIN, JOIN_DATE, ACTIVE, PHONE_NUM) "
						+ "values(?, ?, ?, ?, ?,?,sysdate, sysdate, '활성',?)";
				pstmt = con.prepareStatement(insertmMember);
				// 5. 바인드 변수 값 설정
				pstmt.setString(1, uDTO.getUsers_id());
				pstmt.setString(2, uDTO.getUsers_pass());
				pstmt.setString(3, uDTO.getEmail());
				pstmt.setString(4, uDTO.getUsers_name());
				pstmt.setString(5, uDTO.getBirth());
				/* pstmt.setDate(5, sqlBirth); */
				pstmt.setString(6, uDTO.getGender());
				pstmt.setString(7, uDTO.getPhone_num());
				// 6. 쿼리문 수행 후 결과 얻기
				pstmt.executeUpdate();
			} finally {
				// 7. 연결 끊기
				db.dbClose(null, pstmt, con);
			} // end finally
	
		}// insertMember
		
		//유저 id 찾기 할 때, 입력받은 데이터가 DB에 존재하는지 검사
		public boolean selectUserId(userDTO uDTO) throws SQLException {
			boolean resultFlag=false; 
			DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
			//1.JNDI 사용객체 생성
			//2.DataSource 얻기
			//3.DataSource에서 Connection 얻기
				con=dbCon.getConn();//1,2,3번 끝.
				System.out.println("con : "+ "con");
			//4.쿼리문 생성객체 얻기
				String selectId="select users_id "
						+ "from users "
						+ "where users_name=? and email=? "
						+ "and birth=TO_DATE(?, 'YYYY-MM-DD') and phone_num=?";
				pstmt=con.prepareStatement(selectId);
			//5.바인드변수 값 설정
				pstmt.setString(1, uDTO.getUsers_name());
				pstmt.setString(2, uDTO.getEmail());
				pstmt.setString(3, uDTO.getBirth());
				pstmt.setString(4, uDTO.getPhone_num());
			//6.쿼리문 수행 후 결과 얻기
				rs=pstmt.executeQuery();
				
				resultFlag=rs.next();//id 검색 후 조건에 맞는 결과가 존재한다면
				//검색결과가 존재한다면 id를 setter에 넣어줌
				if(resultFlag) {
					uDTO.setUsers_id(rs.getString("users_id"));
				}
			}finally {
			//7.연결 끊기.
				dbCon.dbClose(rs, pstmt, con);
			}//end finally
			return resultFlag;
			
		}//selectId
		
		
		//유저 Pw 찾기 할 때, 입력받은 데이터가 DB에 존재하는지 검사
		public boolean selectUserPw(userDTO uDTO) throws SQLException {
			boolean resultFlag=false; 
			DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
			
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				//1.JNDI 사용객체 생성
				//2.DataSource 얻기
				//3.DataSource에서 Connection 얻기
				con=dbCon.getConn();//1,2,3번 끝.
				//4.쿼리문 생성객체 얻기
				String selectPw="select users_id "
						+ "from users "
						+ "where users_id = ? and users_name = ? and email = ?";
				pstmt=con.prepareStatement(selectPw);
				//5.바인드변수 값 설정
				pstmt.setString(1, uDTO.getUsers_id());
				pstmt.setString(2, uDTO.getUsers_name());
				pstmt.setString(3, uDTO.getEmail());
				//6.쿼리문 수행 후 결과 얻기
				rs=pstmt.executeQuery();
				
				resultFlag=rs.next();//id 검색 후 조건에 맞는 결과가 존재한다면
				System.out.println("selectUserPw : " + resultFlag);
				System.out.println("selectUserPw2 : " + selectPw);
			}finally {
				//7.연결 끊기.
				dbCon.dbClose(rs, pstmt, con);
			}//end finally
			return resultFlag;
		}//selectUserPw
		
		
		
		public int updatePw(userDTO uDTO) throws SQLException {
				DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
				Connection con = null;
				PreparedStatement pstmt = null;
				//업데이트 결과 알려주기
				int result = 0;
				
				try {
				//1.JNDI 사용객체 생성
				//2.DataSource 얻기
				//3.DataSource에서 Connection 얻기
					con=dbCon.getConn();//1,2,3번 끝.
				//4.쿼리문 생성객체 얻기
					StringBuilder updateCnt= new StringBuilder();
					updateCnt
					.append("update users ")
					.append("set users_pass=? ")
					.append("where users_id= ?");
					
					pstmt=con.prepareStatement(updateCnt.toString());
				//5.바인드변수 값 설정
					pstmt.setString(1, uDTO.getUsers_pass());
					pstmt.setString(2, uDTO.getUsers_id());
				//6.쿼리문 수행 후 결과 얻기
					result = pstmt.executeUpdate();
					System.out.println("changePw : " + pstmt);
					System.out.println("changePw2 : " + result);
				}finally {
				//7.연결 끊기.
					dbCon.dbClose(null, pstmt, con);
				}//end finally
				return result;
			}//updateBoardCnt
		
		
		
		
		
		
		
		
	}//class
	
