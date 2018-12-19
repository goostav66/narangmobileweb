package connectDB;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Vector;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;

public class GuestMgr {
	private DBConnectionMgr pool;
		
	public static String[] EMOTICON = {"reply_emo_1.png", "reply_emo_2.png", "reply_emo_3.png", "reply_emo_4.png"};	
		
	public GuestMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	//´ñ±Û ¸ñ·Ï 
	public Vector<GuestBean> getCommentList(String url){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		Vector<GuestBean> vlist = new Vector<GuestBean>();
				
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM reply WHERE url=? ORDER BY credate desc";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				GuestBean bean = new GuestBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setUrl(url);
				bean.setMsg(rs.getString("msg"));
				bean.setCredate(rs.getTimestamp("credate"));
				bean.setEmoticon(rs.getInt("emoti"));
				bean.setPhone(rs.getString("phone"));
				vlist.add(bean);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		
		return vlist;
	}

	//´ñ±Û °¹¼ö ºÒ·¯¿À±â
	public int getCommontCount(String url) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		int count = 0;
		
		try {
			con = pool.getConnection();
			sql = "SELECT count(idx) FROM reply WHERE url=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		
		return count;
	}
	
	//´ñ±Û Ãß°¡ ÇÏ±â
	public void insertComment(GuestBean bean, Vector<String> files, String path) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		try {
			con = pool.getConnection();
			sql = "INSERT INTO reply (url, msg, credate, emoti, phone) VALUES (?, ?, now(), ?, ?)";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, bean.getUrl());
			pstmt.setString(2, bean.getMsg());
			pstmt.setInt(3, bean.getEmoticon());
			pstmt.setString(4, bean.getPhone());
			pstmt.execute();
			pstmt.close();
			
			sql = "SELECT MAX(idx) FROM reply";
			pstmt = con.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				int idx = rs.getInt(1);
				for(int i = 0; i<files.size(); i++) {
					String file = files.get(i);
					if(file != null) {
						sql = "INSERT INTO reply_photo (reply_idx, photo_url) VALUES (?, ?)";
						pstmt = con.prepareStatement(sql);
						pstmt.setInt(1, idx);
						pstmt.setString(2, path+file);
						pstmt.execute();
					}
				}
			}
		} catch(CommunicationsException ce) {
			insertComment(bean, files, path);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
	}
	
	public Vector<GuestPhotoBean> getPhotoList(int reply_idx){
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		Vector<GuestPhotoBean> gpList = new Vector<GuestPhotoBean>();
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM reply_photo WHERE reply_idx="+reply_idx;
			pstmt = con.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
		
			while(rs.next()) {
				GuestPhotoBean gpBean = new GuestPhotoBean();
				gpBean.setIdx(rs.getInt("idx"));
				gpBean.setReply_idx(rs.getInt("reply_idx"));
				gpBean.setPhoto_url(rs.getString("photo_url"));
				gpList.add(gpBean);
			}
		} catch (Exception e) { 
			e.printStackTrace(); 
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return gpList;
	}
	
	//´ñ±Û »èÁ¦ 
	public void deleteReply(int reply_idx, String path) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM reply_photo WHERE reply_idx = "+reply_idx;
			
			pstmt = con.prepareStatement(sql, ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				String photo_url = rs.getString("photo_url");
				File file = new File(path+photo_url.substring(photo_url.lastIndexOf("/")));
				
				if(file.exists()) file.delete();
				rs.deleteRow();
			}
			
			pstmt.close();
			
			sql = "DELETE FROM reply WHERE idx = "+reply_idx;
			pstmt = con.prepareStatement(sql);
			
			pstmt.execute();
			
		} catch (CommunicationsException ce) {
			deleteReply(reply_idx, path);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
	}
	
	public void trimReplyPhoto(String filePath) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		ResultSet rs = null;
		
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM reply_photo AS rp WHERE reply_idx "
					+ "NOT IN (SELECT DISTINCT (r.idx) FROM reply_photo AS rp, reply AS r WHERE rp.reply_idx = r.idx)";
			pstmt = con.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				String photo_url = rs.getString("photo_url");
				String fileName = photo_url.substring(photo_url.lastIndexOf("/"));
				File file = new File(filePath+fileName);
				if(file.exists()) file.delete();
				sql = "DELETE FROM reply_photo WHERE idx="+rs.getInt("idx");
				pstmt = con.prepareStatement(sql);
				pstmt.execute();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
	}
}	
