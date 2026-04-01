<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Error - Attendance System</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <div class="auth-container">
                <div class="auth-card" style="text-align: center;">
                    <div style="font-size: 3rem; margin-bottom: 1rem;">&#9888;&#65039;</div>
                    <h1 style="font-size: 1.4rem; margin-bottom: 0.5rem; color: #f87171;">Something Went Wrong</h1>
                    <p style="color: var(--text-secondary); margin-bottom: 1.5rem;">
                        ${not empty error ? error : 'An unexpected error occurred. Please try again.'}
                    </p>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                        &#127968; Go to Home
                    </a>
                </div>
            </div>
        </body>

        </html>