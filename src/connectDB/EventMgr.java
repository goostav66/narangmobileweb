package connectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.swing.plaf.PopupMenuUI;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class EventMgr {
	private DBConnectionMgr pool;
	
	public EventMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	//진행중 이벤트 - 같은 지역 내 모든 가맹점 이벤트 정보
	public Vector<EventListBean> getEventListLocationally(String url){
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		Vector<EventListBean> vlist = new Vector<EventListBean>();
		
		try {
			con = pool.getConnection();
			sql = "SELECT s.idx AS shop_idx, s.shop_name, se.url, se.background_img, se.message, se.date_start, se.date_end " 
				+ "FROM shop_event AS se " 
				+ "LEFT JOIN shop AS s on se.url = s.url " 
				+ "WHERE FLOOR(s.location_code/100) = FLOOR( (select location_code FROM shop where url = ?) / 100 ) "
				+ "AND se.isFloating = 1 " 
				+ "AND CURDATE() BETWEEN date_start AND date_end "
				+ "ORDER BY se.date_start DESC";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				EventListBean bean = new EventListBean();
				bean.setShop_idx(rs.getInt("shop_idx"));
				bean.setShop_name(rs.getString("shop_name"));
				bean.setUrl(rs.getString("url"));
				bean.setBackground_img(rs.getString("background_img"));
				bean.setMessage(rs.getString("message"));
				bean.setDate_start(rs.getString("date_start"));
				bean.setDate_end(rs.getString("date_end"));
				vlist.add(bean);
			}
		} catch (CommunicationsException ce) {
			getEventListLocationally(url);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist; 
		
	}
	
	//진행중 이벤트 - 같은 지역 내 모든 가맹점 팝업 정보
	public Vector<EventListBean> getPopupListAllUrl(String url){
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		Vector<EventListBean> vlist = new Vector<EventListBean>();
		int province = 0;
		try {
			con = pool.getConnection();
			sql = "SELECT b.province FROM agent AS a, branch AS b, shop AS s "
				+ "WHERE a.br_url = b.url AND a.idx = s.agent_idx AND s.url = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				province = rs.getInt(1);
			}
			
			pstmt.close();
			rs.close();
			
			sql = "SELECT s.idx AS shop_idx, s.shop_name, p.url, p.background_img, p.message, p.date_start, p.date_end "
				+ "FROM shop AS s, shop_event AS p, branch AS b, agent AS a "
				+ "WHERE b.province = ? AND s.agent_idx = a.idx AND a.br_url = b.url AND p.url = s.url "
				+ "AND p.isFloating=1 AND (CURDATE() BETWEEN date_start AND date_end) "
				+ "ORDER BY p.date_start DESC";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, province);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				EventListBean bean = new EventListBean();
				bean.setShop_idx(rs.getInt("shop_idx"));
				bean.setShop_name(rs.getString("shop_name"));
				bean.setUrl(rs.getString("url"));
				bean.setBackground_img(rs.getString("background_img"));
				bean.setMessage(rs.getString("message"));
				bean.setDate_start(rs.getString("date_start"));
				bean.setDate_end(rs.getString("date_end"));
				vlist.add(bean);
			}
		} catch(CommunicationsException ce) {
			getPopupListAllUrl(url);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	//팝업 관리 - 한 가맹점의 모든 팝업 정보
	public Vector<EventBean> getPopupList(String url){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<EventBean> vlist = new Vector<EventBean>();
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_event WHERE url=? ORDER BY date_start DESC";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				EventBean bean = new EventBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setUrl(url);
				bean.setBackground_img(rs.getString("background_img"));
				bean.setMessage(rs.getString("message"));
				bean.setDate_start(rs.getString("date_start"));
				bean.setDate_end(rs.getString("date_end"));
				bean.setIsFloating(rs.getInt("isFloating"));		
				vlist.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
			vlist = getPopupList(url);
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}
	
	//메인페이지 - 한 가맹점의 현재 표시중인 팝업
	public Vector<EventBean> getPopupListNow(String url){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<EventBean> vlist = new Vector<EventBean>();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_event WHERE url=? AND (CURDATE() BETWEEN date_start AND date_end) AND isFloating=1";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				EventBean bean = new EventBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setUrl(url);
				bean.setBackground_img(rs.getString("background_img"));
				bean.setMessage(rs.getString("message"));
				bean.setDate_start(rs.getString("date_start"));
				bean.setDate_end(rs.getString("date_end"));
				bean.setIsFloating(rs.getInt("isFloating"));
				vlist.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}

	//1개 팝업 정보
	public EventBean getPopup(int idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		EventBean bean = new EventBean();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_event WHERE idx="+idx;
			
			pstmt = con.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				bean.setIdx(rs.getInt("idx"));
				bean.setUrl(rs.getString("url"));
				bean.setBackground_img(rs.getString("background_img"));
				bean.setMessage(rs.getString("message"));
				bean.setDate_start(rs.getString("date_start"));
				bean.setDate_end(rs.getString("date_end"));
				bean.setIsFloating(rs.getInt("isFloating"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return bean;
	}

	//팝업 추가
	public void insertEvent(EventBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
			
		try {
			con = pool.getConnection();
			sql = "INSERT INTO shop_event (url, background_img, message, date_start, date_end, isFloating) VALUES(?, ?, ?, ?, ?, 1)";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getUrl());
			pstmt.setString(2, bean.getBackground_img());
			pstmt.setString(3, bean.getMessage());
			pstmt.setString(4, bean.getDate_start());
			pstmt.setString(5, bean.getDate_end());
			pstmt.executeUpdate();
		} catch(CommunicationsException ce) {
			insertEvent(bean);	
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//이벤트 시작날짜 변경
	public void updateDateStart(int idx, String date_start) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "UPDATE shop_event SET date_start = ? WHERE idx = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, date_start);
			pstmt.setInt(2, idx);
			
			pstmt.execute();
			
		} catch (CommunicationsException ce) {
			updateDateStart(idx, date_start);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//이벤트 종료날짜 변경
	public void updateDateEnd(int idx, String date_end) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "UPDATE shop_event SET date_end = ? WHERE idx = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, date_end);
			pstmt.setInt(2, idx);
			
			pstmt.execute();
			
		} catch (CommunicationsException ce) {
			updateDateEnd(idx, date_end);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//이벤트 내용 변경
	public void updateMessage(int idx, String message, String background_img) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "UPDATE shop_event SET message = ?, background_img = ? WHERE idx = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, message);
			pstmt.setString(2, background_img);
			pstmt.setInt(3, idx);
			
			pstmt.execute();
			
		} catch(CommunicationsException ce) {
			updateMessage(idx, message, background_img);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//팝업 수정
	public void modifyPopup(EventBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "UPDATE shop_event SET background_img=?, message=?, date_start=?, date_end=? WHERE idx=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, bean.getBackground_img());
			pstmt.setString(2, bean.getMessage());
			pstmt.setString(3, bean.getDate_start());
			pstmt.setString(4, bean.getDate_end());
			pstmt.setInt(5, bean.getIdx());
			
			pstmt.execute();
			
		} catch (CommunicationsException ce) {
			modifyPopup(bean);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//팝업 띄우기/해제
	public void toggleFloating(int idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "UPDATE shop_event SET isFloating = IF(isFloating = 1, 0, 1) WHERE idx=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, idx);
			pstmt.execute();
		} catch (CommunicationsException ce) {
			toggleFloating(idx);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	//이벤트 삭제
	public void deleteEvent(int idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "DELETE FROM shop_event WHERE idx="+idx;
			pstmt = con.prepareStatement(sql);
			pstmt.execute();
			
		} catch(CommunicationsException ce) {
			deleteEvent(idx);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
}
