package movie.image;

public class ImageDTO {
	private String img_code,img_path,movie_code;
	
	@Override
	public String toString() {
		return "ImageDTO [img_code=" + img_code + ", img_path=" + img_path + ", movie_code=" + movie_code + "]";
	}

	public String getImg_code() {
		return img_code;
	}

	public void setImg_code(String img_code) {
		this.img_code = img_code;
	}

	public String getImg_path() {
		return img_path;
	}

	public void setImg_path(String img_path) {
		this.img_path = img_path;
	}

	public String getMovie_code() {
		return movie_code;
	}

	public void setMovie_code(String movie_code) {
		this.movie_code = movie_code;
	}
	
}//class
