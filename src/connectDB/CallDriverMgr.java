package connectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;

public class CallDriverMgr {
	private DBConnectionMgr pool;
	
	public CallDriverMgr() {
		pool = DBConnectionMgr.getInstance();
	}

	public Vector<CallDriverBean> getCallList(String url, String start_date, String end_date){
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		Vector<CallDriverBean> vlist = new Vector<CallDriverBean>();
		
		try {
			con = pool.getConnection();
			if( (start_date==null || start_date.equals("")) && (end_date==null || end_date.equals("")) ) {
				sql = "SELECT credate, add_call FROM calldrivertb WHERE url = ? AND YEAR(credate)=YEAR(NOW()) AND MONTH(credate)=MONTH(NOW()) AND state = 'S' ORDER BY credate DESC ";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url);
			} else if( (start_date==null || start_date.equals("")) ) {
				sql = "SELECT credate, add_call FROM calldrivertb WHERE url = ? AND state = 'S' AND credate >= 0 AND credate <= ? ORDER BY credate DESC";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url);
				pstmt.setString(2, end_date);
			} else if( (end_date==null || end_date.equals("")) ){
				sql = "SELECT credate, add_call FROM calldrivertb WHERE url = ? AND state = 'S' AND credate >= ? AND credate <= CURDATE() ORDER BY credate DESC";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url);
				pstmt.setString(2, start_date);
			} else{
				sql = "SELECT credate, add_call FROM calldrivertb WHERE url = ? AND state = 'S' AND (credate >= ? AND credate <= ?) ORDER BY credate DESC";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url);
				pstmt.setString(2, start_date);
				pstmt.setString(3, end_date);
			}
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				CallDriverBean bean = new CallDriverBean();
				bean.setCredate(rs.getString("credate"));
				bean.setAdd_call(rs.getInt("add_call"));
				vlist.add(bean);
			}
		} catch(CommunicationsException ce) {
			getCallList(url,start_date, end_date);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return vlist;
	}
	
	//누적콜수 구하기 : 모든 행 add_call+1의 합
	public int getCallCount(String url, String start_date, String end_date) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		int count = 0;
		
		try {
			con = pool.getConnection();
			if( (start_date==null || start_date.equals("")) && (end_date==null || end_date.equals(""))) {
				sql = "SELECT SUM(add_call+1) FROM calldrivertb WHERE url = ? AND YEAR(credate)=YEAR(NOW()) AND MONTH(credate)=MONTH(NOW()) AND state = 'S'";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url);	
			} else if( (start_date==null || start_date.equals("")) ) {
				sql = "SELECT SUM(add_call+1) FROM calldrivertb WHERE url = ? AND state = 'S' AND credate >= 0 AND credate <= ?";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url);
				pstmt.setString(2, end_date);
			} else if( (end_date==null || end_date.equals("")) ){
				sql = "SELECT SUM(add_call+1) FROM calldrivertb WHERE url = ? AND state = 'S' AND credate >= ? AND credate <= CURDATE()";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url);
				pstmt.setString(2, start_date);
			} else {
				sql = "SELECT SUM(add_call+1) FROM calldrivertb WHERE url = ? AND state = 'S' AND (credate >= ? AND credate <= ?)";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, url);
				pstmt.setString(2, start_date);
				pstmt.setString(3, end_date);
			}
			rs = pstmt.executeQuery();
			if(rs.next()) 
				count = rs.getInt(1);
				
		} catch(CommunicationsException ce) {
			getCallCount(url, start_date, end_date);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return count;
	}
	
	public int getCarriedCount(String url) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		int carried_count = 0;
		
		try {
			con = pool.getConnection();
			sql = "SELECT SUM(add_call+1) FROM calldrivertb WHERE url = ? AND state = 'S' AND YEAR(credate) = YEAR(NOW()) AND MONTH(credate) = MONTH(NOW())-1 ";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				if(rs.getInt(1) > 15) {
					carried_count = rs.getInt(1) - 15;
				}
			}
			
		} catch(CommunicationsException ce) {
			getCarriedCount(url);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return carried_count;
	}
}
