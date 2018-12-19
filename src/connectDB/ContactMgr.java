package connectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;

public class ContactMgr {
	private DBConnectionMgr pool;
	
	public ContactMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public String getContactNumber(String c_param) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		String contact_number = "";
		try {
			con = pool.getConnection();
			sql = "SELECT contact_number FROM found_contact WHERE c_param = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, c_param);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				contact_number = rs.getString(1);
			}
		} catch(CommunicationsException ce) {
			getContactNumber(c_param);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return contact_number;
	}
}
