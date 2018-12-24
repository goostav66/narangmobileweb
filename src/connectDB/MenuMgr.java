package connectDB;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.NumberFormat;
import java.util.Locale;
import java.util.Vector;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;
import com.oreilly.servlet.MultipartRequest;

public class MenuMgr {
	private DBConnectionMgr pool;

	public MenuMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public String intToPrice(int price){
		long number = price;
		return NumberFormat.getNumberInstance(Locale.US).format(number);
	}
	
	//가맹점 메뉴 모든 목록 가져오기
	public Vector<MenuBean> getMenuList(int shop_idx){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<MenuBean> vlist = new Vector<MenuBean>();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_menu WHERE shop_idx = ? ORDER BY menu_order";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, shop_idx);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				MenuBean bean = new MenuBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setShop_idx(rs.getInt("shop_idx"));
				bean.setMenu_name(rs.getString("menu_name"));
				bean.setMenu_type(rs.getInt("menu_type"));
				bean.setMenu_infor(rs.getString("menu_infor"));
				bean.setPrice(rs.getInt("price"));
				bean.setPrice_s(rs.getInt("price_s"));
				bean.setPrice_m(rs.getInt("price_m"));
				bean.setPrice_l(rs.getInt("price_l"));
				String menu_photo= rs.getString("menu_photo");

				bean.setMenu_photo(menu_photo);
				bean.setMenu_order(rs.getInt("menu_order"));
				vlist.add(bean);
			}
			
		} catch(CommunicationsException ce) {
			vlist = getMenuList(shop_idx);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		return vlist;	
	}
	//가맹점 메뉴 타입별로 가져오기
	public Vector<MenuBean> getMenuList(int shop_idx, int menu_type){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<MenuBean> vlist = new Vector<MenuBean>();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_menu WHERE shop_idx = ? AND menu_type = ? ORDER BY menu_order";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, shop_idx);
			pstmt.setInt(2, menu_type);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				MenuBean bean = new MenuBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setShop_idx(rs.getInt("shop_idx"));
				bean.setMenu_name(rs.getString("menu_name"));
				bean.setMenu_type(rs.getInt("menu_type"));
				bean.setMenu_infor(rs.getString("menu_infor"));
				bean.setPrice(rs.getInt("price"));
				bean.setPrice_s(rs.getInt("price_s"));
				bean.setPrice_m(rs.getInt("price_m"));
				bean.setPrice_l(rs.getInt("price_l"));
				String menu_photo= rs.getString("menu_photo");
				
				bean.setMenu_photo(menu_photo);
				bean.setMenu_order(rs.getInt("menu_order"));
				vlist.add(bean);
			}
			
		} catch (Exception e) { 
			e.printStackTrace(); 
		} finally { pool.freeConnection(con, pstmt); }
			return vlist;	
	}

	public MenuBean getMenu(int menu_idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		MenuBean bean = new MenuBean();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_menu WHERE idx="+menu_idx;
			pstmt = con.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				bean.setIdx(rs.getInt("idx"));
				bean.setShop_idx(rs.getInt("shop_idx"));
				bean.setMenu_name(rs.getString("menu_name"));
				bean.setMenu_type(rs.getInt("menu_type"));
				bean.setMenu_infor(rs.getString("menu_infor"));
				bean.setPrice(rs.getInt("price"));
				bean.setPrice_s(rs.getInt("price_s"));
				bean.setPrice_m(rs.getInt("price_m"));
				bean.setPrice_l(rs.getInt("price_l"));
				bean.setMenu_photo(rs.getString("menu_photo"));
				bean.setMenu_order(rs.getInt("menu_order"));
			}
			
		} catch(CommunicationsException ce) {
			getMenu(menu_idx);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
	
	public void insertMenuAsync(int shop_idx, MultipartRequest multi, String db_photo_url) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		int price = 0, price_s = 0, price_m = 0, price_l = 0;
		String menu_photo = null;
		
		if(multi.getParameter("price") != null) price = Integer.parseInt(multi.getParameter("price"));
		if(multi.getParameter("price_s") != null) price_s = Integer.parseInt(multi.getParameter("price_s"));
		if(multi.getParameter("price_m") != null) price_m = Integer.parseInt(multi.getParameter("price_m"));
		if(multi.getParameter("price_l") != null) price_l = Integer.parseInt(multi.getParameter("price_l"));
		
		if(multi.getFilesystemName("menu_photo") != null)
			menu_photo = db_photo_url+multi.getFilesystemName("menu_photo");
		
		try {
			con = pool.getConnection();
			
		
			sql = "INSERT INTO shop_menu (shop_idx, menu_name, menu_type, menu_infor, price, price_s, price_m, price_l, menu_photo, menu_order) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, shop_idx);
			pstmt.setString(2, multi.getParameter("menu_name"));
			pstmt.setInt(3, Integer.parseInt(multi.getParameter("menu_type")));
			pstmt.setString(4, multi.getParameter("menu_infor"));
			pstmt.setInt(5, price);
			pstmt.setInt(6, price_s);
			pstmt.setInt(7, price_m);
			pstmt.setInt(8, price_l);
			pstmt.setString(9, menu_photo);
			pstmt.setInt(10, Integer.parseInt(multi.getParameter("menu_order")));
			pstmt.execute();
			
		} catch(CommunicationsException ce) {
			insertMenuAsync(shop_idx, multi, db_photo_url);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	public void updateMenuAsync(MultipartRequest multi, String db_photo_url) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		int price = 0, price_s = 0, price_m = 0, price_l = 0;
		String menu_photo = multi.getParameter("img_src_prev");
		
		if(multi.getParameter("price") != null) price = Integer.parseInt(multi.getParameter("price"));
		if(multi.getParameter("price_s") != null) price_s = Integer.parseInt(multi.getParameter("price_s"));
		if(multi.getParameter("price_m") != null) price_m = Integer.parseInt(multi.getParameter("price_m"));
		if(multi.getParameter("price_l") != null) price_l = Integer.parseInt(multi.getParameter("price_l"));
		
		if(multi.getFilesystemName("menu_photo") != null)
			menu_photo = db_photo_url+multi.getFilesystemName("menu_photo");
		
		try {
			con = pool.getConnection();
			sql = "UPDATE shop_menu SET menu_name = ?, menu_type = ?, menu_infor = ?, "
				+ "price = ?, price_s = ?, price_m = ?, price_l = ?, menu_photo = ?, menu_order = ? WHERE idx = ?";
			
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, multi.getParameter("menu_name"));
			pstmt.setInt(2, Integer.parseInt(multi.getParameter("menu_type")));
			pstmt.setString(3, multi.getParameter("menu_infor"));
			pstmt.setInt(4, price);
			pstmt.setInt(5, price_s);
			pstmt.setInt(6, price_m);
			pstmt.setInt(7, price_l);
			pstmt.setString(8, menu_photo);
			pstmt.setInt(9, Integer.parseInt(multi.getParameter("menu_order")));
			pstmt.setInt(10, Integer.parseInt(multi.getParameter("idx")));
			
			pstmt.execute();
			
		} catch(CommunicationsException ce) {
			updateMenuAsync(multi, db_photo_url);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	public void deleteMenu(int idx, String path) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		try {
			con = pool.getConnection();
			
			sql = "SELECT menu_photo FROM shop_menu WHERE idx="+idx;
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();

			String photo_url = "";
			if(rs.next()) 
				photo_url = rs.getString(1);
			
			pstmt.close();
			if(photo_url != null && !photo_url.equals("") && photo_url.startsWith("hanjicds001", 7)) {
				String fileName = photo_url.substring(photo_url.lastIndexOf("/"));
				File file = new File(path+fileName);
				if(file.exists()) { file.delete(); } else { /*파일이 존재하지 않음*/ } 
			}else { /*웹서버에 업로드된 파일*/	
				sql="INSERT INTO trim_menu_photo (menu_photo, edit_date) VALUES (?, NOW())";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, photo_url);
				pstmt.execute();
			}	
			sql = "DELETE FROM shop_menu WHERE idx="+idx;
			pstmt = con.prepareStatement(sql);
			
			pstmt.executeUpdate();
			
		} catch(CommunicationsException ce) {
			deleteMenu(idx, path);
		} catch (Exception e) {
			e.printStackTrace();	
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	

	//모바일 업로드-웹서버에서 제거된 파일 시스템 관리(메뉴사진)
	public void trimMenuFile(String path) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM trim_menu_photo";
			pstmt = con.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String menu_photo = rs.getString("menu_photo");
				if(menu_photo != null && menu_photo.startsWith("hanjicds001", 7)) {
					String fileName = menu_photo.substring(menu_photo.lastIndexOf("/"));
					File file = new File(path+fileName);
					if(file.exists()) { file.delete(); } 
					rs.deleteRow();
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
	}
}
