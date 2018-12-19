package connectDB;


public class SaleBean {
	private int idx;
	private String url;
	private String date_start;
	private String date_end;
	private String menu;
	private int price_dc;
	private int price_raw;
	private int dc_rate;
	private String etc;
	
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
	public String getMenu() {
		return menu;
	}
	public void setMenu(String menu) {
		this.menu = menu;
	}
	public int getPrice_dc() {
		return price_dc;
	}
	public void setPrice_dc(int price_dc) {
		this.price_dc = price_dc;
	}
	public int getPrice_raw() {
		return price_raw;
	}
	public void setPrice_raw(int price_raw) {
		this.price_raw = price_raw;
	}
	public int getDc_rate() {
		return dc_rate;
	}
	public void setDc_rate(int dc_rate) {
		this.dc_rate = dc_rate;
	}
	public String getEtc() {
		return etc;
	}
	public void setEtc(String etc) {
		this.etc = etc;
	}
	
}
