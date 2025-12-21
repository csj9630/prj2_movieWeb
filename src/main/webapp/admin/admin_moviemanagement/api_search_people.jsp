<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.sql.*"%>
<%@page import="DBConnection.DbConn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 캐시 방지
    response.setHeader("Pragma", "no-cache"); 
    response.setDateHeader("Expires", 0); 
    response.setHeader("Cache-Control", "no-cache");

    String type = request.getParameter("type"); // "director" 또는 "actor"
    String keyword = request.getParameter("keyword"); // 검색어

    JSONArray list = new JSONArray();
    
    if(keyword != null && !keyword.trim().equals("")) {
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = db.getConn();
            String sql = "";
            
            if("director".equals(type)) {
                // 감독 검색
                sql = "SELECT director_name FROM DIRECTOR WHERE director_name LIKE '%'||?||'%' ORDER BY director_name ASC";
            } else {
                // 배우 검색
                sql = "SELECT actor_name FROM ACTOR WHERE actor_name LIKE '%'||?||'%' ORDER BY actor_name ASC";
            }
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, keyword);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                list.add(rs.getString(1)); // 이름만 리스트에 담음
            }
            
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            db.dbClose(rs, pstmt, con);
        }
    }
    
    out.print(list.toJSONString());
%>