package com.project;
import java.sql.*;
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/faculty_db";
    private static final String USER = "root";
    private static final String PASSWORD = "123456"; // change if needed

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
