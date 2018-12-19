package connectDB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Calendar;
import java.util.Date;
import java.util.Vector;

import com.mysql.jdbc.exceptions.jdbc4.CommunicationsException;

public class DriverMgr {
	private DBConnectionMgr pool;
	
	public DriverMgr() {
		pool = DBConnectionMgr.getInstance();
	}
	
	public void registCallInfo(String src_url) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String sql = null;
		
		try {
			con = pool.getConnection();
			sql = "INSERT "
				+ "INTO shop_driver (d_url, d_status, d_datetime) "
				+ "VALUES (?, ?, NOW())";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, src_url);
			pstmt.setInt(2, 1);
			
			pstmt.execute();
			
		} catch (CommunicationsException ce) {
			registCallInfo(src_url);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt);
		}
		
	}
		
	//대리운전 호출기록 : 요약
	public Vector<CallHistoryBean> getCallListBrief(String url, int year, int month){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		
		Vector<CallHistoryBean> cList = new Vector<CallHistoryBean>();
		try {
			con = pool.getConnection();
			sql = "SELECT MONTH(d_datetime) AS month, DAY(d_datetime) AS day, COUNT(idx) AS cnt "
				+ "FROM shop_driver WHERE d_url = ? AND d_status = 2 AND YEAR(d_datetime) = ? AND MONTH(d_datetime) = ? "
				+ "GROUP BY DAY(d_datetime) "
				+ "ORDER BY d_datetime";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, url);
			pstmt.setInt(2, year);
			pstmt.setInt(3, month);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				CallHistoryBean bean = new CallHistoryBean();
				bean.setMonth(rs.getInt("month"));
				bean.setDay(rs.getInt("day"));
				bean.setCnt(rs.getInt("cnt"));
				cList.add(bean);
			}
		} catch(CommunicationsException ce) {
			getCallListBrief(url, year, month);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return cList;
	}
	
	//대리운전 호출기록 : 상세
	public Vector<DriverBean> getCallListDetail(String url, int year, int month, int day) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		
		Vector<DriverBean> dList = new Vector<DriverBean>();
		try {
			con = pool.getConnection();
			sql = "SELECT * FROM shop_driver "
				+ "WHERE d_url = ? AND d_status = 2 AND YEAR(d_datetime) = ? AND MONTH(d_datetime) = ? AND DAY(d_datetime) = ? "
				+ "ORDER BY d_datetime";
			pstmt = con.prepareStatement(sql);
			
			pstmt.setString(1, url);
			pstmt.setInt(2, year);
			pstmt.setInt(3, month);
			pstmt.setInt(4, day);
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				DriverBean bean = new DriverBean();
				bean.setIdx(rs.getInt("idx"));
				bean.setD_datetime(rs.getString("d_datetime"));
				dList.add(bean);
			}
		} catch(CommunicationsException ce) {
			getCallListDetail(url, year, month, day);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return dList;
	}
	
	//당월 호출횟수(이월횟수 제외)
	public int getTotalCountMonthly(String url, int year, int month) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		int total_count = 0;
		try {
			con = pool.getConnection();
			sql = "SELECT COUNT(idx) FROM shop_driver "
				+ "WHERE d_url = ? AND d_status = 2 AND YEAR(d_datetime) = ? AND MONTH(d_datetime) = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			pstmt.setInt(2, year);
			pstmt.setInt(3, month);
			
			rs = pstmt.executeQuery();
			if(rs.next())
				total_count = rs.getInt(1);
		} catch(CommunicationsException ce) {
			getTotalCountMonthly(url, year, month);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return total_count;
	}
	//이월 횟수 구하기
	public int getCarriedCount(String url, int year, int month) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = null;
		
		int carried_count = 0;
		int heap_year = 0, heap_month = 0;
		try {
			con = pool.getConnection();
			
			//Step 1: 호출 완료 기록이 처음 있는 년월을 구하기
			sql = "SELECT YEAR( MIN(d_datetime) ), MONTH( MIN(d_datetime) ) "
				+ "FROM shop_driver "
				+ "WHERE d_url = ? AND d_status = 2";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, url);
			
			rs = pstmt.executeQuery();
	
			if(rs.next()) {
				heap_year = rs.getInt(1);
				heap_month = rs.getInt(2);
			}
			
			//Step 2: 처음 년월부터 달별 대리운전 호출횟수 구하기
			if(heap_year != 0 && heap_month != 0) {
			
				while( (heap_year < year) || (heap_year == year && heap_month < month) ) {
					
					pstmt.close();
					rs.close();
					sql = "SELECT COUNT(idx) FROM shop_driver "
						+ "WHERE d_url = ? AND d_status = 2 AND YEAR(d_datetime) = ? AND MONTH(d_datetime) = ?";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, url);
					pstmt.setInt(2, heap_year);
					pstmt.setInt(3, heap_month);
					
					rs = pstmt.executeQuery();
					
					if(rs.next()) {
						//Step 3: 해당 달의 호출횟수와 이월된 횟수가 15보다 크면 이월횟수(carried_count)에 저장
						int tmp_cnt = rs.getInt(1) + carried_count - 15;

						if(tmp_cnt >= 0) 
							carried_count = tmp_cnt;
						
						else //15보다 작으면 이월 횟수 0
							carried_count = 0;
						
					}
					//Step 4: 년월을 증가
					heap_month++;
					if(heap_month >= 12) {
						heap_month = 1;
						heap_year++;
					}
				}//end while
			}//end if
		} catch(CommunicationsException ce) {
			getCarriedCount(url, heap_year, heap_month);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			pool.freeConnection(con, pstmt, rs);
		}
		return carried_count;
	}
}
