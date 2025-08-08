<%@ page import="java.sql.*,com.project.DBConnection,jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || !"faculty".equals(sessionObj.getAttribute("role"))) {
        response.sendRedirect("index.html?sessionExpired=1");
        return;
    }

    String username = (String) sessionObj.getAttribute("username");
    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String location = request.getParameter("location");
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("UPDATE users SET location=? WHERE username=? AND role='faculty'");
            ps.setString(1, location);
            ps.setString(2, username);
            int updated = ps.executeUpdate();
            message = (updated > 0) ? "Location updated successfully!" : "Update failed!";
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Faculty Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #4a90e2, #50c9c3);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, sans-serif;
        }
        .dashboard-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(12px);
            border-radius: 15px;
            padding: 40px;
            width: 100%;
            max-width: 500px;
            color: #fff;
            text-align: center;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
            animation: fadeIn 0.8s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .btn-custom {
            background-color: #50c9c3;
            border: none;
            border-radius: 8px;
            color: #fff;
            font-weight: 600;
            padding: 10px;
            width: 100%;
            transition: background 0.3s ease;
        }
        .btn-custom:hover { background-color: #3ca9a3; }
    </style>
</head>
<body>
    <div class="dashboard-card">
        <h2>Welcome, <%= username %></h2>
        <form method="post">
            <div class="mb-3">
                <input type="text" name="location" class="form-control" placeholder="Enter your current location" required>
            </div>
            <button type="submit" class="btn btn-custom">Update Location</button>
        </form>
        <% if (message != null) { %>
            <div class="alert alert-info mt-3"><%= message %></div>
        <% } %>
        <a href="LogoutServlet" class="btn btn-danger mt-3">Logout</a>
    </div>
</body>
</html>


