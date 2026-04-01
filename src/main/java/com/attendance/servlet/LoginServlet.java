package com.attendance.servlet;

import com.attendance.model.User;
import com.attendance.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Autowired
    private AuthService authService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        SpringBeanAutowiringSupport.processInjectionBasedOnCurrentContext(this);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.getRole() == User.Role.ADMIN) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (user.getRole() == User.Role.FACULTY) {
                response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
            }
            return;
        }
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate input
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        // Spring Boot service validates credentials
        User user = authService.validateLogin(username.trim(), password.trim());

        if (user != null) {
            // Valid login - create session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole().name());
            session.setAttribute("fullName", user.getFullName());

            // Role-based routing
            if (user.getRole() == User.Role.ADMIN) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (user.getRole() == User.Role.FACULTY) {
                response.sendRedirect(request.getContextPath() + "/faculty/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/dashboard");
            }
        } else {
            // Invalid credentials
            request.setAttribute("error", "Invalid username or password. Please try again.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
