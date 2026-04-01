<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>My Attendance - Attendance System</title>
                <meta name="description" content="View your attendance records">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            </head>

            <body>
                <!-- Navigation -->
                <nav class="navbar">
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="navbar-brand">
                        <span class="icon">&#128218;</span>
                        Attendance System
                    </a>
                    <ul class="navbar-nav">
                        <li><a href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/student/attendance" class="active">My
                                Attendance</a></li>
                    </ul>
                    <div class="navbar-user">
                        <div class="user-info">
                            <div class="user-name">${user.fullName}</div>
                            <div class="user-role">Student</div>
                        </div>
                        <div class="avatar">${user.fullName.substring(0,1)}</div>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
                    </div>
                </nav>

                <div class="container">
                    <!-- Page Header -->
                    <div class="page-header">
                        <h1>&#128202; My Attendance</h1>
                        <p>View your attendance records by course</p>
                    </div>

                    <!-- Course Selector -->
                    <div class="card" style="margin-bottom: 1.5rem;">
                        <div class="card-header">
                            <h3>&#128218; Select Course</h3>
                        </div>
                        <form method="get" action="${pageContext.request.contextPath}/student/attendance"
                            class="filter-form">
                            <div class="form-group">
                                <label for="courseId">Course</label>
                                <select class="form-control" id="courseId" name="courseId" required>
                                    <option value="">-- Select a Course --</option>
                                    <c:forEach var="course" items="${courses}">
                                        <option value="${course.id}" ${selectedCourse !=null &&
                                            selectedCourse.id==course.id ? 'selected' : '' }>
                                            ${course.courseCode} - ${course.courseName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary btn-sm">&#128269; View Attendance</button>
                        </form>
                    </div>

                    <!-- Attendance Details -->
                    <c:if test="${selectedCourse != null}">
                        <!-- Stats for selected course -->
                        <div class="stats-grid">
                            <div class="stat-card purple">
                                <div class="stat-icon">&#128218;</div>
                                <div class="stat-value">${selectedCourse.courseCode}</div>
                                <div class="stat-label">${selectedCourse.courseName}</div>
                            </div>
                            <div
                                class="stat-card ${percentage >= 75 ? 'green' : percentage >= 50 ? 'orange' : 'orange'}">
                                <div class="stat-icon">${percentage >= 75 ? '&#9989;' : percentage >= 50 ?
                                    '&#9888;&#65039;' : '&#10060;'}</div>
                                <div class="stat-value">
                                    <fmt:formatNumber value="${percentage}" maxFractionDigits="1" />%
                                </div>
                                <div class="stat-label">Attendance Percentage</div>
                            </div>
                            <div class="stat-card blue">
                                <div class="stat-icon">&#128203;</div>
                                <div class="stat-value">${records.size()}</div>
                                <div class="stat-label">Total Classes</div>
                            </div>
                        </div>

                        <!-- Attendance Progress Bar -->
                        <div class="card" style="margin-bottom: 1.5rem;">
                            <div
                                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                                <span style="font-weight: 500;">Overall Attendance</span>
                                <span style="font-weight: 700; font-size: 1.1rem;
                        color: ${percentage >= 75 ? '#34d399' : percentage >= 50 ? '#fbbf24' : '#f87171'};">
                                    <fmt:formatNumber value="${percentage}" maxFractionDigits="1" />%
                                </span>
                            </div>
                            <div class="percentage-bar" style="height: 12px;">
                                <div class="percentage-fill ${percentage >= 75 ? 'high' : percentage >= 50 ? 'medium' : 'low'}"
                                    style="width: ${percentage}%"></div>
                            </div>
                            <div style="margin-top: 8px; font-size: 0.82rem; color: var(--text-muted);">
                                <c:choose>
                                    <c:when test="${percentage >= 75}">
                                        &#9989; Good standing - You have sufficient attendance.
                                    </c:when>
                                    <c:when test="${percentage >= 50}">
                                        &#9888;&#65039; Warning - Your attendance is below 75%. Please attend more
                                        classes.
                                    </c:when>
                                    <c:otherwise>
                                        &#10060; Critical - Your attendance is below 50%. Immediate action required.
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Attendance Records Table -->
                        <div class="card">
                            <div class="card-header">
                                <h3>&#128203; Attendance Records</h3>
                                <span class="badge badge-student">${records.size()} records</span>
                            </div>

                            <c:choose>
                                <c:when test="${not empty records}">
                                    <div class="table-wrapper">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th>Date</th>
                                                    <th>Status</th>
                                                    <th>Marked By</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="record" items="${records}" varStatus="loop">
                                                    <tr>
                                                        <td>${loop.index + 1}</td>
                                                        <td>${record.date}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${record.status == 'PRESENT'}">
                                                                    <span class="badge badge-present">&#9989;
                                                                        Present</span>
                                                                </c:when>
                                                                <c:when test="${record.status == 'ABSENT'}">
                                                                    <span class="badge badge-absent">&#10060;
                                                                        Absent</span>
                                                                </c:when>
                                                                <c:when test="${record.status == 'LATE'}">
                                                                    <span class="badge badge-late">&#9200; Late</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td style="color: var(--text-secondary);">
                                                            ${record.markedBy.fullName}</td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="icon">&#128202;</div>
                                        <h3>No Records Found</h3>
                                        <p>No attendance records for this course yet.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <div style="margin-top: 1.5rem;">
                        <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-secondary">
                            &#8592; Back to Dashboard
                        </a>
                    </div>
                </div>
            </body>

            </html>