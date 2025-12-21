package movie.admin;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import movie.screening_admin.ScreeningDAO;
import movie.screening_admin.ScreeningDTO;

public class AdminScreeningService {
	private static AdminScreeningService service;
	
	private AdminScreeningService() {}
	
	public static AdminScreeningService getInstance() {
		if(service == null) service = new AdminScreeningService();
		return service;
	}
	
	private ScreeningDAO sDAO = ScreeningDAO.getInstance();
	
	// 1. 리스트 조회 (페이지 번호를 받아서 start/end 계산까지 처리)
	public List<ScreeningDTO> getScreeningList(int page, int pageSize, String field, String query) {
		List<ScreeningDTO> list = null;
		try {
			int startNum = (page - 1) * pageSize + 1;
			int endNum = startNum + pageSize - 1;
			list = sDAO.selectScreeningList(startNum, endNum, field, query);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	// 2. 총 개수 조회
	public int getTotalCount(String field, String query) {
		int count = 0;
		try {
			count = sDAO.selectTotalCount(field, query);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return count;
	}
	
	// 3. 상세 조회 (수정 폼용)
	public ScreeningDTO getScreeningDetail(String screenCode) {
		ScreeningDTO dto = null;
		try {
			dto = sDAO.selectScreeningDetail(screenCode);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dto;
	}
	
	// 4. 스케줄 등록
	public int addScreening(ScreeningDTO dto) {
		int result = 0;
		try {
			// 1. 영화 러닝타임 가져오기
			int runtime = sDAO.getMovieRuntime(dto.getMovieCode());
			
			// 2. 종료 시간 계산 (러닝타임이 0이면 시작시간과 동일하게 들어감)
			String endTime = calculateEndTime(dto.getScreenDate(), dto.getScreenTime(), runtime);
			dto.setScreenEndTime(endTime);
			
			// 3. DAO 호출
			result = sDAO.insertScreening(dto);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	// 5. 스케줄 수정
	public int modifyScreening(ScreeningDTO dto) {
		int result = 0;
		try {
			// 1. 영화 코드로 러닝타임 가져오기 (영화가 바뀌었을 수도 있으므로)
			int runtime = sDAO.getMovieRuntime(dto.getMovieCode());
			
			// 2. 종료 시간 재계산 (날짜 + 시작시간 + 러닝타임)
			String endTime = calculateEndTime(dto.getScreenDate(), dto.getScreenTime(), runtime);
			dto.setScreenEndTime(endTime); // DTO에 세팅
			
			// 3. DAO 호출 (이제 종료시간까지 포함되어 넘어감)
			result = sDAO.updateScreening(dto);
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 시간 계산 헬퍼 메소드 (시작시간 + 러닝타임 = 종료시간)
	 */
	private String calculateEndTime(String dateStr, String timeStr, int runtimeMin) {
		String result = "";
		try {
			// 날짜와 시간을 합쳐서 Date 객체 생성
			String dateTimeStr = dateStr + " " + timeStr;
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			Date startDate = sdf.parse(dateTimeStr);
			
			// 캘린더 객체로 시간 더하기
			Calendar cal = Calendar.getInstance();
			cal.setTime(startDate);
			cal.add(Calendar.MINUTE, runtimeMin); // 분 단위 더하기
			
			// 다시 문자열(HH:mm)로 포맷팅
			SimpleDateFormat timeFmt = new SimpleDateFormat("HH:mm");
			result = timeFmt.format(cal.getTime());
			
		} catch (Exception e) {
			e.printStackTrace();
			// 에러 시 그냥 시작 시간과 동일하게 처리
			result = timeStr;
		}
		return result;
	}

	
	// 6. 스케줄 삭제
	// 리턴값: 1=성공, -2=예매존재(삭제불가), 0=실패
	public int removeScreening(String screenCode) {
		int result = 0;
		try {
			// 예매 내역 체크
			boolean hasBooking = sDAO.checkBookingExist(screenCode);
			if(hasBooking) {
				return -2;
			}
			result = sDAO.deleteScreening(screenCode);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
}