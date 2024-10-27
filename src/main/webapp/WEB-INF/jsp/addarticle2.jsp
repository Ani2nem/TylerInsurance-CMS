<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insurance Filings - Newsletter</title>
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
        .editor-container {
            margin-top: 20px;
        }
        .ck-editor__editable {
            min-height: 500px;
        }
        .button-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .right-buttons {
            display: flex;
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
        .back-button {
            background-color: #1B7EC3;
        }
        .back-button:hover {
            background-color: #0F919E;
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
        <h1>Newsletter Content</h1>
    </div>
    <div class="editor-container">
        <div id="editor"></div>
    </div>
    <div class="button-container">
        <button class="button back-button" onclick="goBack()">Back</button>
        <div class="right-buttons">
            <button class="button" onclick="saveContent()">Save</button>
            <button class="button" onclick="publishContent()">Publish</button>
        </div>
    </div>
</div>

<script>
    let editor;

    ClassicEditor
        .create(document.querySelector('#editor'))
        .then(newEditor => {
            editor = newEditor;
        })
        .catch(error => {
            console.error(error);
        });

    function saveContent() {
        const content = editor.getData();
        console.log('Saving content:', content);
        // Add your save logic here
    }

    function publishContent() {
        const content = editor.getData();
        console.log('Publishing content:', content);
        // Add your publish logic here
    }

    function goBack() {
        window.location.href = 'http://localhost:8081/addarticle1';
        console.log('Going back');
        // For example, to go back to the previous page:
        // window.history.back();
    }
</script>
</body>
</html>