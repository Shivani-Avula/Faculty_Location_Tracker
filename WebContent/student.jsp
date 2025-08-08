<%@ page import="java.sql.*,com.project.DBConnection,jakarta.servlet.http.*,jakarta.servlet.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || !"student".equals(sessionObj.getAttribute("role"))) {
        response.sendRedirect("index.html?sessionExpired=1");
        return;
    }

    String searchName = request.getParameter("facultyName");
    String location = null;
    if (searchName != null && !searchName.trim().isEmpty()) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement("SELECT location FROM users WHERE username=? AND role='faculty'");
            ps.setString(1, searchName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) location = rs.getString("location");
            else location = "Faculty not found!";
        } catch (Exception e) {
            location = "Error: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard</title>
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
        .result-box {
            margin-top: 20px;
            background: rgba(255,255,255,0.2);
            border-radius: 8px;
            padding: 10px;
        }
    </style>
</head>
<body>
    <div class="dashboard-card">
        <h2>Find Faculty Location</h2>
        <form method="get">
            <div class="mb-3">
                <input type="text" name="facultyName" class="form-control" placeholder="Enter Faculty Name" required>
            </div>
            <button type="submit" class="btn btn-custom">Search</button>
        </form>
        <% if (location != null) { %>
            <div class="result-box mt-3"><strong>Location:</strong> <%= location %></div>
        <% } %>
        <a href="LogoutServlet" class="btn btn-danger mt-3">Logout</a>
    </div>
</body>
</html>
