package connectDB;


public class FranchiseBean {
	private int idx;
	private int type;
	private String url;
	private String shop_name;
	private int agent_idx;
	
	private int location_code;
	private String shop_addr;
	private String shop_phone;
	
	private String open_weekDay;
	private String close_weekDay;
	private String open_weekEnd;
	private String close_weekEnd;
	private String offday;
	
	private String recom_menu;
	private String intro_text;
	
	private int discount;
	private int isParking;
	private int isSeats;

	private double lat;
	private double lng;
	
	public int getIdx() {
		return idx;
	}
	public void setIdx(int idx) {
		this.idx = idx;
	}
	public int getAgent_idx() {
		return agent_idx;
	}
	public void setAgent_idx(int agent_idx) {
		this.agent_idx = agent_idx;
	}
	public int getLocation_code() {
		return location_code;
	}
	public void setLocation_code(int location_code) {
		this.location_code = location_code;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getShop_name() {
		return shop_name;
	}
	public void setShop_name(String shop_name) {
		this.shop_name = shop_name;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
	}
	public String getShop_phone() {
		return shop_phone;
	}
	public void setShop_phone(String shop_phone) {
		this.shop_phone = shop_phone;
	}
	public String getShop_addr() {
		return shop_addr;
	}
	public void setShop_addr(String shop_addr) {
		this.shop_addr = shop_addr;
	}
	public String getOpen_weekDay() {
		return open_weekDay;
	}
	public void setOpen_weekDay(String open_weekDay) {
		this.open_weekDay = open_weekDay;
	}
	public String getClose_weekDay() {
		return close_weekDay;
	}
	public void setClose_weekDay(String close_weekDay) {
		this.close_weekDay = close_weekDay;
	}
	public String getOpen_weekEnd() {
		return open_weekEnd;
	}
	public void setOpen_weekEnd(String open_weekEnd) {
		this.open_weekEnd = open_weekEnd;
	}
	public String getClose_weekEnd() {
		return close_weekEnd;
	}
	public void setClose_weekEnd(String close_weekEnd) {
		this.close_weekEnd = close_weekEnd;
	}
	public String getOffday() {
		return offday;
	}
	public void setOffday(String offday) {
		this.offday = offday;
	}
	public String getRecom_menu() {
		return recom_menu;
	}
	public void setRecom_menu(String recom_menu) {
		this.recom_menu = recom_menu;
	}
	public String getIntro_text() {
		return intro_text;
	}
	public void setIntro_text(String intro_text) {
		this.intro_text = intro_text;
	}
	public int getDiscount() {
		return discount;
	}
	public void setDiscount(int discount) {
		this.discount = discount;
	}
	public int getIsParking() {
		return isParking;
	}
	public void setIsParking(int isParking) {
		this.isParking = isParking;
	}
	public int getIsSeats() {
		return isSeats;
	}
	public void setIsSeats(int isSeats) {
		this.isSeats = isSeats;
	}
	public double getLat() {
		return lat;
	}
	public void setLat(double lat) {
		this.lat = lat;
	}
	public double getLng() {
		return lng;
	}
	public void setLng(double lng) {
		this.lng = lng;
	}
}
