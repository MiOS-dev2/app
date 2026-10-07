<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="UTF-8">
<style>
body { font-family: sans-serif; margin: 10px; }
textarea { width: 100%; height: 300px; }
#about { display: none; margin-top: 10px; }
#about:target { display: block; }
</style>
</head>
<body>
<h3>Редактор <a href="#about">About</a></h3>
<textarea placeholder="Печатай..."></textarea>
<div id="about">
<p>Простой текстовый редактор без JS.</p>
<a href="#">Закрыть</a>
</div>
</body>
</html>