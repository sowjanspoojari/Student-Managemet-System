<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Login - Student Attendance System</title>
            <meta name="description" content="Login to the Student Attendance Management System">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-header">
                        <div class="logo">&#128218;</div>
                        <h1>Attendance System</h1>
                        <p>Sign in to manage attendance</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            &#9888;&#65039; ${error}
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success">
                            &#9989; ${success}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" class="form-control" id="username" name="username"
                                placeholder="Enter your username" value="${username}" required autofocus>
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" class="form-control" id="password" name="password"
                                placeholder="Enter your password" required>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block" id="loginBtn">
                            &#128274; Sign In
                        </button>
                    </form>

                    <div class="auth-link">
                        Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
                    </div>

                    <div style="margin-top: 1.5rem; padding-top: 1rem; border-top: 1px solid var(--border);">
                        <p style="font-size: 0.78rem; color: var(--text-muted); text-align: center;">
                            Demo: admin/admin | faculty1/password123 | student1/password123
                        </p>
                    </div>
                </div>
            </div>
        </body>

        </html>