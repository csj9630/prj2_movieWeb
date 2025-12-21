<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    // 파라미터 받기
    String type = request.getParameter("type"); // 'director' or 'actor'
    String keyword = request.getParameter("keyword");

    JSONArray list = new JSONArray();

    if (keyword != null && !keyword.trim().equals("")) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // DB 연결 (기존 DAO 등에서 쓰는 방식대로 Context lookup 혹은 직접 연결)
            // 여기서는 간단하게 설명하기 위해 드라이버 매니저 예시를 듭니다.
            // *실제 프로젝트의 DbConnection 클래스를 사용하세요!*
            String url = "jdbc:oracle:thin:@localhost:1521:xe";
            String user = "scott"; // 본인 DB 계정
            String pass = "tiger"; // 본인 DB 비번
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection(url, user, pass);

            String sql = "";
            if ("director".equals(type)) {
                sql = "SELECT director_code as code, director_name as name FROM director WHERE director_name LIKE ? ORDER BY director_name";
            } else if ("actor".equals(type)) {
                sql = "SELECT actor_code as code, actor_name as name FROM actor WHERE actor_name LIKE ? ORDER BY actor_name";
            }

            if (!sql.equals("")) {
                pstmt = con.prepareStatement(sql);
                pstmt.setString(1, "%" + keyword + "%");
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    JSONObject obj = new JSONObject();
                    obj.put("code", rs.getString("code"));
                    obj.put("name", rs.getString("name"));
                    list.add(obj);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch(Exception e) {}
            if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
            if (con != null) try { con.close(); } catch(Exception e) {}
        }
    }
    
    out.print(list.toJSONString());
%>