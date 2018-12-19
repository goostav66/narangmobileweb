package connectDB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Vector;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;

public class BoardMgr {
	private DBConnectionMgr pool;
	
	public static final SimpleDateFormat TIME_TO_POST = new SimpleDateFormat("yyyy³â M¿ù dÀÏ hh:mm");
	
	public BoardMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public Vector<BoardBean> getBoardList(String url){
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<BoardBean> vlist = new Vector<BoardBean>();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_board WHERE url=? ORDER BY regdate DESC";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				BoardBean bean = new BoardBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setUrl(rs.getString("url"));
				bean.setContent(rs.getString("content"));
				bean.setRegdate(rs.getTimestamp("regdate"));
				
				vlist.add(bean);
			}
			
		} catch(CommunicationsException ce) {
			vlist = getBoardList(url);
		} catch (Exception e) {
			e.printStackTrace();			
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return vlist;
	}

	public BoardBean getBoard(int idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		BoardBean bean = new BoardBean();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_board WHERE idx ="+idx;
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				bean.setIdx(rs.getInt("idx"));
				bean.setUrl(rs.getString("url"));
				bean.setContent(rs.getString("content"));
				bean.setRegdate(rs.getTimestamp("regdate"));
			}
		} catch (CommunicationsException ce) {
			getBoard(idx);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		
		return bean;
		
	}
	public void insertBoard(BoardBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		try {
			con = pool.getConnection();
			sql = "INSERT INTO shop_board (url, content, regdate) VALUES (?, ?, now())";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, bean.getUrl());
			pstmt.setString(2, bean.getContent());
			
			pstmt.executeUpdate();
			
		} catch (CommunicationsException ce) {
			insertBoard(bean);
		} catch (Exception e) {
			e.printStackTrace();
			
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	public void deleteBoard(int idx) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "DELETE FROM shop_board WHERE idx="+idx;
			pstmt = con.prepareStatement(sql);
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}

	public void updateBoard(BoardBean bean) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		boolean flag = false;
		try {
			con = pool.getConnection();
			sql = "UPDATE shop_board SET content=? WHERE idx=?";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, bean.getContent());
			pstmt.setInt(2, bean.getIdx());	
			pstmt.executeUpdate();
			
		} catch (CommunicationsException ce) {
			updateBoard(bean);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}	
	}
}
