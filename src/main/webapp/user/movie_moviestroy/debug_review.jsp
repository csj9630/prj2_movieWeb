<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="moviestory.util.DbConn" %>
<!DOCTYPE html>
<html>
<head>
<title>Debug Review</title>
</head>
<body>
    <h1>Review System Diagnostic</h1>
    
    <h2>1. Session Info</h2>
    <ul>
        <li>Current Session ID: <%= session.getId() %></li>
        <li>Session attribute 'userId': <strong><%= session.getAttribute("userId") %></strong></li>
        <%
            String userId = (String) session.getAttribute("userId");
            if (userId == null) userId = "test1 (fallback)";
        %>
        <li>Effective userId (for logic): <strong><%= userId %></strong></li>
    </ul>

    <h2>2. DB Connection Test</h2>
    <%
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            DbConn db = DbConn.getInstance("jdbc/dbcp");
            con = db.getConn();
            out.println("<div>DB Connection: <b style='color:green'>SUCCESS</b></div>");
            out.println("<div>AutoCommit: " + con.getAutoCommit() + "</div>");
            
            // Query recent reviews
            String sql = "SELECT review_num, users_id, review_content, review_score FROM REVIEW ORDER BY review_date DESC";
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();
    %>
    
    <h2>3. Recent Reviews (Top 10)</h2>
    <table border="1" cellpadding="5">
        <tr>
            <th>Review Num</th>
            <th>Owner ID (users_id)</th>
            <th>Score</th>
            <th>Content (Start)</th>
            <th>Match Session?</th>
        </tr>
    <%
            int count = 0;
            while(rs.next() && count < 10) {
                String rNum = rs.getString("review_num");
                String uId = rs.getString("users_id");
                String content = rs.getString("review_content");
                int score = rs.getInt("review_score");
                
                boolean match = uId != null && uId.equals(session.getAttribute("userId"));
                if (session.getAttribute("userId") == null && "test1".equals(uId)) {
                   // logic mimics the fallback
                   match = true; 
                }
    %>
        <tr style="<%= match ? "background-color:#e6fffa" : "background-color:#fff0f0" %>">
            <td><%= rNum %></td>
            <td><%= uId %></td>
            <td><%= score %></td>
            <td><%= content != null && content.length() > 20 ? content.substring(0, 20) + "..." : content %></td>
            <td><%= match ? "O" : "X" %></td>
        </tr>
    <%
                count++;
            }
        } catch(Exception e) {
            out.println("<h3 style='color:red'>Error: " + e.getMessage() + "</h3>");
            e.printStackTrace(new java.io.PrintWriter(out));
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e){}
            if(pstmt != null) try { pstmt.close(); } catch(Exception e){}
            if(con != null) try { con.close(); } catch(Exception e){}
        }
    %>
    </table>
    
    <div style="margin-top:20px; padding:10px; background:#f5f5f5;">
    <p><strong>Diagnosis Guide:</strong></p>
    <ul>
        <li>If 'Match Session' is X for the review you are trying to edit, you (Current Session User) do not own that review.</li>
        <li>If 'Session attribute userId' is null, you are not logged in. Logic defaults to 'test1'.</li>
        <li>If DB Connection fails, check your server logs.</li>
    </ul>
    </div>
</body>
</html>
