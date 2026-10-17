<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="UTF-8">
<title>Простой Word</title>
<style>
  body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f3f5f9;
  }
  .top {
    background: #2d5fa8;
    color: #fff;
    padding: 16px 24px;
  }
  .top h1 { margin: 0; font-size: 24px; }
  .wrap {
    margin: 16px 24px;
    background: #fff;
    border: 1px solid #d0d7e2;
    padding: 12px;
  }
  textarea {
    width: 100%;
    min-height: 500px;
    padding: 16px;
    font-family: Arial, sans-serif;
    font-size: 16px;
    line-height: 1.6;
    border: 1px solid #c2c8d2;
    outline: none;
    resize: vertical;
    box-sizing: border-box;
  }
  textarea:focus {
    border-color: #2d5fa8;
  }
</style>
</head>
<body>

<div class="top">
  <h1>Простой Word</h1>
</div>

<div class="wrap">
  <textarea placeholder="Кликни сюда и начни печатать..."></textarea>
</div>

</body>
</html>
