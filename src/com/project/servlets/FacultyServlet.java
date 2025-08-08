package com.project.servlets;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import com.project.DBConnection;

public class FacultyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null || !"faculty".equals(session.getAttribute("role"))) {
            response.sendRedirect("index.html");
            return;
        }
        String location = request.getParameter("location");
        String username = (String) session.getAttribute("username");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE users SET location=? WHERE username=?");
            ps.setString(1, location);
            ps.setString(2, username);
            ps.executeUpdate();
            response.sendRedirect("faculty.jsp?updated=1");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
