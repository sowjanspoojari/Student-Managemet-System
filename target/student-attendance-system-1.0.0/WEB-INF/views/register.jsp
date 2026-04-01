<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Register - Student Attendance System</title>
            <meta name="description" content="Register for the Student Attendance Management System">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-header">
                        <div class="logo">&#128100;</div>
                        <h1>Create Account</h1>
                        <p>Register as faculty or student</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            &#9888;&#65039; ${error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <input type="text" class="form-control" id="fullName" name="fullName"
                                placeholder="Enter your full name" value="${fullName}" required>
                        </div>

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" class="form-control" id="email" name="email"
                                placeholder="Enter your email" value="${email}" required>
                        </div>

                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" class="form-control" id="username" name="username"
                                placeholder="Choose a username" value="${username}" required>
                        </div>

                        <div class="form-group">
                            <label for="password">Password</label>
                            <input type="password" class="form-control" id="password" name="password"
                                placeholder="Create a password" required>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">Confirm Password</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                                placeholder="Confirm your password" required>
                        </div>

                        <div class="form-group">
                            <label for="role">Role</label>
                            <select class="form-control" id="role" name="role" required>
                                <option value="">Select your role</option>
                                <option value="FACULTY">Faculty</option>
                                <option value="STUDENT">Student</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block" id="registerBtn">
                            &#128221; Create Account
                        </button>
                    </form>

                    <div class="auth-link">
                        Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a>
                    </div>
                </div>
            </div>
        </body>

        </html>