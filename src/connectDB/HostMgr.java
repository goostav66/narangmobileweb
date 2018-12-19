package connectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class HostMgr {
	private DBConnectionMgr pool;
	
	public HostMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public boolean login(String url, String password) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql;
		ResultSet rs = null;
		boolean login = false;
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_host WHERE url=? AND pass=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			pstmt.setString(2, password);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				login = true;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return login;
	}
	
	public void updatePass(String url, String password) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql;
		
		try {
			con = pool.getConnection();
			sql = "UPDATE shop_host SET pass=? WHERE url=?";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, password);
			pstmt.setString(2, url);
			
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			updatePass(url, password);
		} finally {
			pool.freeConnection(con, pstmt);
		}
		
	}
}
