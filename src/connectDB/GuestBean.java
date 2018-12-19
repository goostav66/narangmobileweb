package connectDB;

import java.sql.Timestamp;

public class GuestBean {
	private int idx;
	private String url;
	private String msg;
	private Timestamp credate;
	private int emoticon;
	private String phone;
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
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
	public Timestamp getCredate() {
		return credate;
	}
	public void setCredate(Timestamp credate) {
		this.credate = credate;
	}
	public int getEmoticon() {
		return emoticon;
	}
	public void setEmoticon(int emoticon) {
		this.emoticon = emoticon;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
}
