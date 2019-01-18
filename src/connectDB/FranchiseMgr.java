package connectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;

public class FranchiseMgr {
	private DBConnectionMgr pool;
		
	public static final int TYPE_KOR = 1;
	public static final int TYPE_JPN = 2;
	public static final int TYPE_KARAOKE = 3;
	public static final int TYPE_BAR_FU = 4;
	public static final int TYPE_BAR_AD = 5;
	public static final int TYPE_ETC = 6;
	public static final int TYPE_MEMBERSHIP = 7;
	
	//아이콘_예약할인율 
	public static final String ICON_DC_RATE_0 = "icon_discount_0.png";
	public static final String ICON_DC_RATE_5 = "icon_discount_5.png";
	public static final String ICON_DC_RATE_10 = "icon_discount_10.png";
	public static final String ICON_DC_RATE_15 = "icon_discount_15.png";

	//아이콘_예약가능
	public static final String ICON_ISRESERVE_ON = "icon2_on.png";
	public static final String ICON_ISRESERVE_OFF = "icon2_off.png";

	//아이콘_주차
	public static final String ICON_ISPARKING_ON = "icon4_on.png";
	public static final String ICON_ISPARKING_OFF = "icon4_off.png";
	
	//아이콘_단체석
	public static final String ICON_ISSEATS_ON = "icon5_on.png";
	public static final String ICON_ISSEATS_OFF = "icon5_off.png";
	
	//아이콘_대리운전무상
	public static final String ICON_ISFREE_CDS_ON = "icon3_on.png";
	public static final String ICON_ISFREE_CDS_OFF = "icon3_off.png";
	
	public FranchiseMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public static String getDiscountIcon(int discount) {
		String discount_icon = ICON_DC_RATE_0;
		switch(discount) {
		case 5:
			discount_icon = ICON_DC_RATE_5;
			break;
		case 10:
			discount_icon = ICON_DC_RATE_10;
			break;
		case 15:
			discount_icon = ICON_DC_RATE_15;
			break;
		}
		return discount_icon;
	}
	
	public static String convertTimetoString(String time) {
		String str = "";
		if(time != null && time.length()>=5)
			str = time.substring(0, 5);
		return str;
	}
	
	//가맹점 정보 불러오기
	public FranchiseBean getFranchInfo(String url){
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		FranchiseBean bean = new FranchiseBean();
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop WHERE url=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				bean.setIdx(rs.getInt("idx"));
				bean.setType(rs.getInt("type"));
				bean.setUrl(url);
				bean.setShop_name(rs.getString("shop_name"));
				bean.setAgent_idx(rs.getInt("agent_idx"));
				
				bean.setLocation_code(rs.getInt("location_code"));
				bean.setShop_phone(rs.getString("shop_phone"));
				bean.setShop_addr(rs.getString("shop_addr"));
				
				bean.setOpen_weekDay(rs.getString("open_weekDay"));
				bean.setClose_weekDay(rs.getString("close_weekDay"));
				bean.setOpen_weekEnd(rs.getString("open_weekEnd"));
				bean.setClose_weekEnd(rs.getString("close_weekEnd"));
				
				String offday = rs.getString("offday");
				if(offday == null) offday = "";
				bean.setOffday(offday);
				
				String recom_menu = rs.getString("recom_menu");
				if(recom_menu == null) recom_menu = "";
				bean.setRecom_menu(recom_menu);
				
				String intro_text = rs.getString("intro_text");
				if(intro_text == null) intro_text = "";
				bean.setIntro_text(intro_text);

				bean.setDiscount(rs.getInt("discount"));
				bean.setIsParking(rs.getInt("isParking"));
				bean.setIsSeats(rs.getInt("isSeats"));
				
				bean.setLat(rs.getDouble("lat"));
				bean.setLng(rs.getDouble("lng"));
				
			}
			
		} catch (CommunicationsException ce) {
			bean = getFranchInfo(url);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
	
	
	//광고업소 불러오기(메인화면, 예약서비스 첫화면)
	public Vector<FranchiseBean> getSomeFranchList(String url_now, int limit){
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		Vector<FranchiseBean> vlist = new Vector<FranchiseBean>();
		
		try {
			con = pool.getConnection();
			sql = "SELECT s.idx, sc.url, s.shop_name, s.intro_text FROM shop_commerce AS sc "
				+ "LEFT JOIN shop AS s ON s.url = sc.url "
				+ "LEFT JOIN shop_commerce_location AS scl ON scl.sc_idx = sc.idx "
				+ "WHERE CURDATE() BETWEEN sc.regdate AND sc.expdate "
				+ "AND (scl.location_code = (SELECT location_code FROM shop WHERE url = ?) "
				+ "OR scl.location_code = FLOOR( (SELECT location_code FROM shop WHERE url = ?)/100 )*100 "
				+ "OR scl.location_code = 1000 ) "
				+ "ORDER BY RAND() LIMIT ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url_now);
			pstmt.setString(2, url_now);
			pstmt.setInt(3, limit);

			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				FranchiseBean bean = new FranchiseBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setUrl(rs.getString("url"));
				bean.setShop_name(rs.getString("shop_name"));
				bean.setIntro_text(rs.getString("intro_text"));
				
				vlist.add(bean);
			}
			
		} catch (CommunicationsException ce) {
			vlist = getSomeFranchList(url_now, limit);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return vlist;
	}
	
	//외부업체 광고 불러오기
	public Vector<ExtCommerceBean> getExtCommerceList(String url, int limit){
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		Vector<ExtCommerceBean> vlist = new Vector<ExtCommerceBean>();

		try {
			con = pool.getConnection();
			sql = "SELECT ec.e_enterprise, ec.e_info, ec.e_main_img, ec.e_page_url "
				+ "FROM ext_commerce AS ec "
				+ "LEFT JOIN ext_commerce_location AS ecl ON ecl.e_idx = ec.idx "
				+ "WHERE CURDATE() BETWEEN ec.e_regdate AND ec.e_expdate "
				+ "AND (ecl.e_location_code = (SELECT location_code FROM shop WHERE url = ?) "
				+ "OR ecl.e_location_code = FLOOR( (SELECT location_code FROM shop WHERE url = ?)/100)*100 "
				+ "OR ecl.e_location_code = 1000 ) "
				+ "ORDER BY RAND() LIMIT ?";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, url);
			pstmt.setString(2, url);
			pstmt.setInt(3, limit);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				ExtCommerceBean bean = new ExtCommerceBean();
				bean.setE_enterprise(rs.getString("e_enterprise"));
				bean.setE_info(rs.getString("e_info"));
				bean.setE_main_img(rs.getString("e_main_img"));
				bean.setE_page_url(rs.getString("e_page_url"));
				vlist.add(bean);
			}
			
		} catch(CommunicationsException ce) {
			vlist = getExtCommerceList(url, limit);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return vlist;
	}
	
	//예약 서비스 - 업종별 가맹점 불러오기 
	public Vector<FranchiseListBean> getShopListByType(int type, String url, int start, int limit){
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		Vector<FranchiseListBean> vlist = new Vector<FranchiseListBean>();
		double lat = 0, lng = 0;
		int location_code = 0;
		try {
			con = pool.getConnection();
			
			sql = "SELECT location_code, lat, lng FROM shop WHERE url = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				lat = rs.getDouble("lat");
				lng = rs.getDouble("lng");
				location_code = rs.getInt("location_code");
			}
			pstmt.close();
			rs.close();
			
			sql = "SELECT *, "
				+ "6371*acos(cos(radians(?)) * cos(radians(lat)) * cos(radians(lng) - radians(?))+sin(radians(?))*sin(radians(lat)))*1000 AS distance "
				+ "FROM shop "
				+ "WHERE url NOT IN (?) AND type = ? "
				+ "AND FLOOR(location_code/100) = FLOOR(?/100) "
				+ "ORDER BY -distance DESC LIMIT ?, ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setDouble(1, lat);
			pstmt.setDouble(2, lng);
			pstmt.setDouble(3, lat);
			pstmt.setString(4, url);
			pstmt.setInt(5, type);
			pstmt.setInt(6, location_code);
			pstmt.setInt(7, start);
			pstmt.setInt(8, limit);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				FranchiseListBean bean = new FranchiseListBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setUrl(rs.getString("url"));
				bean.setShop_name(rs.getString("shop_name"));
				bean.setType(rs.getInt("type"));
				
				bean.setLocation_code(rs.getInt("location_code"));
				bean.setShop_phone(rs.getString("shop_phone"));
				bean.setShop_addr(rs.getString("shop_addr"));
				
				bean.setOpen_weekDay(rs.getString("open_weekDay"));
				bean.setClose_weekDay(rs.getString("close_weekDay"));
				bean.setOpen_weekEnd(rs.getString("open_weekEnd"));
				bean.setClose_weekEnd(rs.getString("close_weekEnd"));
						
				bean.setDiscount(rs.getInt("discount"));
				bean.setIsSeats(rs.getInt("isSeats"));
				bean.setIsParking(rs.getInt("isParking"));
				
				bean.setLat(rs.getDouble("lat"));
				bean.setLng(rs.getDouble("lng"));
				bean.setDistance(rs.getDouble("distance"));
				vlist.add(bean);
			}
			
		} catch(CommunicationsException ce) {
			getShopListByType(type, url, start, limit);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	//가맹점 통합검색
	public Vector<FranchiseListBean> searchFranch(String url, String searchText, int start, int limit){
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		Vector<FranchiseListBean> vlist = new Vector<FranchiseListBean>();
		double lat = 0, lng = 0;
		int location_code = 0;
		try {
			con = pool.getConnection();
				
			sql = "SELECT lat, lng, location_code FROM shop WHERE url = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			rs = pstmt.executeQuery();

			if(rs.next()) {
				lat = rs.getDouble("lat");
				lng = rs.getDouble("lng");
				location_code = rs.getInt("location_code");
			}
			
			pstmt.close();
			rs.close();
			
			sql = "SELECT *, 6371*acos( cos(radians(?)) * cos(radians(lat)) * cos(radians(lng) - radians(?)) + sin(radians(?)) * sin(radians(lat)) )*1000 AS distance "
				+ "FROM shop "
				+ "WHERE url NOT IN (?) "
				+ "AND (INSTR(shop_name, ?) > 0) "
				+ "AND FLOOR(location_code/100) = FLOOR(?/100) "
				+ "UNION "
				+ "SELECT s.*, 6371*acos( cos(radians(?)) * cos(radians(s.lat)) * cos(radians(s.lng) - radians(?)) + sin(radians(?)) * sin(radians(s.lat)) )*1000 AS distance "	
				+ "FROM shop AS s "
				+ "LEFT JOIN table_location_code AS tlc ON s.location_code = tlc.location_code "
				+ "WHERE s.url NOT IN (?) "
				+ "AND INSTR(CONCAT(tlc.location_place, ' ', s.shop_addr), ?) "
				+ "UNION "
				+ "SELECT s.*, 6371*acos( cos(radians(?)) * cos(radians(s.lat)) * cos(radians(s.lng) - radians(?)) + sin(radians(?)) * sin(radians(s.lat)) )*1000 AS distance "
				+ "FROM shop AS s LEFT JOIN shop_menu AS m ON s.idx = m.shop_idx "
				+ "WHERE s.url NOT IN (?) "
				+ "AND (INSTR(m.menu_name, ?) > 0) "
				+ "AND FLOOR(s.location_code/100) = FLOOR(?/100) "
				+ "UNION "
				+ "SELECT s.*, 6371*acos( cos(radians(?)) * cos(radians(s.lat)) * cos(radians(s.lng) - radians(?)) + sin(radians(?)) * sin(radians(s.lat)) )*1000 AS distance "
				+ "FROM shop AS s LEFT JOIN shop_tag AS t ON s.idx = t.shop_idx "
				+ "WHERE s.url NOT IN (?) "
				+ "AND (INSTR(t.tag, ?) > 0) "
				+ "AND FLOOR(s.location_code/100) = FLOOR(?/100) "
				+ "ORDER BY -distance DESC LIMIT ?, ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setDouble(1, lat);
			pstmt.setDouble(2, lng);
			pstmt.setDouble(3, lat);
			pstmt.setString(4, url);
			pstmt.setString(5, searchText);
			pstmt.setInt(6, location_code);
			
			pstmt.setDouble(7, lat);
			pstmt.setDouble(8, lng);
			pstmt.setDouble(9, lat);
			pstmt.setString(10, url);
			pstmt.setString(11, searchText);
			
			pstmt.setDouble(12, lat);
			pstmt.setDouble(13, lng);
			pstmt.setDouble(14, lat);
			pstmt.setString(15, url);
			pstmt.setString(16, searchText);
			pstmt.setInt(17, location_code);
			
			pstmt.setDouble(18, lat);
			pstmt.setDouble(19, lng);
			pstmt.setDouble(20, lat);
			pstmt.setString(21, url);
			pstmt.setString(22, searchText);
			pstmt.setInt(23, location_code);
			
			pstmt.setInt(24, start);
			pstmt.setInt(25, limit);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				FranchiseListBean bean = new FranchiseListBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setUrl(rs.getString("url"));
				bean.setShop_name(rs.getString("shop_name"));
				bean.setType(rs.getInt("type"));
		
				bean.setLocation_code(rs.getInt("location_code"));
				bean.setShop_phone(rs.getString("shop_phone"));
				bean.setShop_addr(rs.getString("shop_addr"));
				
				bean.setOpen_weekDay(rs.getString("open_weekDay"));
				bean.setClose_weekDay(rs.getString("close_weekDay"));
				bean.setOpen_weekEnd(rs.getString("open_weekEnd"));
				bean.setClose_weekEnd(rs.getString("close_weekEnd"));
				
				String intro_text = rs.getString("intro_text");
				if(intro_text == null) intro_text = "";
				bean.setIntro_text(intro_text);
				
				bean.setDiscount(rs.getInt("discount"));
				bean.setIsParking(rs.getInt("isParking"));
				bean.setIsSeats(rs.getInt("isSeats"));

				bean.setDistance(rs.getDouble("distance"));
				
				vlist.add(bean);
			}
			
		} catch(CommunicationsException ce) {
			searchFranch(url, searchText, start, limit);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	//가맹점 통합검색 - 필터
	public Vector<FranchiseListBean> searchFranch(String url, String searchText, int type, int distance, int discount, boolean isParking, boolean isSeats, int start, int limit){
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		Vector<FranchiseListBean> vlist = new Vector<FranchiseListBean>();
		double lat = 0, lng = 0;
		try {
			con = pool.getConnection();
				
			sql = "SELECT s.lat, s.lng FROM shop AS s WHERE s.url = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			rs = pstmt.executeQuery();

			if(rs.next()) {
				lat = rs.getDouble("lat");
				lng = rs.getDouble("lng");
			}
			pstmt.close();
			rs.close();
			
			String sql_condition = " HAVING s.url NOT IN ('"+url+"') ";
			
			if(discount > 0)
				sql_condition += " AND s.discount >= "+discount+" ";
			if(type != 0)
				sql_condition += " AND s.type = "+type+" ";
			if(isParking == true)
				sql_condition += " AND s.isParking = 1 ";
			if(isSeats == true)
				sql_condition += " AND s.isSeats = 1 ";
			if(distance > 0)
				sql_condition += " AND distance <= "+distance+" ";
			
			sql = "SELECT s.*, 6371*acos( cos(radians(?)) * cos(radians(s.lat)) * cos(radians(s.lng) - radians(?)) + sin(radians(?)) * sin(radians(s.lat)) )*1000 AS distance "
				+ "FROM shop AS s LEFT JOIN table_location_code AS tlc ON tlc.location_code = s.location_code "
				+ "WHERE INSTR(s.shop_name, ?) OR INSTR(s.shop_addr, ?) OR INSTR(tlc.location_place, ?) "
				+ sql_condition 
				+ "UNION "
								
				+ "SELECT s.*, 6371*acos( cos(radians(?)) * cos(radians(s.lat)) * cos(radians(s.lng) - radians(?)) + sin(radians(?)) * sin(radians(s.lat)) )*1000 AS distance "
				+ "FROM shop AS s LEFT JOIN shop_menu AS m ON s.idx = m.shop_idx "
				+ "WHERE INSTR(m.menu_name, ?) "
				+ sql_condition 
				+ "UNION "
				
				+ "SELECT s.*, 6371*acos( cos(radians(?)) * cos(radians(s.lat)) * cos(radians(s.lng) - radians(?)) + sin(radians(?)) * sin(radians(s.lat)) )*1000 AS distance "
				+ "FROM shop AS s LEFT JOIN shop_tag AS t ON s.idx = t.shop_idx "
				+ "WHERE INSTR(t.tag, ?) "
				+ sql_condition 
				
				+ "ORDER BY -distance DESC LIMIT ?, ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setDouble(1, lat);
			pstmt.setDouble(2, lng);
			pstmt.setDouble(3, lat);
			
			pstmt.setString(4, searchText);
			pstmt.setString(5, searchText);
			pstmt.setString(6, searchText);
			
			pstmt.setDouble(7, lat);
			pstmt.setDouble(8, lng);
			pstmt.setDouble(9, lat);
			
			pstmt.setString(10, searchText);
			
			pstmt.setDouble(11, lat);
			pstmt.setDouble(12, lng);
			pstmt.setDouble(13, lat);
			
			pstmt.setString(14, searchText);
	
			pstmt.setInt(15, start);
			pstmt.setInt(16, limit);
				
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				FranchiseListBean bean = new FranchiseListBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setUrl(rs.getString("url"));
				bean.setShop_name(rs.getString("shop_name"));
				bean.setType(rs.getInt("type"));
		
				bean.setLocation_code(rs.getInt("location_code"));
				bean.setShop_phone(rs.getString("shop_phone"));
				bean.setShop_addr(rs.getString("shop_addr"));
				
				bean.setOpen_weekDay(rs.getString("open_weekDay"));
				bean.setClose_weekDay(rs.getString("close_weekDay"));
				bean.setOpen_weekEnd(rs.getString("open_weekEnd"));
				bean.setClose_weekEnd(rs.getString("close_weekEnd"));
				
				String intro_text = rs.getString("intro_text");
				if(intro_text == null) intro_text = "";
				bean.setIntro_text(intro_text);
				
				bean.setDiscount(rs.getInt("discount"));
				bean.setIsParking(rs.getInt("isParking"));
				bean.setIsSeats(rs.getInt("isSeats"));

				bean.setDistance(rs.getDouble("distance"));
				
				vlist.add(bean);
			}
			
		} catch(CommunicationsException ce) {
			searchFranch(url, searchText, type, distance, discount, isParking, isSeats, start, limit);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	//업소정보 수정
	public void updateShopInfor(FranchiseBean shop, int r_type) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			if( r_type == 1 ) {//업소정보
				sql = "UPDATE shop SET shop_name = ?, shop_phone = ?, location_code = ?, shop_addr = ?, lat = ?, lng = ?, shop_edit_date = CURRENT_TIMESTAMP() "
					+ "WHERE idx = ? ";
				pstmt = con.prepareStatement(sql);
				
				pstmt.setString(1, shop.getShop_name());
				pstmt.setString(2, shop.getShop_phone());
				pstmt.setInt(3, shop.getLocation_code());
				pstmt.setString(4, shop.getShop_addr());
				pstmt.setDouble(5, shop.getLat());
				pstmt.setDouble(6, shop.getLng());
				pstmt.setInt(7, shop.getIdx());
				
			}else if( r_type == 2 ) {//영업정보
				sql = "UPDATE shop SET open_weekDay = ?, close_weekDay = ?, open_weekEnd = ?, close_weekEnd = ?, offday = ?, " 
					+ "recom_menu = ?, intro_text = ?, discount = ?, isParking = ?, isSeats = ?, shop_edit_date = CURRENT_TIMESTAMP() "
					+ "WHERE idx = ?";
				pstmt = con.prepareStatement(sql);
				
				pstmt.setString(1, shop.getOpen_weekDay());
				pstmt.setString(2, shop.getClose_weekDay());
				pstmt.setString(3, shop.getOpen_weekEnd());
				pstmt.setString(4, shop.getClose_weekEnd());
				pstmt.setString(5, shop.getOffday());
				pstmt.setString(6, shop.getRecom_menu());
				pstmt.setString(7, shop.getIntro_text());
				pstmt.setInt(8, shop.getDiscount());
				pstmt.setInt(9, shop.getIsParking());
				pstmt.setInt(10, shop.getIsSeats());
				pstmt.setInt(11, shop.getIdx());
			}

			pstmt.execute();
			
		} catch(CommunicationsException ce) {
			updateShopInfor(shop, r_type);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
		
	//관할 대리점 정보 가져오기
	public ManagerInfoBean getManagerInfo(String url) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		ManagerInfoBean bean = new ManagerInfoBean();
		try {
			con = pool.getConnection();
			sql = "SELECT b.branch_code, a.agent_code, b.branch_name, a.agent_name, b.branch_manager_phone, a.agent_manager_phone "
				+ "FROM shop AS s " 
				+ "LEFT JOIN branch AS b ON b.branch_code = s.manager_code " 
				+ "LEFT JOIN agent AS a ON a.agent_code = s.manager_code " 
				+ "WHERE s.url = ?";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, url);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				bean.setBranch_code(rs.getString("branch_code"));
				bean.setAgent_code(rs.getString("agent_code"));
				bean.setBranch_name(rs.getString("branch_name"));
				bean.setAgent_name(rs.getString("agent_name"));
				bean.setBranch_manager_phone(rs.getString("branch_manager_phone"));
				bean.setAgent_manager_phone(rs.getString("agent_manager_phone"));
			}
			
		} catch(CommunicationsException ce) {
			bean = getManagerInfo(url);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
		
	}
	
	//location code에서 시(도), 구(군) 텍스트 가져오기
	public String getLocationPlace(int location_code) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		String location_place = "";
		try {
			con = pool.getConnection();
			sql = "SELECT location_place FROM table_location_code WHERE location_code = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, location_code);
		
			rs = pstmt.executeQuery();
			if(rs.next()) {
				location_place = rs.getString(1);
			}
		} catch(CommunicationsException ce) {
			getLocationPlace(location_code);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return location_place;
	}
	
	//같은 시/도 내 구/군 목록 가져오기
	public List<Integer> getLocationCityList(int location_code){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		List<Integer> locationCodeList = new ArrayList<Integer>();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM table_location_code "
				+ "WHERE FLOOR(location_code/100) >= FLOOR(?/100) "
				+ "AND FLOOR(location_code/100) < CEILING(?/100) "
				+ "AND MOD(location_code, 100) != 0";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, location_code);
			pstmt.setInt(2, location_code);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				locationCodeList.add(rs.getInt("location_code"));
			}
		} catch (CommunicationsException ce) {
			getLocationCityList(location_code);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return locationCodeList;
	}
	
	
	/*
	 * 구버전
	 * */	
	//가맹점리스트 개수
		public int getWithinFranchListSize(int type, String url_now) {
			Connection con = null;
			PreparedStatement pstmt = null;
			String sql = null;
			ResultSet rs = null;
			int count = 0, province = 0;
			
			try {
				con = pool.getConnection();
				
				sql = "SELECT b.province "
					+ "FROM agent AS a, branch AS b, shop AS s "
					+ "WHERE a.br_url = b.url AND a.idx = s.agent_idx AND s.url = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url_now);
				
				rs = pstmt.executeQuery();
				if(rs.next())  
					province = rs.getInt(1);
				
				pstmt.close();
				rs.close();
				
				String where_type = "";
				if(type != 0)
					where_type = " AND type="+type;
				
				sql = "SELECT COUNT(s.idx) "
					+ "FROM shop AS s, agent AS a, branch AS b "
					+ "WHERE s.url NOT IN (?) AND b.province = ? AND s.agent_idx = a.idx "
					+ "AND a.br_url = b.url"+where_type ;
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url_now);
				pstmt.setInt(2, province);
				
				rs = pstmt.executeQuery();
				
				if(rs.next())
					count = rs.getInt(1);
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return count;
		}
		//업종별 가맹점 불러오기
		public Vector<FranchiseListBean> getWithinFranchList(int type, String url_now){
			Connection con = null;
			PreparedStatement pstmt = null;
			String sql = null;
			ResultSet rs = null;
			Vector<FranchiseListBean> vlist = new Vector<FranchiseListBean>();
			
			int province = 0;
			double lat = 0, lng = 0;
			try {
				con = pool.getConnection();
				sql = "SELECT b.province, s.lat, s.lng "
					+ "FROM agent AS a, branch AS b, shop AS s "
					+ "WHERE a.br_url = b.url AND a.idx = s.agent_idx AND s.url = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url_now);
				
				rs = pstmt.executeQuery();
				if(rs.next()) { 
					province = rs.getInt(1);
					lat = rs.getDouble(2);
					lng = rs.getDouble(3);
				}
				pstmt.close();
				rs.close();
				
				String where_type = "";
				if(type != 0)
					where_type = " AND type="+type;

				sql = "SELECT s.*, 6371*acos( cos(radians(?)) * cos(radians(s.lat)) * cos(radians(s.lng) - radians(?))" 
					+ "+sin(radians(?)) * sin(radians(s.lat)) )*1000 as distance "
					+ "FROM shop AS s, agent AS a, branch AS b "
					+ "WHERE s.url NOT IN (?) AND b.province = ? AND s.agent_idx = a.idx "
					+ "AND a.br_url = b.url"+where_type
					+ " ORDER BY distance";
				pstmt = con.prepareStatement(sql);
				pstmt.setDouble(1, lat);
				pstmt.setDouble(2, lng);
				pstmt.setDouble(3, lat);
				pstmt.setString(4, url_now);
				pstmt.setInt(5, province);
				
				rs = pstmt.executeQuery();
				
				
				while(rs.next()) {
					FranchiseListBean bean = new FranchiseListBean();
					bean.setIdx(rs.getInt("idx"));
					bean.setUrl(rs.getString("url"));
					bean.setShop_name(rs.getString("shop_name"));
					bean.setType(rs.getInt("type"));
					bean.setAgent_idx(rs.getInt("agent_idx"));
					
					bean.setLocation_code(rs.getInt("location_code"));
					bean.setShop_phone(rs.getString("shop_phone"));
					bean.setShop_addr(rs.getString("shop_addr"));
					
					bean.setOpen_weekDay(rs.getString("open_weekDay"));
					bean.setClose_weekDay(rs.getString("close_weekDay"));
					bean.setOpen_weekEnd(rs.getString("open_weekEnd"));
					bean.setClose_weekEnd(rs.getString("close_weekEnd"));
					
					String offday = rs.getString("offday");
					if(offday == null) offday = "";
					bean.setOffday(offday);
					
					String recom_menu = rs.getString("recom_menu");
					if(recom_menu == null) recom_menu = "";
					bean.setRecom_menu(recom_menu);
					
					String intro_text = rs.getString("intro_text");
					if(intro_text == null) intro_text = "";
					bean.setIntro_text(intro_text);
					
					bean.setDiscount(rs.getInt("discount"));
					bean.setIsParking(rs.getInt("isParking"));
					bean.setIsSeats(rs.getInt("isSeats"));
					
					bean.setLat(rs.getDouble("lat"));
					bean.setLng(rs.getDouble("lng"));
					bean.setDistance(rs.getDouble("distance"));
					
					vlist.add(bean);
				}
				
			} catch(CommunicationsException ce) {
				vlist = getWithinFranchList(type, url_now);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return vlist;
		}
			
		//가맹점 리스트 불러오기(lindex)
		public Vector<FranchiseListBean> getWithinFranchList(int type, String url_now, int lindex){
			Connection con = null;
			PreparedStatement pstmt = null;
			String sql = null;
			ResultSet rs = null;
			Vector<FranchiseListBean> vlist = new Vector<FranchiseListBean>();
			
			int province = 0;
			double lat = 0, lng = 0;
			try {
				con = pool.getConnection();
				sql = "SELECT b.province, s.lat, s.lng "
					+ "FROM agent AS a, branch AS b, shop AS s "
					+ "WHERE a.br_url = b.url AND a.idx = s.agent_idx AND s.url = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url_now);
				
				rs = pstmt.executeQuery();
				if(rs.next()) { 
					province = rs.getInt(1);
					lat = rs.getDouble(2);
					lng = rs.getDouble(3);
				}
				pstmt.close();
				rs.close();
				
				String where_type = "";
				if(type != 0)
					where_type = " AND type="+type;

				sql = "SELECT s.*, 6371*acos( cos(radians(?)) * cos(radians(s.lat)) * cos(radians(s.lng) - radians(?))" 
					+ "+sin(radians(?)) * sin(radians(s.lat)) )*1000 as distance "
					+ "FROM shop AS s, agent AS a, branch AS b "
					+ "WHERE s.url NOT IN (?) AND b.province = ? AND s.agent_idx = a.idx "
					+ "AND a.br_url = b.url"+where_type
					+ " ORDER BY distance LIMIT ?, 6";
				pstmt = con.prepareStatement(sql);
				pstmt.setDouble(1, lat);
				pstmt.setDouble(2, lng);
				pstmt.setDouble(3, lat);
				pstmt.setString(4, url_now);
				pstmt.setInt(5, province);
				pstmt.setInt(6, lindex);
				
				rs = pstmt.executeQuery();
				
				
				while(rs.next()) {
					FranchiseListBean bean = new FranchiseListBean();
					bean.setIdx(rs.getInt("idx"));
					bean.setUrl(rs.getString("url"));
					bean.setShop_name(rs.getString("shop_name"));
					bean.setType(rs.getInt("type"));
					bean.setAgent_idx(rs.getInt("agent_idx"));
					
					bean.setLocation_code(rs.getInt("location_code"));
					bean.setShop_phone(rs.getString("shop_phone"));
					bean.setShop_addr(rs.getString("shop_addr"));
					
					bean.setOpen_weekDay(rs.getString("open_weekDay"));
					bean.setClose_weekDay(rs.getString("close_weekDay"));
					bean.setOpen_weekEnd(rs.getString("open_weekEnd"));
					bean.setClose_weekEnd(rs.getString("close_weekEnd"));
					
					String offday = rs.getString("offday");
					if(offday == null) offday = "";
					bean.setOffday(offday);
					
					String recom_menu = rs.getString("recom_menu");
					if(recom_menu == null) recom_menu = "";
					bean.setRecom_menu(recom_menu);
					
					String intro_text = rs.getString("intro_text");
					if(intro_text == null) intro_text = "";
					bean.setIntro_text(intro_text);
					
					bean.setDiscount(rs.getInt("discount"));
					bean.setIsParking(rs.getInt("isParking"));
					bean.setIsSeats(rs.getInt("isSeats"));
					
					bean.setLat(rs.getDouble("lat"));
					bean.setLng(rs.getDouble("lng"));
					bean.setDistance(rs.getDouble("distance"));
					
					vlist.add(bean);
				}
				
			} catch(CommunicationsException ce) {
				vlist = getWithinFranchList(type, url_now, lindex);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return vlist;
		}	
		//가맹점 통합검색(구버전)
		public Vector<FranchiseListBean> researchFranch(String url_now, String text, int lindex, int type){
			Connection con = null;
			PreparedStatement pstmt = null;
			String sql = null;
			ResultSet rs = null;
			Vector<FranchiseListBean> vlist = new Vector<FranchiseListBean>();
			int province = 0;
			double lat = 0, lng = 0;
			String search_text = text;
			try {
				con = pool.getConnection();
				
				sql = "SELECT b.province, s.lat, s.lng "
					+ "FROM agent AS a, branch AS b, shop AS s "
					+ "WHERE a.br_url = b.url AND a.idx = s.agent_idx AND s.url = ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url_now);
				rs = pstmt.executeQuery();

				if(rs.next()) {
					province = rs.getInt("province");
					lat = rs.getDouble("lat");
					lng = rs.getDouble("lng");
				}
				pstmt.close();
				rs.close();
				
				String where_type = "";
				if(type != 0) {
					where_type = " AND type="+type;
				}
				
				
				sql = "SELECT s.*, 6371*acos( cos(radians(?)) * cos(radians(s.lat)) * cos(radians(s.lng) - radians(?)) "
					+ "+ sin(radians(?)) * sin(radians(s.lat)) )*1000 AS distance "
					+ "FROM shop AS s, shop_tag AS t, agent AS a, branch AS b, shop_menu AS m "
					+ "WHERE s.url NOT IN (?) AND "
					+ "( s.shop_name LIKE ? OR s.shop_addr LIKE ? OR s.recom_menu LIKE ? OR s.intro_text LIKE ? OR "
					+ "m.menu_name LIKE ? OR (t.tag LIKE ? AND t.shop_idx = s.idx) ) AND b.province = ? "
					+ "AND s.agent_idx = a.idx AND a.br_url = b.url AND s.idx = m.shop_idx "+where_type
					+ " GROUP BY s.idx ORDER BY distance LIMIT "+lindex+", 6";
				
				pstmt = con.prepareStatement(sql);
				pstmt.setDouble(1, lat);
				pstmt.setDouble(2, lng);
				pstmt.setDouble(3, lat);
				pstmt.setString(4, url_now);
				
				pstmt.setString(5, "%"+search_text+"%");
				pstmt.setString(6, "%"+search_text+"%");
				pstmt.setString(7, "%"+search_text+"%");
				pstmt.setString(8, "%"+search_text+"%");
				pstmt.setString(9, "%"+search_text+"%");
				pstmt.setString(10, "%"+search_text+"%");
				pstmt.setInt(11, province);
					
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					FranchiseListBean bean = new FranchiseListBean();
					bean.setIdx(rs.getInt("idx"));
					bean.setUrl(rs.getString("url"));
					bean.setShop_name(rs.getString("shop_name"));
					bean.setType(rs.getInt("type"));
			
					bean.setShop_phone(rs.getString("shop_phone"));
					bean.setShop_addr(rs.getString("shop_addr"));
					
					bean.setOpen_weekDay(rs.getString("open_weekDay"));
					bean.setClose_weekDay(rs.getString("close_weekDay"));
					bean.setOpen_weekEnd(rs.getString("open_weekEnd"));
					bean.setClose_weekEnd(rs.getString("close_weekEnd"));
					
					String intro_text = rs.getString("intro_text");
					if(intro_text == null) intro_text = "";
					bean.setIntro_text(intro_text);
					
					bean.setDiscount(rs.getInt("discount"));
					bean.setIsParking(rs.getInt("isParking"));
					bean.setIsSeats(rs.getInt("isSeats"));

					bean.setDistance(rs.getDouble("distance"));
					
					vlist.add(bean);
				}
			} catch(CommunicationsException ce) {
				researchFranch(url_now, text, lindex, type);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				pool.freeConnection(con, pstmt, rs);
			}
			return vlist;
		}
}
