package connectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;

public class SaleMgr {
	private DBConnectionMgr pool;
	
	public SaleMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	//번개할인 - 같은 지역내 모든 가맹점 할인 정보
	public Vector<SaleJoinBean> getSaleListLocationally(String url){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<SaleJoinBean> vlist = new Vector<SaleJoinBean>();
		
		try {
			con = pool.getConnection();
			sql = "SELECT s.idx, s.url, s.shop_name, ss.date_start, ss.date_end, ss.menu, ss.dc_rate FROM shop_sale AS ss "
				+ "LEFT JOIN shop AS s ON s.url = ss.url "
				+ "WHERE FLOOR(s.location_code/100) = FLOOR((SELECT location_code FROM shop WHERE url = ?)/100)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				SaleJoinBean bean = new SaleJoinBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setUrl(rs.getString("url"));
				bean.setShop_name(rs.getString("shop_name"));
				bean.setDate_start(rs.getString("date_start"));
				bean.setDate_end(rs.getString("date_end"));
				bean.setMenu(rs.getString("menu"));
				bean.setDc_rate(rs.getInt("dc_rate"));
				
				vlist.add(bean);			
			}
			
		} catch(CommunicationsException ce) {
			getSaleListLocationally(url);
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	//번개할인 정보 (업소정보 메뉴에서 번개할인 보기)
	public SaleBean getSale(int idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		SaleBean sale = new SaleBean();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_sale WHERE idx = "+idx;
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				sale.setIdx(rs.getInt("idx"));
				sale.setUrl(rs.getString("url"));
				sale.setDate_start(rs.getString("date_start"));
				sale.setDate_end(rs.getString("date_end"));
				sale.setMenu(rs.getString("menu"));
				sale.setDc_rate(rs.getInt("dc_rate"));
				sale.setEtc(rs.getString("etc"));
			}
			
		} catch(CommunicationsException ce) {
			getSale(idx);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sale;
	}
	
	
	//번개할인 관리(한 가맹점의 번개할인 정보)
	public SaleBean getSale(String url) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		SaleBean sale = new SaleBean();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_sale WHERE url = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				sale.setIdx(rs.getInt("idx"));
				sale.setUrl(rs.getString("url"));
				sale.setDate_start(rs.getString("date_start"));
				sale.setDate_end(rs.getString("date_end"));
				sale.setMenu(rs.getString("menu"));
				sale.setDc_rate(rs.getInt("dc_rate"));
				sale.setEtc(rs.getString("etc"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return sale;
	}
	
	//번개할인 등록
	public void insertSale(SaleBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "INSERT INTO shop_sale (url, date_start, date_end, menu, dc_rate, etc) VALUES (?, ?, ?, ?, ?, ?)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getUrl());
			pstmt.setString(2, bean.getDate_start());
			pstmt.setString(3, bean.getDate_end());
			pstmt.setString(4, bean.getMenu());
			pstmt.setInt(5, bean.getDc_rate());
			pstmt.setString(6, bean.getEtc());
			
			pstmt.execute();
		} catch(CommunicationsException ce) {
			insertSale(bean);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//번개할인 삭제
	public void deleteSale(int idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "DELETE FROM shop_sale WHERE idx="+idx;
			
			pstmt = con.prepareStatement(sql);
			pstmt.execute();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//번개할인 수정
	public void updateSale(SaleBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "UPDATE shop_sale SET date_start=?, date_end=?, menu=?, dc_rate=?, etc=? WHERE idx=?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getDate_start());
			pstmt.setString(2, bean.getDate_end());
			pstmt.setString(3, bean.getMenu());
			pstmt.setInt(4, bean.getDc_rate());
			pstmt.setString(5, bean.getEtc());
			pstmt.setInt(6, bean.getIdx());
			pstmt.execute();
			
		} catch (CommunicationsException ce) {
			updateSale(bean);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//기간 만료된 번개할인 삭제
	public void deleteExpiredSale() {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "DELETE FROM shop_sale WHERE now()>date_end";
			
			pstmt = con.prepareStatement(sql);
			pstmt.execute();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
}
