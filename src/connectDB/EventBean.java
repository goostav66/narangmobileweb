package connectDB;

import java.sql.Date;

public class EventBean {
	private int idx;
	private String url;
	private String background_img;
	private String message;
	private String date_start;
	private String date_end;
	private int isFloating;
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getBackground_img() {
		return background_img;
	}
	public void setBackground_img(String background_img) {
		this.background_img = background_img;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getDate_start() {
		return date_start;
	}
	public void setDate_start(String date_start) {
		this.date_start = date_start;
	}
	public String getDate_end() {
		return date_end;
	}
	public void setDate_end(String date_end) {
		this.date_end = date_end;
	}
	public int getIsFloating() {
		return isFloating;
	}
	public void setIsFloating(int isFloating) {
		this.isFloating = isFloating;
	}
}
