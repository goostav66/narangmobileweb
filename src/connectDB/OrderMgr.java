package connectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;

public class OrderMgr {
	private DBConnectionMgr pool;
	
	public OrderMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public Vector<OrderBean> getOrderList(int shop_idx) {
		Connection con = null;
		String sql = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Vector<OrderBean> vlist = new Vector<OrderBean>();
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_order WHERE shop_idx="+shop_idx;
			pstmt = con.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				OrderBean bean = new OrderBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setShop_idx(rs.getInt("shop_idx"));
				bean.setOrder_table(rs.getInt("order_table"));
				bean.setOrder_menu(rs.getInt("order_menu"));
				bean.setOrder_quant(rs.getInt("order_quan"));
				bean.setOrder_total(rs.getInt("order_total"));
				bean.setOrder_date(rs.getString("order_date"));
				vlist.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}	
		return vlist;
	}
	
	public void insertOrder(OrderBean bean) {
		Connection con = null;
		String sql = null;
		PreparedStatement pstmt = null;
		
		try {
		con = pool.getConnection();
				
		
		sql = "INSERT INTO shop_order (shop_idx, order_table, order_menu, order_quant, order_total, order_date)"
				+ "VALUES (?, ?, ?, ?, ?, NOW())";
		pstmt = con.prepareStatement(sql);
		
		pstmt.setInt(1, bean.getShop_idx());
		pstmt.setInt(2, bean.getOrder_table());
		pstmt.setInt(3, bean.getOrder_menu());
		pstmt.setInt(4, bean.getOrder_quant());
		pstmt.setInt(5, bean.getOrder_total());
		
		pstmt.execute();
		} catch (CommunicationsException ce) {
			insertOrder(bean);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
