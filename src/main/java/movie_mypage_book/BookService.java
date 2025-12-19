package movie_mypage_book;

import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

public class BookService {
	private static BookService bs;
	
	private BookService() {
	}
	
	public static BookService getInstance() {
		if(bs == null) {
			bs = new BookService();
		}
		return bs;
	}
	
	/**
	 * 예매 내역 가져오기
	 * @param userId
	 * @param type ("ACTIVE", "PAST")
	 * @return
	 */
	public List<BookDTO> getBookList(String userId, String type, String year, String month) {
		BookDAO dao = BookDAO.getInstance();
		List<BookDTO> list = null;
		
		try {
			list = dao.selectBookList(userId, type, year, month);
		} catch (SQLException e) {
			e.printStackTrace();
			// 에러 발생 시 빈 리스트 반환
			list = Collections.emptyList();
		}
		
		return list;
	}

}
