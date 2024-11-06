<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insurance Filings - Newsletter</title>
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
        .year-container {
            margin-bottom: 10px;
        }
        .year-toggle {
            display: none;
        }
        .year-label {
            background-color: #1B7EC3;
            color: white;
            padding: 10px;
            margin-top: 20px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .year-icon::after {
            content: '\f0d7';
            font-family: 'Font Awesome 5 Free';
            font-weight: 900;
            font-size: 1.2em;
            margin-left: 10px;
        }
        .year-toggle:checked + .year-label .year-icon::after {
            content: '\f0d8';
        }
        .quarters-container {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease-out;
        }
        .year-toggle:checked ~ .quarters-container {
            max-height: 1000px;
        }
        .quarter {
            background-color: white;
            border: 1px solid #ddd;
            padding: 10px;
            margin-top: 5px;
            transition: background-color 0.2s;
        }
        .quarter:hover {
            background-color: #f5f5f5;
        }
        .quarter-link {
            text-decoration: none;
            color: inherit;
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
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
            z-index: 2;
        }
        .action-button:hover {
            background-color: #0F919E;
            color: white;
        }

    /* Popup/Modal Styles */
    .popup-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 1000;
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.3s, visibility 0.3s;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    #popup-toggle {
        display: none;
    }

    #popup-toggle:checked + .popup-overlay {
        opacity: 1;
        visibility: visible;
    }

    .popup-content {
        background-color: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        width: 90%;
        max-width: 400px;
        position: relative;
    }

    .popup-content h2 {
        margin-top: 0;
        margin-bottom: 20px;
        color: #333;
    }

    .popup-content select {
        width: 100%;
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ddd;
        border-radius: 4px;
        background-color: white;
        font-size: 16px;
    }

    .popup-content .button {
        padding: 10px 20px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        border: none;
        margin-right: 10px;
    }

    .popup-content button[type="submit"] {
        background-color: #0F919E;
        color: white;
    }

    .popup-content label.button {
        background-color: #e0e0e0;
        color: #333;
        display: inline-block;
    }

    .popup-content form {
        display: flex;
        flex-direction: column;
    }

    .popup-content .button-group {
        display: flex;
        justify-content: flex-end;
        margin-top: 20px;
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
        <label for="popup-toggle" class="add-newsletter">Add Newsletter</label>
    </div>

    <c:forEach var="year" items="${newsletters.stream().map(n -> n.getYear()).distinct().sorted((a, b) -> b.compareTo(a)).toList()}" varStatus="yearStatus">
        <div class="year-container">
            <input type="checkbox" id="year-${year}" class="year-toggle">
            <label for="year-${year}" class="year-label">
                ${year}
                <span class="year-icon"></span>
            </label>
            <div class="quarters-container">
                <c:forEach var="newsletter" items="${newsletters.stream().filter(n -> n.getYear() == year).sorted((a, b) -> b.getPublicationDate().compareTo(a.getPublicationDate())).toList()}">
                    <div class="quarter">
                        <a href="/newsletterhome?year=${year}&quarter=${newsletter.quarter}" class="quarter-link">
                            <span>${newsletter.title}</span>
                            <div style="display: flex; align-items: center;">
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
                                <button class="action-button" onclick="event.stopPropagation();">
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
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:forEach>
</div>

<!-- Pop-up component -->
<input type="checkbox" id="popup-toggle">
<div class="popup-overlay">
    <div class="popup-content">
        <h2>Select Year and Quarter</h2>
        <form action="/addnewsletter" method="get">
            <select name="year" required>
                <option value="">Select Year</option>
                <option value="2024">2024</option>
                <option value="2023">2023</option>
                <option value="2022">2022</option>
            </select>
            <select name="quarter" required>
                <option value="">Select Quarter</option>
                <option value="1">Quarter 1</option>
                <option value="2">Quarter 2</option>
                <option value="3">Quarter 3</option>
                <option value="4">Quarter 4</option>
            </select>
            <div class="button-group">
                <button type="submit" class="button">Add</button>
                <label for="popup-toggle" class="button">Cancel</label>
            </div>
        </form>
    </div>
</div>

<!-- Include Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
</body>
</html>