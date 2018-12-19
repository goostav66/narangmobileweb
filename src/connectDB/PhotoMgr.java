package connectDB;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;
import com.oreilly.servlet.MultipartRequest;

public class PhotoMgr {
	private DBConnectionMgr pool; 
	
	public PhotoMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	//업소 사진 가져오기
	public Vector<PhotoBean> getPhotoList(int shop_idx){
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		Vector<PhotoBean> vlist = new Vector<PhotoBean>();
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_photo WHERE shop_idx = ? ORDER BY photo_order";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, shop_idx);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				PhotoBean bean = new PhotoBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setShop_idx(rs.getInt("shop_idx"));
				bean.setPhoto_url(rs.getString("photo_url"));
				bean.setPhoto_order(rs.getInt("photo_order"));
				vlist.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	public void insertPhoto(int shop_idx, MultipartRequest multi, String db_photo_url) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "INSERT INTO shop_photo (shop_idx, photo_url, photo_order) VALUES (?, ?, ?)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, shop_idx);
			pstmt.setString(2, db_photo_url+multi.getFilesystemName("file"));
			pstmt.setInt(3, Integer.parseInt(multi.getParameter("bog")));
			
			pstmt.execute();
			
		} catch (CommunicationsException ce) {
			insertPhoto(shop_idx, multi, db_photo_url);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	public void orderingPhoto(int shop_photo_idx, int bog) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "UPDATE shop_photo SET photo_order = ? WHERE idx = ?";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setInt(1, bog);
			pstmt.setInt(2, shop_photo_idx);
			pstmt.execute();
			
		} catch (CommunicationsException ce) {
			orderingPhoto(shop_photo_idx, bog);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	public void deletePhoto(int idx, String path) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection();
			sql = "SELECT photo_url FROM shop_photo WHERE idx = "+idx;
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			String photo_url = "";
			if(rs.next()) photo_url = rs.getString(1);
			
			pstmt.close();
			
			if(photo_url !=null && !photo_url.equals("") && photo_url.startsWith("hanjicds001", 7)) {
				String fileName = photo_url.substring(photo_url.lastIndexOf("/"));
				File file = new File(path+fileName);
				if(file.exists()) { file.delete(); } else { /*파일이 존재하지 않음*/ }
			} else { /*웹서버 업로드된 파일*/ 
				sql = "INSERT INTO trim_shop_photo (photo_url, edit_date) VALUES (?, NOW())";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, photo_url);
				pstmt.execute();
			}
			
			sql = "DELETE FROM shop_photo WHERE idx="+idx;
			pstmt = con.prepareStatement(sql);
			pstmt.execute();
			
		} catch(CommunicationsException ce) {
			deletePhoto(idx, path);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
	}
	
	//메인사진만 가져오기
	public PhotoBean getMainPhoto(int shop_idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		PhotoBean bean = new PhotoBean();
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_photo WHERE shop_idx = ? AND photo_order = 1";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, shop_idx);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				bean.setIdx(rs.getInt("idx"));
				bean.setShop_idx(rs.getInt("shop_idx"));
				bean.setPhoto_url(rs.getString("photo_url"));
				bean.setPhoto_order(rs.getInt("photo_order"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}
	
	
	//모바일에서 업로드 되고 웹서버(103.60.124.17)에서 삭제된 파일 삭제 
	public void trimShopFile(String path) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM trim_shop_photo";
			pstmt = con.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String shop_photo = rs.getString("photo_url");
				if(shop_photo.startsWith("hanjicds001", 7)) {
					String fileName = shop_photo.substring(shop_photo.lastIndexOf("/"));
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
