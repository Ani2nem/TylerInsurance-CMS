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
            margin-bottom: 5px;
            padding: 15px;
        }


        .filters {
            margin-bottom: 20px;
            padding: 10px 0px;
            margin-left: 15px;
            display: flex;
            align-items: center;
            gap: 15px;
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


        /* Card container */
        .articles-grid {
            display: flex;
            flex-direction: column;
            gap: 24px;
            margin: 20px 0;
            width: 94%;
        }

        /* Individual card styling */
        .article-card {
            background-color: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 24px 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
            gap: 12px;
            position: relative;
            width: 100%;
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            cursor: pointer;
        }

        a:hover .article-card {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        /* Main title */
        .article-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin: 0;
            padding-right: 120px; /* Make space for the status badge */
        }

        /* Subtitle styling */
        .article-subtitle {
            font-style: italic;
            color: #666;
            font-size: 16px;
            margin: 8px 0 16px 0;
        }

        /* Article content */
        .article-content {
            color: #444;
            font-size: 16px;
            line-height: 1.5;
            margin: 8px 0;
        }

        /* Status badge */
        .status-badge {
            position: absolute;
            top: 24px;
            right: 32px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
            pointer-events: none;
        }

        .status-draft {
            color: #6c757d;
        }

        .status-published {
            color: #0d6efd;
        }

        /* Date styling */
        .article-date {
            font-size: 14px;
            color: #666;
            margin-top: 16px;
        }

        /* External link icon */
        .external-link-icon {
            width: 24px;
            height: 24px;
            color: #6c757d;
        }

        .external-link-icon:hover{
            cursor: pointer;
        }

        .publish-button {
            background-color: #45818e;  /* Teal color matching the image */
            color: white;
            border: none;
            padding: 8px 24px;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            align-self: flex-end;
            margin-top: 16px;
            margin-left: auto;  /* Push to the right */
            display: inline-block;
        }

        .publish-button:hover {
            background-color: #3a6d77;
        }

    .add-article-button {
       background-color: #1B7EC3;
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

    .button-container {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 20px;
      margin-top: 20px;
      border-top: 1px solid #ddd;
    }

    .right-buttons {
      display: flex;
      gap: 10px;
    }

    button {
      padding: 10px 20px;
      font-size: 16px;
      cursor: pointer;
      border: none;
      border-radius: 5px;
    }

    .back-button {
      background-color: #1B7EC3;
      color: white;
    }

    .publish-newsletter-button {
      background-color: #1B7EC3;
      color: white;
    }


    .edit-title-icon {
        display: inline-flex;
        align-items: center;
        padding: 4px;
        margin-left: 16px;
        cursor: pointer;
        color: #666;
        transition: color 0.2s ease;
    }

    .edit-title-icon:hover {
        color: #1B7EC3;
    }

    .pencil-icon {
        width: 16px;
        height: 16px;
    }

    /* Modal styles */
    .popup-toggle {
        display: none;
    }

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
    }

    .popup-toggle:checked + .popup-overlay {
        opacity: 1;
        visibility: visible;
    }

    .popup-content {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background-color: white;
        padding: 24px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        width: 90%;
        max-width: 400px;
    }

    .title-input {
        width: 100%;
        padding: 8px 12px;
        margin: 16px 0;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 16px;
    }

    .button-group {
        display: flex;
        justify-content: flex-end;
        gap: 12px;
        margin-top: 20px;
    }

    .modal-button {
        padding: 8px 16px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
        border: none;
    }

    .save-button {
        background-color: #1B7EC3;
        color: white;
    }

    .cancel-button {
        background-color: #e0e0e0;
        color: #333;
    }

    .modal-button:hover {
        opacity: 0.9;
    }

    .quarter-link {
                text-decoration: none;
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
        <h1 class="title-container">Quarterly Newsletter</h1>
        <div class="title-container">
            <div style="display: flex; align-items: center;">
                <h2>${newsletter.title}</h2>
            </div>
    </div>


    <div class="newsletter-content">
        <c:choose>
            <c:when test="${empty articles}">
                <div class="empty-state">
                    No Articles have been published in this newsletter yet.
                </div>
            </c:when>
            <c:otherwise>
                <div class="articles-grid">
                    <c:forEach items="${articles}" var="article">
                        <a href="/articleview?id=${article.articleId}" class="quarter-link">
                            <div class="article-card">
                                <h2 class="article-title">${article.title}</h2>
                                <div class="article-subtitle">${article.subtitle}</div>
                                <div class="article-summary">${article.summary}</div>
                                <div class="article-date">
                                    <fmt:formatDate value="${article.addedDate}" pattern="MMMM dd, yyyy"/>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>


    </div>
</body>
</html>