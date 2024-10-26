<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insurance Filings - Newsletter</title>
    <%-- Include JSTL core tag library --%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .header {
            background-color: #1B7EC3;
            color: white;
            padding: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header-logo {
            background-color: #1B7EC3;
            padding: 5px 10px;
            display: inline-block;
        }
        .header-nav {
            display: flex;
            align-items: center;
            justify-content: flex-start;
        }
        .header-nav a {
            color: white;
            text-decoration: none;
            margin-right: 15px;
        }
        .my-account {
            margin-left: auto;
        }
        .content {
            padding: 20px;
        }
        .title-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        h1 {
            margin: 0;
        }
        .add-newsletter {
            background-color: #0F919E;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }
        .year {
            background-color: #1B7EC3;
            color: white;
            padding: 10px;
            margin-top: 20px;
            cursor: pointer;
        }
        .quarter {
            background-color: white;
            border: 1px solid #ddd;
            padding: 10px;
            margin-top: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .quarter-info {
            color: #888;
            font-size: 0.9em;
            margin-right: 10px;
        }
        .action-button {
            background-color: white;
            border: 1px solid #0F919E;
            color: #0F919E;
            padding: 5px 10px;
            border-radius: 3px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-logo">Insurance Filings</div>
        <nav class="header-nav">
            <a href="#">Join Requests</a>
            <a href="#">Search</a>
            <a href="#">Manage Admins & Search Users</a>
            <a href="#">Reports</a>
            <a href="#">Admin</a>
            <a href="#">Email</a>
            <a href="#">Content Manager</a>
            <a href="#" class="my-account">My Account</a>
        </nav>
    </div>
    <div class="content">
        <div class="title-container">
            <h1>Newsletter</h1>
            <button class="add-newsletter">Add Newsletter</button>
        </div>

        <c:forEach var="year" items="${newsletters.stream().map(n -> n.getYear()).distinct().sorted((a, b) -> b.compareTo(a)).toList()}" varStatus="yearStatus">
            <div class="year">
                    ${year}
            </div>
            <c:forEach var="newsletter" items="${newsletters.stream().filter(n -> n.getYear() == year).sorted((a, b) -> b.getPublicationDate().compareTo(a.getPublicationDate())).toList()}">
                <div class="quarter">
                    <span>${newsletter.title}</span>
                    <div>
                <span class="quarter-info">
                    <c:choose>
                        <c:when test="${newsletter.status == 'published'}">
                            Published on ${newsletter.publicationDate}
                        </c:when>
                        <c:otherwise>
                            Saved on ${newsletter.publicationDate}
                        </c:otherwise>
                    </c:choose>
                </span>
                        <button class="action-button">
                            <c:choose>
                                <c:when test="${newsletter.status == 'published'}">
                                    Unpublish
                                </c:when>
                                <c:otherwise>
                                    Publish
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </div>
            </c:forEach>
        </c:forEach>
    </div>
</body>
</html>