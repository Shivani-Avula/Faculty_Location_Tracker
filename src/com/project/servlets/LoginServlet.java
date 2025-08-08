package com.project.servlets;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import com.project.DBConnection;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE username=? AND password=? AND role=?");
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("role", role);
                if ("student".equals(role)) {
                    response.sendRedirect("student.jsp");
                } else {
                    response.sendRedirect("faculty.jsp");
                }
            } else {
                response.sendRedirect("index.html?error=1");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}



