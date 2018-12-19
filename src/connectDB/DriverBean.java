package connectDB;

public class DriverBean {
	private int idx;
	private String d_url;
	private int d_status;
	private String d_datetime;
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public String getD_url() {
		return d_url;
	}
	public void setD_url(String d_url) {
		this.d_url = d_url;
	}
	public int getD_status() {
		return d_status;
	}
	public void setD_status(int d_status) {
		this.d_status = d_status;
	}
	public String getD_datetime() {
		return d_datetime;
	}
	public void setD_datetime(String d_datetime) {
		this.d_datetime = d_datetime;
	}
}
