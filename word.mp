<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="UTF-8">
<title>Простой Word</title>
<style>
  * { box-sizing: border-box; }
  body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #e6e9ef;
    padding: 20px;
  }
  .word {
    max-width: 820px;
    margin: 0 auto;
    background: #fff;
    border: 1px solid #c2c8d2;
    border-radius: 6px;
    overflow: hidden;
  }
  .toolbar {
    background: #f4f6f9;
    border-bottom: 1px solid #c2c8d2;
    padding: 8px;
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
  }
  .toolbar button {
    padding: 5px 10px;
    border: 1px solid #aab1bb;
    background: #fff;
    cursor: pointer;
    font-size: 14px;
    font-family: inherit;
  }
  .toolbar button:hover { background: #e8eefc; }
  .toolbar button:active { background: #d6e2fb; }

  .editor {
    min-height: 500px;
    padding: 30px 40px;
    font-size: 16px;
    line-height: 1.6;
    color: #1f2a3f;
    outline: none;
    cursor: text;
    white-space: pre-wrap;
    word-wrap: break-word;
    overflow-wrap: break-word;
  }
  .editor:empty::before {
    content: "Кликни сюда и начни печатать...";
    color: #9aa5b5;
  }
</style>
</head>
<body>

<div class="word">

  <div class="toolbar">
    <button type="button"><b>Ж</b></button>
    <button type="button"><i>К</i></button>
    <button type="button"><u>Ч</u></button>
    <button type="button"><s>З</s></button>
    <button type="button">Список</button>
    <button type="button">Нумер.</button>
    <button type="button">Слева</button>
    <button type="button">Центр</button>
    <button type="button">Справа</button>
    <button type="button">H1</button>
    <button type="button">H2</button>
    <button type="button">Абзац</button>
  </div>

  <div class="editor" contenteditable="true" spellcheck="false"></div>

</div>

</body>
</html>
