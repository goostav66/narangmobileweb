package connectDB;

public class OrderBean {
	private int idx;
	private int shop_idx;
	private int order_table;
	private int order_menu;
	private int order_quant;
	private int order_total;
	private String order_date;
	
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
	public int getOrder_table() {
		return order_table;
	}
	public void setOrder_table(int order_table) {
		this.order_table = order_table;
	}
	public int getOrder_menu() {
		return order_menu;
	}
	public void setOrder_menu(int order_menu) {
		this.order_menu = order_menu;
	}
	public int getOrder_quant() {
		return order_quant;
	}
	public void setOrder_quant(int order_quant) {
		this.order_quant = order_quant;
	}
	public int getOrder_total() {
		return order_total;
	}
	public void setOrder_total(int order_total) {
		this.order_total = order_total;
	}
	public String getOrder_date() {
		return order_date;
	}
	public void setOrder_date(String order_date) {
		this.order_date = order_date;
	}
}
