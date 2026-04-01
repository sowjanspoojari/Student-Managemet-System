<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Manage Courses - Admin</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <nav class="navbar">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand">
                    <span class="icon">&#128218;</span>
                    Attendance System
                </a>
                <ul class="navbar-nav">
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/courses" class="active">Courses</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/faculty">Faculty</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/students">Students</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/reports">Reports</a></li>
                </ul>
                <div class="navbar-user">
                    <div class="user-info">
                        <div class="user-name">${user.fullName}</div>
                        <div class="user-role">Admin</div>
                    </div>
                    <div class="avatar">A</div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
                </div>
            </nav>

            <div class="container">
                <div class="page-header">
                    <h1>&#128218; Manage Courses</h1>
                    <p>Add, update, and assign courses to faculty</p>
                </div>

                <c:if test="${param.success != null}">
                    <div class="alert alert-success">&#9989; ${param.success}</div>
                </c:if>
                <c:if test="${param.error != null}">
                    <div class="alert alert-danger">&#9888;&#65039; ${param.error}</div>
                </c:if>

                <!-- Add New Course -->
                <div class="card" style="margin-bottom: 1.5rem;">
                    <div class="card-header">
                        <h3>&#10133; Add New Course</h3>
                    </div>
                    <form action="${pageContext.request.contextPath}/admin/courses/add" method="post">
                        <div class="filter-form">
                            <div class="form-group">
                                <label for="courseName">Course Name</label>
                                <input type="text" class="form-control" id="courseName" name="courseName"
                                    placeholder="e.g. Machine Learning" required>
                            </div>
                            <div class="form-group">
                                <label for="courseCode">Course Code</label>
                                <input type="text" class="form-control" id="courseCode" name="courseCode"
                                    placeholder="e.g. CS301" required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-sm">&#10133; Add Course</button>
                        </div>
                    </form>
                </div>

                <!-- Existing Courses -->
                <div class="card">
                    <div class="card-header">
                        <h3>&#128203; All Courses</h3>
                        <span class="badge badge-faculty">${courses.size()} courses</span>
                    </div>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Course Code</th>
                                    <th>Course Name</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="course" items="${courses}" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td><span class="course-code">${course.courseCode}</span></td>
                                        <td style="font-weight: 500;">${course.courseName}</td>
                                        <td>
                                            <button type="button" class="btn btn-secondary btn-sm"
                                                data-id="${course.id}" data-name="${course.courseName}"
                                                data-code="${course.courseCode}" onclick="editCourse(this)">
                                                &#9998; Edit
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Edit Modal (hidden by default) -->
                <div id="editModal"
                    style="display:none; position:fixed; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.7); z-index:200; display:none; align-items:center; justify-content:center;">
                    <div class="auth-card" style="max-width: 500px;">
                        <h2 style="margin-bottom: 1rem;">&#9998; Edit Course</h2>
                        <form action="${pageContext.request.contextPath}/admin/courses/update" method="post">
                            <input type="hidden" name="courseId" id="editCourseId">
                            <div class="form-group">
                                <label>Course Name</label>
                                <input type="text" class="form-control" name="courseName" id="editCourseName" required>
                            </div>
                            <div class="form-group">
                                <label>Course Code</label>
                                <input type="text" class="form-control" name="courseCode" id="editCourseCode" required>
                            </div>
                            <div style="display:flex; gap:1rem;">
                                <button type="submit" class="btn btn-success">&#128190; Save</button>
                                <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                function editCourse(button) {
                    const ds = button.dataset;
                    document.getElementById('editCourseId').value = ds.id;
                    document.getElementById('editCourseName').value = ds.name;
                    document.getElementById('editCourseCode').value = ds.code;
                    document.getElementById('editModal').style.display = 'flex';
                }
                function closeModal() {
                    document.getElementById('editModal').style.display = 'none';
                }
            </script>
        </body>

        </html>