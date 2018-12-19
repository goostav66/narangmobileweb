package connectDB;

public class CallDriverBean {
	private int idx;
	private String hpno;
	private String current_position;
	private String dst_position;
	private int add_call;
	private char state;
	private String credate;
	private String url;
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public String getHpno() {
		return hpno;
	}
	public void setHpno(String hpno) {
		this.hpno = hpno;
	}
	public String getCurrent_position() {
		return current_position;
	}
	public void setCurrent_position(String current_position) {
		this.current_position = current_position;
	}
	public String getDst_position() {
		return dst_position;
	}
	public void setDst_position(String dst_position) {
		this.dst_position = dst_position;
	}
	
	public int getAdd_call() {
		return add_call;
	}
	public void setAdd_call(int add_call) {
		this.add_call = add_call;
	}
	public char getState() {
		return state;
	}
	public void setState(char state) {
		this.state = state;
	}
	public String getCredate() {
		return credate;
	}
	public void setCredate(String credate) {
		this.credate = credate;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
}
