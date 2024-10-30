<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insurance Filings - Add Article</title>
    <%-- Include JSTL core tag library --%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <script src="https://cdn.ckeditor.com/ckeditor5/38.0.1/classic/ckeditor.js"></script>
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
        .input-form {
            margin: 20px;
            display: flex;
            flex-wrap: wrap;
        }
        .input-form input[type=text], .input-form textarea, .input-form input[type=date] {
            width: 100%;
            padding: 12px 20px;
            margin: 8px 0;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .input-form label {
            font-weight: bold;
            width: 100%;
        }
        .left-column, .right-column {
            width: 48%;
        }
        .left-column {
            margin-right: 2%;
        }
        .full-width {
            width: 100%;
            margin-top: 20px;
        }
        #subtitle {
            height: 100px;
        }
        .button-container {
            width: 100%;
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }
        .button {
            padding: 10px 20px;
            margin-left: 10px;
            background-color: #1B7EC3;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .button:hover {
            background-color: #0F919E;
        }
        .ck-editor__editable {
            min-height: 300px;
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
<form class="input-form" action="/submit-article" method="post">
    <div class="left-column">
        <label for="title">Title</label>
        <input type="text" id="title" name="title">

        <label for="subtitle">Subtitle</label>
        <textarea id="subtitle" name="subtitle"></textarea>
    </div>
    <div class="right-column">
        <label for="date">Date</label>
        <input type="date" id="date" name="date">

        <label for="metatitle">Meta Title</label>
        <input type="text" id="metatitle" name="metatitle">

        <label for="metadescription">Meta Description</label>
        <textarea id="metadescription" name="metadescription"></textarea>
    </div>
    <div class="full-width">
        <label for="summaryEditor">Summary</label>
        <textarea id="summaryEditor" name="summary"></textarea>
    </div>
    <div class="full-width">
        <label for="contentEditor">Newsletter Content</label>
        <textarea id="contentEditor" name="content"></textarea>
    </div>
    <div class="button-container">
        <a href="http://localhost:8081/addnewsletter" class="button">Back</a>
        <button type="submit" class="button" name="action" value="save">Save</button>
        <button type="submit" class="button" name="action" value="publish">Publish</button>
    </div>
</form>

<script>
    let summaryEditor, contentEditor;

    ClassicEditor
        .create(document.querySelector('#summaryEditor'))
        .then(editor => {
            summaryEditor = editor;
        })
        .catch(error => {
            console.error(error);
        });

    ClassicEditor
        .create(document.querySelector('#contentEditor'))
        .then(editor => {
            contentEditor = editor;
        })
        .catch(error => {
            console.error(error);
        });
</script>
</body>
</html>