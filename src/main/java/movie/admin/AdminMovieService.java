package movie.admin;

import java.sql.SQLException;
import java.util.List;

import movie.image_admin.AdminImageDAO; // 패키지명 확인
import movie.movie_admin.MovieDAO;
import movie.movie_admin.MovieDTO;
import movie.trailer_admin.TrailerDAO; // 패키지명 확인
import movie.trailer_admin.TrailerDTO;

public class AdminMovieService {
    private static AdminMovieService as;
    
    private AdminMovieService() {}
    
    public static AdminMovieService getInstance() {
        if(as == null) as = new AdminMovieService();
        return as;
    }
    
    // [영화 리스트 조회]
    public List<MovieDTO> getMovieList(int currentPage, int pageScale, String keyword) {
        int startNum = (currentPage - 1) * pageScale + 1;
        int endNum = startNum + pageScale - 1;
        List<MovieDTO> list = null;
        try {
            list = MovieDAO.getInstance().selectMovieList(startNum, endNum, keyword);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // [총 영화 개수]
    public int getTotalCount(String keyword) {
        int count = 0;
        try {
            count = MovieDAO.getInstance().selectTotalCount(keyword);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    // [총 페이지 수]
    public int totalPage(int totalCount, int pageScale) {
        return (int)Math.ceil((double)totalCount / pageScale);
    }
    
    // [영화 상세 조회]
    public MovieDTO getMovie(String id) {
        MovieDTO mDTO = null;
        try {
            mDTO = MovieDAO.getInstance().selectMovie(id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return mDTO;
    }
    
    // [★추가: 트레일러 리스트 조회 (수정 화면용)]
    public List<TrailerDTO> getTrailers(String id) {
        List<TrailerDTO> list = null;
        try {
            list = TrailerDAO.getInstance().selectTrailer(id);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // [영화 기본 정보 등록]
    public boolean registerMovie(MovieDTO mDTO) {
        try {
            MovieDAO.getInstance().insertMovie(mDTO);
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // [★에러 해결: 영화 스틸컷 등록]
    public boolean registerMovieImage(String imgPath, String movieCode) {
        AdminImageDAO imageDAO = AdminImageDAO.getInstance(); 
        try {
            // DAO의 insertMovieImage 호출
            int result = imageDAO.insertMovieImage(imgPath, movieCode);
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // [★에러 해결: 트레일러 등록]
    public boolean registerMovieTrailer(String[] urlPaths, String movieCode) {
        TrailerDAO tDAO = TrailerDAO.getInstance();
        try {
            // 1. 기존 트레일러 삭제 (수정일 경우를 대비해 삭제 후 재입력)
            tDAO.deleteTrailers(movieCode);
            
            // 2. 입력된 URL들이 있다면 반복문으로 Insert
            if(urlPaths != null) {
                for(String url : urlPaths) {
                    if(url != null && !url.trim().isEmpty()) {
                        tDAO.insertTrailer(url, movieCode);
                    }
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // [영화 정보 수정]
    public boolean modifyMovie(MovieDTO mDTO) {
        try {
            return MovieDAO.getInstance().updateMovie(mDTO) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // [영화 삭제 (Soft Delete)]
    public boolean removeMovie(String id) {
        try {
            return MovieDAO.getInstance().deleteMovie(id) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // [페이지네이션 HTML 생성]
    public String getPagination(int currentPage, int totalPage, int pageGroup, String url, String keyword) {
        StringBuilder sb = new StringBuilder();
        String param = "";
        if(keyword != null && !keyword.isEmpty()) {
            param = "&keyword=" + keyword;
        }
        
        int startPage = ((currentPage - 1) / pageGroup) * pageGroup + 1;
        int endPage = startPage + pageGroup - 1;
        if(endPage > totalPage) endPage = totalPage;
        
        if(startPage > pageGroup) {
            sb.append("<a href='").append(url).append("?currentPage=").append(startPage - 1).append(param)
              .append("' class='page-link'><i class='fa-solid fa-chevron-left'></i></a>");
        } else {
            sb.append("<a href='javascript:void(0)' class='page-link' style='color:#ccc; cursor:default;'><i class='fa-solid fa-chevron-left'></i></a>");
        }
        
        for(int i = startPage; i <= endPage; i++) {
            if(i == currentPage) {
                sb.append("<a href='javascript:void(0)' class='page-link active'>").append(i).append("</a>");
            } else {
                sb.append("<a href='").append(url).append("?currentPage=").append(i).append(param)
                  .append("' class='page-link'>").append(i).append("</a>");
            }
        }
        
        if(endPage < totalPage) {
            sb.append("<a href='").append(url).append("?currentPage=").append(endPage + 1).append(param)
              .append("' class='page-link'><i class='fa-solid fa-chevron-right'></i></a>");
        } else {
            sb.append("<a href='javascript:void(0)' class='page-link' style='color:#ccc; cursor:default;'><i class='fa-solid fa-chevron-right'></i></a>");
        }
        return sb.toString();
    }
    
    // [스케줄 등록용 영화 목록]
    public List<MovieDTO> getMoviesForSchedule() {
        List<MovieDTO> list = null;
        try {
            list = MovieDAO.getInstance().selectMoviesForSchedule();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}