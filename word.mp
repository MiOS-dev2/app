<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="UTF-8">
<title></title>
<style>
  body { font-family: sans-serif; margin: 0; background: #eee; }
  .toolbar {
    background: #f5f5f5;
    border-bottom: 1px solid #ccc;
    padding: 8px;
    display: flex;
    gap: 6px;
    flex-wrap: wrap;
  }
  .toolbar button {
    padding: 5px 10px;
    border: 1px solid #bbb;
    background: #fff;
    cursor: pointer;
    font-size: 14px;
  }
  .toolbar button:hover { background: #e8e8e8; }
  .page {
    max-width: 800px;
    margin: 20px auto;
    background: #fff;
    padding: 30px;
    min-height: 500px;
    border: 1px solid #ccc;
    outline: none;
    font-size: 16px;
    line-height: 1.5;
  }
</style>
</head>
<body>

<div class="toolbar">
  <button onclick="document.execCommand('bold')"><b>Ж</b></button>
  <button onclick="document.execCommand('italic')"><i>К</i></button>
  <button onclick="document.execCommand('underline')"><u>Ч</u></button>
  <button onclick="document.execCommand('insertUnorderedList')">• Список</button>
  <button onclick="document.execCommand('insertOrderedList')">1. Список</button>
  <button onclick="document.execCommand('justifyLeft')">←</button>
  <button onclick="document.execCommand('justifyCenter')">↔</button>
  <button onclick="document.execCommand('justifyRight')">→</button>
  <button onclick="document.execCommand('formatBlock', false, 'h2')">H2</button>
  <button onclick="document.execCommand('formatBlock', false, 'p')">Абзац</button>
</div>

<div class="page" contenteditable="true">
  <p>Ваш текст</p>
</div>

</body>
</html>