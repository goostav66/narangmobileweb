package connectDB;

public class PhotoBean {
	private int idx;
	private int shop_idx;
	private String url;
	private String photo_url;
	private int photo_order;

	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public int getShop_idx() {
		return shop_idx;
	}
	public void setShop_idx(int shop_idx) {
		this.shop_idx = shop_idx;
	}
	public String getPhoto_url() {
		return photo_url;
	}
	public void setPhoto_url(String photo_url) {
		this.photo_url = photo_url;
	}
	public int getPhoto_order() {
		return photo_order;
	}
	public void setPhoto_order(int photo_order) {
		this.photo_order = photo_order;
	}
	
}
