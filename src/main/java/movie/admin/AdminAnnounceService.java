package movie.admin;

import java.sql.SQLException;
import java.util.List;

import movie.announce_admin.AnnounceDAO;
import movie.announce_admin.AnnounceDTO;

public class AdminAnnounceService {
	private static AdminAnnounceService service;
	
	private AdminAnnounceService() {}
	
	public static AdminAnnounceService getInstance() {
		if(service == null) service = new AdminAnnounceService();
		return service;
	}
	
	private AnnounceDAO aDAO = AnnounceDAO.getInstance();
	
	public List<AnnounceDTO> getAnnounceList(int page, int pageSize, String field, String query) {
		List<AnnounceDTO> list = null;
		try {
			int startNum = (page - 1) * pageSize + 1;
			int endNum = startNum + pageSize - 1;
			list = aDAO.selectAnnounceList(startNum, endNum, field, query);
		} catch (SQLException e) { e.printStackTrace(); }
		return list;
	}
	
	public int getTotalCount(String field, String query) {
		int count = 0;
		try { count = aDAO.selectTotalCount(field, query); } catch (SQLException e) { e.printStackTrace(); }
		return count;
	}
	
	public int addAnnounce(AnnounceDTO dto) {
		int result = 0;
		try { result = aDAO.insertAnnounce(dto); } catch (SQLException e) { e.printStackTrace(); }
		return result;
	}
	
	public AnnounceDTO getAnnounceDetail(int announceNum) {
		AnnounceDTO dto = null;
		try { dto = aDAO.selectAnnounceDetail(announceNum); } catch (SQLException e) { e.printStackTrace(); }
		return dto;
	}
	
	public int modifyAnnounce(AnnounceDTO dto) {
		int result = 0;
		try { result = aDAO.updateAnnounce(dto); } catch (SQLException e) { e.printStackTrace(); }
		return result;
	}
	
	public int removeAnnounce(int announceNum) {
		int result = 0;
		try { result = aDAO.deleteAnnounce(announceNum); } catch (SQLException e) { e.printStackTrace(); }
		return result;
	}
}