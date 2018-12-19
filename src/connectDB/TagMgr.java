package connectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;

public class TagMgr {
	DBConnectionMgr pool;
	
	public TagMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public Vector<TagBean> getTagList(int shop_idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		Vector<TagBean> vlist = new Vector<TagBean>();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_tag WHERE shop_idx="+shop_idx;
			
			pstmt = con.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				TagBean bean = new TagBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setShop_idx(rs.getInt("shop_idx"));
				bean.setTag(rs.getString("tag"));
				
				vlist.add(bean);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	public void insertTag(int shop_idx, String tag_new) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "INSERT INTO shop_tag (shop_idx, tag) VALUES (?, ?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, shop_idx);
			pstmt.setString(2, tag_new);
			
			pstmt.execute();
			
		} catch(CommunicationsException ce) {
			insertTag(shop_idx, tag_new);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void deleteTag(int idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "DELETE FROM shop_tag WHERE idx="+idx;
			pstmt = con.prepareStatement(sql);
			pstmt.execute();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
