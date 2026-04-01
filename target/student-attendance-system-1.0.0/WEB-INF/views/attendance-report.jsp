<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Attendance Report - ${course.courseName}</title>
                <meta name="description" content="Attendance report for ${course.courseName}">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            </head>

            <body>
                <!-- Navigation -->
                <nav class="navbar">
                    <a href="${pageContext.request.contextPath}/faculty/dashboard" class="navbar-brand">
                        <span class="icon">&#128218;</span>
                        Attendance System
                    </a>
                    <ul class="navbar-nav">
                        <li><a href="${pageContext.request.contextPath}/faculty/dashboard">Dashboard</a></li>
                        <li><a class="active">Reports</a></li>
                    </ul>
                    <div class="navbar-user">
                        <div class="user-info">
                            <div class="user-name">${user.fullName}</div>
                            <div class="user-role">Faculty</div>
                        </div>
                        <div class="avatar">${user.fullName.substring(0,1)}</div>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
                    </div>
                </nav>

                <div class="container">
                    <!-- Page Header -->
                    <div class="page-header">
                        <h1>&#128202; Attendance Report</h1>
                        <p>${course.courseCode} - ${course.courseName}</p>
                    </div>

                    <!-- Filter -->
                    <div class="card" style="margin-bottom: 1.5rem;">
                        <div class="card-header">
                            <h3>&#128269; Filter by Date Range</h3>
                        </div>
                        <form method="get" action="${pageContext.request.contextPath}/faculty/attendance-report"
                            class="filter-form">
                            <input type="hidden" name="courseId" value="${course.id}">
                            <div class="form-group">
                                <label for="startDate">Start Date</label>
                                <input type="date" class="form-control" id="startDate" name="startDate"
                                    value="${startDate}">
                            </div>
                            <div class="form-group">
                                <label for="endDate">End Date</label>
                                <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}">
                            </div>
                            <button type="submit" class="btn btn-primary btn-sm">&#128269; Apply Filter</button>
                            <a href="${pageContext.request.contextPath}/faculty/attendance-report?courseId=${course.id}"
                                class="btn btn-secondary btn-sm">&#128260; Reset</a>
                        </form>
                    </div>

                    <!-- Summary -->
                    <c:if test="${not empty summary}">
                        <div class="card" style="margin-bottom: 1.5rem;">
                            <div class="card-header">
                                <h3>&#128202; Student Attendance Summary</h3>
                            </div>
                            <div class="table-wrapper">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Student Name</th>
                                            <th>Username</th>
                                            <th>Attendance %</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:set var="count" value="0" />
                                        <c:forEach var="entry" items="${summary}">
                                            <c:set var="count" value="${count + 1}" />
                                            <tr>
                                                <td>${count}</td>
                                                <td style="font-weight: 500;">${entry.key.fullName}</td>
                                                <td style="color: var(--text-secondary);">${entry.key.username}</td>
                                                <td>
                                                    <div style="display: flex; align-items: center; gap: 10px;">
                                                        <div class="percentage-bar" style="width: 120px;">
                                                            <div class="percentage-fill ${entry.value >= 75 ? 'high' : entry.value >= 50 ? 'medium' : 'low'}"
                                                                style="width: ${entry.value}%"></div>
                                                        </div>
                                                        <span
                                                            style="font-weight: 600;
                                                color: ${entry.value >= 75 ? '#34d399' : entry.value >= 50 ? '#fbbf24' : '#f87171'};">
                                                            <fmt:formatNumber value="${entry.value}"
                                                                maxFractionDigits="1" />%
                                                        </span>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${entry.value >= 75}">
                                                            <span class="badge badge-present">Good</span>
                                                        </c:when>
                                                        <c:when test="${entry.value >= 50}">
                                                            <span class="badge badge-late">Warning</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-absent">Critical</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:if>

                    <!-- Detailed Records -->
                    <div class="card">
                        <div class="card-header">
                            <h3>&#128203; Detailed Attendance Records</h3>
                            <span class="badge badge-faculty">${records.size()} records</span>
                        </div>

                        <c:choose>
                            <c:when test="${not empty records}">
                                <div class="table-wrapper">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Date</th>
                                                <th>Student Name</th>
                                                <th>Status</th>
                                                <th>Marked By</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="record" items="${records}" varStatus="loop">
                                                <tr>
                                                    <td>${loop.index + 1}</td>
                                                    <td>${record.date}</td>
                                                    <td style="font-weight: 500;">${record.student.fullName}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${record.status == 'PRESENT'}">
                                                                <span class="badge badge-present">&#9989; Present</span>
                                                            </c:when>
                                                            <c:when test="${record.status == 'ABSENT'}">
                                                                <span class="badge badge-absent">&#10060; Absent</span>
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
                                    <p>No attendance records available for this course.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div style="margin-top: 1.5rem;">
                        <a href="${pageContext.request.contextPath}/faculty/dashboard" class="btn btn-secondary">
                            &#8592; Back to Dashboard
                        </a>
                    </div>
                </div>
            </body>

            </html>