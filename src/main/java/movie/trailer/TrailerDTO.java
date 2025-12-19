package movie.trailer;

public class TrailerDTO {
	private String trailer_code,url_path,movie_code;
	

	/**
	 * DB에서 받은 url_path를 YouTube URL로 합친다
	 * @return
	 */
	public String getFullVideoUrl() {
        // 베이스 URL은 상수(Constant)로 관리하거나 설정 파일에서 로드하는 것이 좋습니다.
        final String BASE_EMBED_URL = "https://www.youtube.com/embed";
        
        // 이 로직은 DTO 내부에서 videoUrl 필드를 이용하여 완성된 URL을 만들어 반환합니다.
        return BASE_EMBED_URL + "/" + this.url_path;
    }//getFullVideoUrl
	
	// DB에서 받은 url_path를 YouTube 썸네일로 합친다
    /**
     * @return
     */
    public String getFullThumbnailUrl() {
        // 상수 관리
        final String BASE_THUMBNAIL_URL = "https://img.youtube.com/vi";
        final String THUMBNAIL_SIZE = "mqdefault.jpg"; 
        
        // 두 개의 값을 모두 합쳐서 반환합니다.
        return BASE_THUMBNAIL_URL + "/" + this.url_path + "/" + THUMBNAIL_SIZE;
    }//getFullThumbnailUrl
	
	
	public String getTrailer_code() {
		return trailer_code;
	}

	public void setTrailer_code(String trailer_code) {
		this.trailer_code = trailer_code;
	}

	public String getUrl_path() {
		return url_path;
	}

	public void setUrl_path(String url_path) {
		this.url_path = url_path;
	}

	public String getMovie_code() {
		return movie_code;
	}

	public void setMovie_code(String movie_code) {
		this.movie_code = movie_code;
	}

	@Override
	public String toString() {
		return "TrailerDTO [trailer_code=" + trailer_code + ", url_path=" + url_path + ", movie_code=" + movie_code
				+ "]";
	}

}
