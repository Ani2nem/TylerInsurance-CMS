 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insurance Filings - Newsletter</title>
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

        h1 {
            margin: 0;
        }

         .title-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;  /* Reduced from 30px */
            padding: 10px;
        }


        .filters {
            margin-bottom: 20px;  /* Reduced from 40px */
            padding: 10px 0px;    /* Reduced from 20px */
            margin-left: 15px;
            display: flex;
            align-items: center;
            gap: 15px;           /* Reduced from 20px */
        }

        select {
            padding: 8px 12px;    /* Reduced padding */
            margin-right: 10px;   /* Reduced margin */
            border: 1px solid #ccc;
            border-radius: 6px;
            background-color: white;
            min-width: 140px;     /* Reduced from 180px */
            height: 35px;         /* Reduced from 50px */
            font-size: 14px;      /* Reduced from 16px */
            cursor: pointer;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
            background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23333333%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.4-12.8z%22%2F%3E%3C%2Fsvg%3E");
            background-repeat: no-repeat;
            background-position: right 10px top 50%;
            background-size: 10px auto;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        select:hover {
            border-color: #4784c0;  /* Change border color on hover */
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        select:focus {
            outline: none;
            border-color: #4784c0;
            box-shadow: 0 0 0 3px rgba(71, 132, 192, 0.2);  /* Focus ring */
        }

        /* Add labels for dropdowns */
        .select-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .select-label {
            font-size: 12px;      /* Reduced from 14px */
            font-weight: 600;
            color: #666;
            margin-left: 4px;
        }

        /* Responsive adjustments for dropdowns */
        @media (max-width: 768px) {
            .filters {
                flex-direction: column;
                align-items: stretch;
                padding: 15px;
                gap: 15px;
            }

            select {
                width: 100%;
                margin-right: 0;
            }
        }


       .newsletter-content {
           margin-bottom: 30px;
           display: flex;
           flex-direction: column;
           justify-content: center;
           min-height: 300px;
       }

        .empty-state {
            text-align: center;
            color: #666;
            border-radius: 8px;
            margin-bottom: 10px; /* Add margin to create space between message and button */
            position: static; /* Remove the relative positioning */
        }


        .articles-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);  /* Changed to 4 columns */
            gap: 20px;                              /* Reduced from 30px */
            margin: 20px auto;                      /* Centered with reduced margin */
            max-width: 1400px;                      /* Adjusted max-width */
        }

        .article-card {
            background-color: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            aspect-ratio: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 180px;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-right: 10px;
        }

        .article-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }

        .article-title {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            margin-bottom: 12px;
            line-height: 1.3;
            /* Keep the text wrapping properties */
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .article-date {
            font-size: 14px;                        /* Reduced from 16px */
            color: #666;
            margin-top: auto;
            padding-top: 12px;                      /* Reduced from 15px */
            border-top: 1px solid #eee;
        }

        @media (max-width: 1200px) {
            .articles-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 900px) {
            .articles-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 600px) {
            .articles-grid {
                grid-template-columns: 1fr;
            }

            .article-card {
                min-height: 160px;
            }
        }

    .add-article-button {
       background-color: #0F919E;
       color: white;
       border: none;
       padding: 10px 25px;
       border-radius: 5px;
       cursor: pointer;
       text-align: center;
       text-decoration: none;
       font-size: 14px;
       margin-right: 10px;
    }
    </style>

    <script>
            function handleSelectChange() {
                const year = document.getElementById('yearSelect').value;
                const quarter = document.getElementById('quarterSelect').value;
                window.location.href = '/newsletterhome?year=' + year + '&quarter=' + quarter;
            }
    </script>

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
        <h1>Quarterly Newsletter</h1>
        </div>

            <div class="select-group">
                <label class="select-label">Year</label>
                <select id="yearSelect" onchange="handleSelectChange()">
                    <c:forEach begin="2017" end="2040" var="year">
                        <option value="${year}" <c:if test="${selectedYear == year}">selected</c:if>>${year}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="select-group">
                <label class="select-label">Quarter</label>
                <select id="quarterSelect" onchange="handleSelectChange()">
                    <c:forEach begin="1" end="4" var="q">
                        <option value="${q}" <c:if test="${selectedQuarter == q}">selected</c:if>>Quarter ${q}</option>
                    </c:forEach>
                </select>
            </div>
        </div> **/ %>

        <div class="newsletter-content">
            <c:choose>
                <c:when test="${empty articles}">
                    <div class="empty-state">
                        No Articles in this newsletter. Click 'Add Articles' to get started.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="articles-grid">
                        <c:forEach items="${articles}" var="article">
                            <div class="article-card">
                                <div class="article-title">${article.title}</div>
                                <div class="article-date">
                                    <fmt:formatDate value="${article.addedDate}" pattern="MMM dd, yyyy"/>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>