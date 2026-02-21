@param String message

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Radon Verdict</title>
    <style>
        body {
            font-family: 'Pretendard', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            text-align: center;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
        }
        h1 { font-size: 3rem; margin-bottom: 1rem; }
        p { font-size: 1.5rem; opacity: 0.9; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Radon Verdict</h1>
        <p>${message}</p>
    </div>
</body>
</html>
