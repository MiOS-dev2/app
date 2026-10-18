<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="UTF-8">
<title>Конструктор страниц</title>
<style>
  * { box-sizing: border-box; }
  body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #dfe3e8;
    display: flex;
    height: 100vh;
    overflow: hidden;
  }

  .palette {
    width: 180px;
    background: #f0f2f5;
    border-right: 1px solid #b8bec7;
    padding: 10px;
    overflow-y: auto;
  }
  .palette h3 { margin: 0 0 10px; font-size: 14px; color: #333; }
  .palette .item {
    background: #fff;
    border: 1px solid #aab1bb;
    padding: 8px;
    margin-bottom: 6px;
    cursor: grab;
    font-size: 13px;
    text-align: center;
    user-select: none;
  }
  .palette .item:hover { background: #e6efff; }

  .workspace { flex: 1; display: flex; flex-direction: column; }
  .topbar {
    background: #f0f2f5;
    border-bottom: 1px solid #b8bec7;
    padding: 8px 12px;
    display: flex;
    gap: 8px;
    align-items: center;
    flex-wrap: wrap;
  }
  .topbar button {
    padding: 6px 12px;
    border: 1px solid #999;
    background: #fff;
    cursor: pointer;
    font-size: 13px;
  }
  .topbar button:hover { background: #e8e8e8; }
  .topbar .hint { margin-left: auto; font-size: 12px; color: #666; }

  .canvas {
    flex: 1;
    background: #ffffff;
    margin: 12px;
    border: 1px solid #b8bec7;
    overflow: auto;
    position: relative;
    min-height: 300px;
    min-width: 300px;
  }
  .canvas.dragover { background: #eef4ff; }

  .block {
    position: absolute;
    border: 1px dashed #8a94a3;
    padding: 6px 10px;
    background: #fafbfc;
    min-width: 40px;
    cursor: move;
    user-select: none;
  }
  .block.selected {
    border: 1px solid #2563eb;
    box-shadow: 0 0 0 2px #bfd3ff;
  }
  .block.dragging { opacity: 0.7; }
  .block .del {
    position: absolute;
    right: -8px;
    top: -8px;
    width: 18px;
    height: 18px;
    line-height: 16px;
    text-align: center;
    font-size: 12px;
    background: #fff;
    border: 1px solid #999;
    cursor: pointer;
    padding: 0;
    display: none;
    z-index: 10;
    color: #c00;
    font-weight: bold;
  }
  .block.selected .del { display: block; }

  .block > * { pointer-events: none; }

  .props {
    width: 250px;
    background: #f0f2f5;
    border-left: 1px solid #b8bec7;
    padding: 12px;
    overflow-y: auto;
  }
  .props h3 { margin: 0 0 10px; font-size: 14px; color: #333; }
  .props label { display: block; font-size: 12px; margin: 8px 0 3px; color: #444; }
  .props input, .props textarea, .props select {
    width: 100%;
    padding: 5px;
    font-size: 13px;
    border: 1px solid #aab1bb;
    font-family: inherit;
  }
  .props textarea { resize: vertical; min-height: 60px; }
  .props .empty { font-size: 12px; color: #888; }
  .props input[type="color"] {
    padding: 0;
    height: 30px;
    cursor: pointer;
  }
  .props input[type="range"] { padding: 0; }

  /* ===== Окно MiOS (тема Ubuntu, как в ui/wm.c) ===== */
  .canvas { background:#7d8798; margin:12px; }
  .canvas.dragover { background:#8a94a6; }
  .mwin { position:absolute; left:20px; top:20px; background:#f6f6f6; border-right:1px solid #3c3c3c; border-bottom:1px solid #3c3c3c; user-select:none; }
  .mtitle { position:absolute; left:0; top:0; right:0; height:30px; background:#303030; border-bottom:1px solid #3c3c3c; }
  .micon { position:absolute; left:15px; top:10px; width:10px; height:10px; background:#e6e6e6; }
  .micon:after { content:''; position:absolute; left:3px; top:3px; width:4px; height:4px; background:#c8c8c8; }
  .mtext { position:absolute; left:36px; top:7px; width:calc(100% - 144px); overflow:hidden; white-space:nowrap; color:#e6e6e6; font:13px/16px "DejaVu Sans Mono",Consolas,"Courier New",monospace; }
  .mbtn { position:absolute; top:1px; width:28px; height:28px; background:#303030; }
  .mbtn svg { display:block; }
  .mclient { position:absolute; left:0; top:30px; right:0; bottom:0; overflow:hidden; background:#f6f6f6; color:#000;
    font-family:"DejaVu Sans","Liberation Sans",Verdana,Arial,sans-serif; font-size:16px; line-height:1.3; }
  .rz { position:absolute; z-index:5; }
  .rz-r { right:-4px; top:30px; bottom:0; width:7px; cursor:ew-resize; }
  .rz-b { bottom:-4px; left:0; right:0; height:7px; cursor:ns-resize; }
  .rz-c { right:-4px; bottom:-4px; width:15px; height:15px; cursor:nwse-resize; z-index:6; }
  .block { padding:0; border:0; background:transparent; min-width:0; outline:1px dashed #8a94a3; outline-offset:0; }
  .block.selected { border:0; outline:1px solid #2563eb; box-shadow:0 0 0 2px #bfd3ff; }
  /* элементы страницы как рисует веб-движок MiOS */
  .block h1,.block h2,.block p { margin:0; }
  .block h1 { font-size:32px; line-height:1.3; }
  .block h2 { font-size:24px; line-height:1.3; }
  .mios-btn { box-sizing:border-box; height:25px; padding:0 10px; border:1px solid #8e8e8e; border-radius:0; background:linear-gradient(#f4f4f4,#dedede);
    color:#202020; font:13px "DejaVu Sans","Liberation Sans",Verdana,Arial,sans-serif; white-space:nowrap; }
  .mios-in { box-sizing:border-box; width:180px; height:25px; padding:0 5px; border:1px solid #9a9a9a; border-radius:0; background:#fff;
    color:#202020; font:13px "DejaVu Sans","Liberation Sans",Verdana,Arial,sans-serif; outline:none; }
  .mios-in::placeholder { color:#909090; opacity:1; }
  .tab { font-weight:bold; }
  .tab.active { background:#2563eb !important; color:#fff; border-color:#2563eb !important; }
  .codepane { flex:1; margin:12px; display:none; flex-direction:column; min-height:0; }
  .codebar { display:flex; gap:8px; align-items:center; padding:0 0 6px; font-size:12px; color:#444; }
  .codebar button { padding:5px 10px; border:1px solid #999; background:#fff; cursor:pointer; font-size:12px; }
  .codebar .msg { margin-left:auto; }
  .codebar .msg.err { color:#c00; }
  #codeArea { flex:1; width:100%; resize:none; border:1px solid #b8bec7; background:#1e1e1e; color:#d4d4d4; padding:10px;
    font:13px/1.45 "DejaVu Sans Mono",Consolas,"Courier New",monospace; tab-size:2; white-space:pre; overflow:auto; outline:none; }
</style>
</head>
<body>

<div class="palette">
  <h3>Блоки</h3>
  <div class="item" draggable="true" data-type="h1">Заголовок H1</div>
  <div class="item" draggable="true" data-type="h2">Заголовок H2</div>
  <div class="item" draggable="true" data-type="p">Текст (абзац)</div>
  <div class="item" draggable="true" data-type="clock">Время</div>
  <div class="item" draggable="true" data-type="button">Кнопка</div>
  <div class="item" draggable="true" data-type="input">Поле ввода</div>
  <div class="item" draggable="true" data-type="hr">Линия</div>
  <div class="item" draggable="true" data-type="img">Картинка</div>
  <div class="item" draggable="true" data-type="colorbox">Цветной блок</div>
</div>

<div class="workspace">
  <div class="topbar">
    <button id="tabDesign" class="tab active">Дизайн</button>
    <button id="tabCode" class="tab">Code</button>
    <button id="downloadHtmlBtn">Скачать .html</button>
    <button id="downloadMpBtn">Скачать .mp</button>
    <button id="clearBtn">Очистить</button>
    <span class="hint">Перетащи блок в окно MiOS. Размер окна: тянуть за правый/нижний край или в свойствах.</span>
  </div>
  <div class="canvas" id="desktop">
      <div class="mwin" id="mwin">
        <div class="mtitle" id="mtitle"><span class="micon"></span><span class="mtext" id="mtext"></span>
          <div class="mbtn" style="right:72px"><svg width="28" height="28" viewBox="0 0 28 28" fill="none" stroke="#b4b4b4" shape-rendering="crispEdges"><path d="M7 16.5h14"/></svg></div><div class="mbtn" style="right:40px"><svg width="28" height="28" viewBox="0 0 28 28" fill="none" stroke="#b4b4b4" shape-rendering="crispEdges"><rect x="10.5" y="10.5" width="8" height="8"/></svg></div><div class="mbtn" style="right:8px"><svg width="28" height="28" viewBox="0 0 28 28" fill="none" stroke="#b4b4b4" shape-rendering="crispEdges"><path d="M10 10l9 9M10 18l9-9"/></svg></div>
        </div>
        <div class="mclient" id="canvas"></div>
        <div class="rz rz-r" data-rz="r"></div><div class="rz rz-b" data-rz="b"></div><div class="rz rz-c" data-rz="c"></div>
      </div>
    </div>
  <div class="codepane" id="codepane">
    <div class="codebar">
      <button id="codeApply">Применить к дизайну</button>
      <button id="codeReload">Обновить из дизайна</button>
      <span class="msg" id="codeMsg">Код можно править; при возврате в «Дизайн» он применится.</span>
    </div>
    <textarea id="codeArea" spellcheck="false"></textarea>
  </div>
</div>

<div class="props" id="propsBox">
  <h3>Свойства</h3>
  <div id="propPanel">
    <span class="empty">Блок не выбран</span>
  </div>
</div>

<script>
(function () {
  var canvas = document.getElementById('canvas');
  var propPanel = document.getElementById('propPanel');
  var selected = null;
  var blockId = 0;
  function clockStr() {
    var n = new Date();
    return [n.getHours(), n.getMinutes(), n.getSeconds()].map(function (v) { return (v < 10 ? '0' : '') + v; }).join(':');
  }
  setInterval(function () {
    var cs = document.querySelectorAll('.mios-clock');
    for (var ci = 0; ci < cs.length; ci++) cs[ci].textContent = clockStr();
  }, 1000);
  var win = { title: 'Моё приложение', w: 640, h: 420, bg: '#f6f6f6' };
  var mwin = document.getElementById('mwin');
  var desktop = document.getElementById('desktop');
  function applyWindow() {
    win.w = Math.max(160, Math.min(3000, Math.round(win.w) || 160));
    win.h = Math.max(80, Math.min(3000, Math.round(win.h) || 80));
    mwin.style.width = win.w + 'px';
    mwin.style.height = win.h + 'px';
    mwin.style.background = win.bg;
    canvas.style.background = win.bg;
    document.getElementById('mtext').textContent = win.title;
  }
  applyWindow();

  var defaults = {
    h1:       { text: 'Заголовок', color: '#000000', weight: 'bold' },
    h2:       { text: 'Подзаголовок', color: '#000000', weight: 'bold' },
    clock:    { color: '#000000', weight: 'normal' },
    p:        { text: 'Текст абзаца. Нажми чтобы изменить.', color: '#000000', weight: 'normal' },
    button:   { text: 'Кнопка', launch: '' },
    input:    { placeholder: 'Введите...' },
    hr:       {},
    img:      { src: '', alt: 'картинка' },
    colorbox: { text: 'Цветной блок', bg: '#ffd166', color: '#000000', weight: 'normal' }
  };

  function buildElement(data) {
    var el;
    if (data.type === 'h1') {
      el = document.createElement('h1');
      el.textContent = data.text || '';
      el.style.fontWeight = data.weight || 'bold';
      el.style.color = data.color || '#000000';
    } else if (data.type === 'h2') {
      el = document.createElement('h2');
      el.textContent = data.text || '';
      el.style.fontWeight = data.weight || 'bold';
      el.style.color = data.color || '#000000';
    } else if (data.type === 'p') {
      el = document.createElement('p');
      el.textContent = data.text || '';
      el.style.fontWeight = data.weight || 'normal';
      el.style.color = data.color || '#000000';
    } else if (data.type === 'clock') {
      el = document.createElement('p');
      el.className = 'mios-clock';
      el.textContent = clockStr();
      el.style.fontWeight = data.weight || 'normal';
      el.style.color = data.color || '#000000';
    } else if (data.type === 'button') {
      el = document.createElement('button');
      el.className = 'mios-btn';
      el.textContent = data.text || '';
    } else if (data.type === 'input') {
      el = document.createElement('input');
      el.type = 'text';
      el.className = 'mios-in';
      el.placeholder = data.placeholder || '';
    } else if (data.type === 'hr') {
      el = document.createElement('hr');
      el.style.width = '200px'; el.style.border = '1px solid #aaa'; el.style.height = '0'; el.style.boxSizing = 'content-box';
    } else if (data.type === 'img') {
      el = document.createElement('img');
      el.alt = data.alt || '';
      el.style.maxWidth = '300px';
      el.style.display = 'block';
      if (data.src) {
        el.src = data.src;
        el.onerror = function () {
          el.style.display = 'none';
          if (!el._placeholder) {
            var ph = document.createElement('div');
            ph.className = 'img-placeholder';
            ph.textContent = 'Картинка не загружена';
            ph.style.cssText = 'padding:20px;border:1px dashed #c00;color:#c00;font-size:13px;';
            el.parentNode.insertBefore(ph, el);
            el._placeholder = ph;
          }
        };
        el.onload = function () {
          if (el._placeholder) {
            el._placeholder.remove();
            el._placeholder = null;
          }
          el.style.display = 'block';
        };
      } else {
        el.style.display = 'none';
      }
    } else if (data.type === 'colorbox') {
      el = document.createElement('div');
      el.textContent = data.text || '';
      el.style.background = data.bg || '#ffd166';
      el.style.color = data.color || '#000000';
      el.style.fontWeight = data.weight || 'normal';
      el.style.padding = '20px 30px';
      el.style.minWidth = '120px';
      el.style.textAlign = 'center';
      el.style.borderRadius = '4px';
    }
    if (el && el.style) el.style.margin = '0';
    return el;
  }

  function addBlock(type, x, y, preset) {
    var wrapper = document.createElement('div');
    wrapper.className = 'block';
    wrapper.dataset.type = type;
    wrapper.dataset.id = ++blockId;

    var data = { type: type };
    var def = defaults[type] || {};
    for (var k in def) data[k] = def[k];
    if (preset) for (var pk in preset) data[pk] = preset[pk];

    wrapper._data = data;
    wrapper._x = x != null ? x : 20;
    wrapper._y = y != null ? y : 20;
    wrapper.style.left = wrapper._x + 'px';
    wrapper.style.top = wrapper._y + 'px';

    wrapper.appendChild(buildElement(data));
    if (type === 'img' && !data.src) {
      var ph = document.createElement('div');
      ph.className = 'img-placeholder';
      ph.textContent = 'Укажи URL картинки справа';
      ph.style.cssText = 'padding:20px;border:1px dashed #888;color:#888;font-size:13px;';
      wrapper.appendChild(ph);
    }

    var del = document.createElement('span');
    del.className = 'del';
    del.textContent = 'X';
    del.title = 'Удалить';
    del.addEventListener('mousedown', function (e) {
      e.stopPropagation();
    });
    del.addEventListener('click', function (e) {
      e.stopPropagation();
      if (selected === wrapper) { selected = null; renderProps(); }
      wrapper.remove();
    });
    wrapper.appendChild(del);

    wrapper.addEventListener('mousedown', onBlockMouseDown);

    canvas.appendChild(wrapper);
    selectBlock(wrapper);
  }

  function selectBlock(wrapper) {
    if (selected) selected.classList.remove('selected');
    selected = wrapper;
    if (selected) selected.classList.add('selected');
    renderProps();
  }

  var dragState = null;
  var winWIn = null, winHIn = null;

  function onBlockMouseDown(e) {
    if (e.target.classList && e.target.classList.contains('del')) return;
    e.stopPropagation();
    var wrapper = e.currentTarget;
    selectBlock(wrapper);

    dragState = {
      el: wrapper,
      mouseX: e.clientX,
      mouseY: e.clientY,
      left: wrapper._x,
      top: wrapper._y
    };

    wrapper.classList.add('dragging');
    document.addEventListener('mousemove', onDocMouseMove);
    document.addEventListener('mouseup', onDocMouseUp);
  }

  function onDocMouseMove(e) {
    if (!dragState) return;
    var dx = e.clientX - dragState.mouseX;
    var dy = e.clientY - dragState.mouseY;

    var nx = dragState.left + dx;
    var ny = dragState.top + dy;

    var el = dragState.el;
    var maxX = canvas.clientWidth - el.offsetWidth;
    var maxY = canvas.clientHeight - el.offsetHeight;
    if (nx < 0) nx = 0;
    if (ny < 0) ny = 0;
    if (nx > maxX && maxX > 0) nx = maxX;
    if (ny > maxY && maxY > 0) ny = maxY;

    el._x = nx;
    el._y = ny;
    el.style.left = nx + 'px';
    el.style.top = ny + 'px';
  }

  function onDocMouseUp() {
    if (dragState) {
      dragState.el.classList.remove('dragging');
      dragState = null;
    }
    document.removeEventListener('mousemove', onDocMouseMove);
    document.removeEventListener('mouseup', onDocMouseUp);
  }

  function renderProps() {
    propPanel.innerHTML = '';
    if (!selected) {
      var wh = document.createElement('div');
      wh.style.cssText = 'font-size:12px;color:#666;margin-bottom:4px;';
      wh.textContent = 'Окно приложения';
      propPanel.appendChild(wh);
      var wf = function (label, key, type, attrs) {
        var l = document.createElement('label'); l.textContent = label; propPanel.appendChild(l);
        var i = document.createElement('input'); i.type = type;
        if (attrs) for (var q in attrs) i.setAttribute(q, attrs[q]);
        i.value = win[key];
        i.addEventListener('input', function () {
          win[key] = (type === 'number') ? (parseInt(i.value, 10) || 0) : i.value;
          applyWindow();
        });
        propPanel.appendChild(i);
        return i;
      };
      wf('Заголовок', 'title', 'text');
      winWIn = wf('Ширина', 'w', 'number', { min: 160, max: 3000 });
      winHIn = wf('Высота', 'h', 'number', { min: 80, max: 3000 });
      wf('Цвет фона окна', 'bg', 'color');
      return;
    }

    var data = selected._data;

    function addField(labelText, key, type, opts) {
      var lbl = document.createElement('label');
      lbl.textContent = labelText;
      propPanel.appendChild(lbl);

      var inp;
      if (type === 'textarea') {
        inp = document.createElement('textarea');
      } else {
        inp = document.createElement('input');
        inp.type = type || 'text';
      }
      if (opts) {
        for (var k in opts) inp.setAttribute(k, opts[k]);
      }
      inp.value = data[key] != null ? data[key] : '';

      inp.addEventListener('input', function () {
        data[key] = inp.value;
        applyData(selected, data);
      });
      inp.addEventListener('mousedown', function (ev) { ev.stopPropagation(); });

      propPanel.appendChild(inp);
    }

    var textTypes = ['h1', 'h2', 'p', 'clock', 'colorbox'];
    if (data.type === 'button') {
      addField('Текст', 'text', 'text');
      var llbl = document.createElement('label');
      llbl.textContent = 'Запуск приложения MiOS';
      propPanel.appendChild(llbl);
      var lsel = document.createElement('select');
      var apps = [['', '— ничего —'], ['terminal', 'Terminal'], ['files', 'Files'], ['paint', 'Paint'], ['notepad', 'Notepad'],
        ['settings', 'Settings'], ['about', 'About OS'], ['media', 'Media'], ['calendar', 'Calendar'], ['clock', 'Clock'],
        ['taskmgr', 'Task Manager'], ['pcinfo', 'PC Info'], ['support', 'Support Center'], ['cretool', 'Cre Tool']];
      for (var ai = 0; ai < apps.length; ai++) {
        var ao = document.createElement('option');
        ao.value = apps[ai][0]; ao.textContent = apps[ai][1];
        if ((data.launch || '') === apps[ai][0]) ao.selected = true;
        lsel.appendChild(ao);
      }
      lsel.addEventListener('change', function () { data.launch = lsel.value; });
      lsel.addEventListener('mousedown', function (ev) { ev.stopPropagation(); });
      propPanel.appendChild(lsel);
    }
    if (textTypes.indexOf(data.type) !== -1) {
      if (data.type !== 'clock') addField('Текст', 'text', data.type === 'p' ? 'textarea' : 'text');

      var wlbl = document.createElement('label');
      wlbl.textContent = 'Толщина текста';
      propPanel.appendChild(wlbl);
      var wsel = document.createElement('select');
      var weights = [['normal', 'Обычный'], ['bold', 'Жирный'], ['300', 'Тонкий'], ['600', 'Полужирный'], ['900', 'Очень жирный']];
      for (var i = 0; i < weights.length; i++) {
        var opt = document.createElement('option');
        opt.value = weights[i][0];
        opt.textContent = weights[i][1];
        if (data.weight === weights[i][0]) opt.selected = true;
        wsel.appendChild(opt);
      }
      wsel.addEventListener('change', function () {
        data.weight = wsel.value;
        applyData(selected, data);
      });
      wsel.addEventListener('mousedown', function (ev) { ev.stopPropagation(); });
      propPanel.appendChild(wsel);

      addField('Цвет текста', 'color', 'color');
    }

    if (data.type === 'colorbox') {
      addField('Фон', 'bg', 'color');
    }

    if (data.type === 'input') {
      addField('Placeholder', 'placeholder', 'text');
    }

    if (data.type === 'img') {
      addField('URL картинки', 'src', 'text');
      addField('Alt текст', 'alt', 'text');
    }

    if (data.type === 'hr') {
      var info = document.createElement('span');
      info.className = 'empty';
      info.textContent = 'У линии нет свойств';
      propPanel.appendChild(info);
    }

    var coordLabel = document.createElement('label');
    coordLabel.textContent = 'Позиция (X, Y)';
    propPanel.appendChild(coordLabel);

    var coordWrap = document.createElement('div');
    coordWrap.style.display = 'flex';
    coordWrap.style.gap = '4px';

    var inX = document.createElement('input');
    inX.type = 'number';
    inX.value = Math.round(selected._x);
    inX.addEventListener('mousedown', function (ev) { ev.stopPropagation(); });
    inX.addEventListener('input', function () {
      selected._x = parseInt(inX.value, 10) || 0;
      selected.style.left = selected._x + 'px';
    });

    var inY = document.createElement('input');
    inY.type = 'number';
    inY.value = Math.round(selected._y);
    inY.addEventListener('mousedown', function (ev) { ev.stopPropagation(); });
    inY.addEventListener('input', function () {
      selected._y = parseInt(inY.value, 10) || 0;
      selected.style.top = selected._y + 'px';
    });

    coordWrap.appendChild(inX);
    coordWrap.appendChild(inY);
    propPanel.appendChild(coordWrap);
  }

  function applyData(wrapper, data) {
    var del = wrapper.querySelector('.del');
    var children = Array.prototype.slice.call(wrapper.children);
    for (var i = 0; i < children.length; i++) {
      if (children[i] !== del) wrapper.removeChild(children[i]);
    }
    var fresh = buildElement(data);
    if (del) wrapper.insertBefore(fresh, del);
    else wrapper.appendChild(fresh);

    if (data.type === 'img' && !data.src) {
      var ph = document.createElement('div');
      ph.className = 'img-placeholder';
      ph.textContent = 'Укажи URL картинки справа';
      ph.style.cssText = 'padding:20px;border:1px dashed #888;color:#888;font-size:13px;';
      if (del) wrapper.insertBefore(ph, del);
      else wrapper.appendChild(ph);
    }
  }

  var dragType = null;
  var items = document.querySelectorAll('.palette .item');
  for (var i = 0; i < items.length; i++) {
    items[i].addEventListener('dragstart', function (e) {
      dragType = this.dataset.type;
      e.dataTransfer.effectAllowed = 'copy';
      e.dataTransfer.setData('text/plain', this.dataset.type);
    });
  }

  canvas.addEventListener('dragover', function (e) {
    e.preventDefault();
    canvas.classList.add('dragover');
  });
  canvas.addEventListener('dragleave', function () {
    canvas.classList.remove('dragover');
  });
  canvas.addEventListener('drop', function (e) {
    e.preventDefault();
    canvas.classList.remove('dragover');
    var t = dragType || e.dataTransfer.getData('text/plain');
    if (!t) return;
    var rect = canvas.getBoundingClientRect();
    var x = e.clientX - rect.left + canvas.scrollLeft;
    var y = e.clientY - rect.top + canvas.scrollTop;
    addBlock(t, x, y);
    dragType = null;
  });

  canvas.addEventListener('mousedown', function () {
    if (selected) {
      selected.classList.remove('selected');
      selected = null;
      renderProps();
    }
  });

  var rzState = null;
  var rzs = document.querySelectorAll('.rz');
  for (var ri = 0; ri < rzs.length; ri++) {
    rzs[ri].addEventListener('mousedown', function (e) {
      e.preventDefault(); e.stopPropagation();
      rzState = { m: this.dataset.rz, x: e.clientX, y: e.clientY, w: win.w, h: win.h };
    });
  }
  document.addEventListener('mousemove', function (e) {
    if (!rzState) return;
    if (rzState.m !== 'b') win.w = rzState.w + e.clientX - rzState.x;
    if (rzState.m !== 'r') win.h = rzState.h + e.clientY - rzState.y;
    applyWindow();
    if (winWIn && !selected) { winWIn.value = win.w; winHIn.value = win.h; }
  });
  document.addEventListener('mouseup', function () { rzState = null; });
  function deselect() {
    if (selected) { selected.classList.remove('selected'); selected = null; }
    renderProps();
  }
  desktop.addEventListener('mousedown', deselect);
  mwin.addEventListener('mousedown', function (e) { e.stopPropagation(); if (!e.target.classList.contains('rz')) deselect(); });
  renderProps();

  function buildHtml() {
    var maxRight = win.w, maxBottom = win.h - 30;
    var blocks = canvas.querySelectorAll('.block');
    for (var j = 0; j < blocks.length; j++) {
      var b = blocks[j];
      if (b._x + b.offsetWidth > maxRight) maxRight = b._x + b.offsetWidth;
      if (b._y + b.offsetHeight > maxBottom) maxBottom = b._y + b.offsetHeight;
    }

    var html = '<!DOCTYPE html>\n<html lang="ru">\n<head>\n<meta charset="UTF-8">\n';
    html += '<meta name="window-size" content="' + win.w + 'x' + win.h + '">\n';
    html += '<title>' + esc(win.title) + '</title>\n<style>\n';
    html += 'body{margin:0;font-family:Arial,sans-serif;background:' + win.bg + ';}\n';
    html += '.stage{position:relative;width:' + (win.w - 20) + 'px;height:' + (win.h - 40) + 'px;margin:0 auto;}\n';
    html += '.stage > *{position:absolute;margin:0;}\n';
    html += 'button{padding:0 10px;height:25px;cursor:pointer;border:1px solid #8e8e8e;background:linear-gradient(#f4f4f4,#dedede);color:#202020;font-size:13px;}\n';
    html += 'input{padding:0 5px;height:25px;width:180px;font-size:13px;border:1px solid #9a9a9a;box-sizing:border-box;}\n';
    html += '</style>\n</head>\n<body>\n<div class="stage">\n';

    for (var k = 0; k < blocks.length; k++) {
      var blk = blocks[k];
      var d = blk._data;
      var st = 'left:' + Math.round(blk._x) + 'px;top:' + Math.round(blk._y) + 'px;';
      var tag;

      if (d.type === 'h1') tag = '<h1 style="' + st + 'color:' + (d.color || '#000000') + ';font-weight:' + (d.weight || 'bold') + ';">' + esc(d.text) + '</h1>';
      else if (d.type === 'h2') tag = '<h2 style="' + st + 'color:' + (d.color || '#000000') + ';font-weight:' + (d.weight || 'bold') + ';">' + esc(d.text) + '</h2>';
      else if (d.type === 'clock') tag = '<p data-clock="time" style="' + st + 'color:' + (d.color || '#000000') + ';font-weight:' + (d.weight || 'normal') + ';">00:00:00</p>';
      else if (d.type === 'p') tag = '<p style="' + st + 'color:' + (d.color || '#000000') + ';font-weight:' + (d.weight || 'normal') + ';">' + esc(d.text) + '</p>';
      else if (d.type === 'button') tag = '<button' + (d.launch ? ' type="button" data-launch="' + esc(d.launch) + '"' : '') + ' style="' + st + '">' + esc(d.text) + '</button>';
      else if (d.type === 'input') tag = '<input type="text" placeholder="' + esc(d.placeholder) + '" style="' + st + '">';
      else if (d.type === 'hr') tag = '<hr style="' + st + 'width:200px;border:1px solid #aaa;height:0;">';
      else if (d.type === 'img') {
        if (d.src) tag = '<img src="' + esc(d.src) + '" alt="' + esc(d.alt) + '" style="' + st + 'max-width:300px;">';
        else tag = '';
      }
      else if (d.type === 'colorbox') tag = '<div style="' + st + 'background:' + (d.bg || '#ffd166') + ';color:' + (d.color || '#000000') + ';font-weight:' + (d.weight || 'normal') + ';padding:20px 30px;text-align:center;border-radius:4px;min-width:120px;">' + esc(d.text) + '</div>';
      else continue;

      if (tag) html += tag + '\n';
    }

    html += '</div>\n</body>\n</html>';
    return html;
  }

  // ===== Вкладка Code =====
  var codeArea = document.getElementById('codeArea');
  var codeMsg = document.getElementById('codeMsg');
  var codePane = document.getElementById('codepane');
  var propsBox = document.getElementById('propsBox');
  var tabDesign = document.getElementById('tabDesign');
  var tabCode = document.getElementById('tabCode');
  var codeDirty = false, inCode = false;

  function say(t, err) { codeMsg.textContent = t; codeMsg.className = 'msg' + (err ? ' err' : ''); }
  function toHex(c, fb) {
    if (!c) return fb;
    c = c.trim();
    if (/^#[0-9a-f]{6}$/i.test(c)) return c.toLowerCase();
    if (/^#[0-9a-f]{3}$/i.test(c)) return '#' + c[1] + c[1] + c[2] + c[2] + c[3] + c[3];
    var m = c.match(/rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/);
    if (m) return '#' + [m[1], m[2], m[3]].map(function (n) { return ('0' + (+n).toString(16)).slice(-2); }).join('');
    return fb;
  }

  function applyCode() {
    var doc;
    try { doc = new DOMParser().parseFromString(codeArea.value, 'text/html'); } catch (e) { say('Ошибка разбора: ' + e.message, true); return false; }
    var stage = doc.querySelector('.stage');
    if (!stage) { say('Не найден <div class="stage"> — блоки не применены.', true); return false; }
    var list = [];
    for (var i = 0; i < stage.children.length; i++) {
      var el = stage.children[i], st = el.style, tag = el.tagName.toLowerCase(), d = null;
      var x = parseInt(st.left, 10) || 0, y = parseInt(st.top, 10) || 0;
      var col = toHex(st.color, '#000000'), wt = st.fontWeight || '';
      if (wt === '700') wt = 'bold'; if (wt === '400') wt = 'normal';
      if (tag === 'h1' || tag === 'h2') d = { type: tag, text: el.textContent, color: col, weight: wt || 'bold' };
      else if (tag === 'p' && el.hasAttribute('data-clock')) d = { type: 'clock', color: col, weight: wt || 'normal' };
      else if (tag === 'p') d = { type: 'p', text: el.textContent, color: col, weight: wt || 'normal' };
      else if (tag === 'button') d = { type: 'button', text: el.textContent, launch: el.getAttribute('data-launch') || '' };
      else if (tag === 'input') d = { type: 'input', placeholder: el.getAttribute('placeholder') || '' };
      else if (tag === 'hr') d = { type: 'hr' };
      else if (tag === 'img') d = { type: 'img', src: el.getAttribute('src') || '', alt: el.getAttribute('alt') || '' };
      else if (tag === 'div') d = { type: 'colorbox', text: el.textContent, color: col, bg: toHex(st.backgroundColor, '#ffd166'), weight: wt || 'normal' };
      if (d) list.push({ d: d, x: x, y: y });
    }
    var cssText = '';
    var sm = codeArea.value.match(/<style>([\s\S]*?)<\/style>/);
    if (sm) cssText = sm[1];
    var bm = cssText.match(/body\s*\{[^}]*?background:\s*([^;}]+)/);
    if (bm) win.bg = toHex(bm[1], win.bg);
    if (doc.title) win.title = doc.title;
    var wm = codeArea.value.match(/<meta\s+name=["']window-size["']\s+content=["'](\d+)x(\d+)["']/i);
    if (wm) { win.w = parseInt(wm[1], 10); win.h = parseInt(wm[2], 10); }
    canvas.innerHTML = '';
    selected = null;
    for (var j = 0; j < list.length; j++) addBlock(list[j].d.type, list[j].x, list[j].y, list[j].d);
    selected && selected.classList.remove('selected');
    selected = null;
    applyWindow();
    renderProps();
    codeDirty = false;
    say('Применено блоков: ' + list.length + '. Теги вне набора MiOS-конструктора пропущены.');
    return true;
  }

  function showTab(code) {
    if (code === inCode) return;
    if (code) {
      codeArea.value = buildHtml();
      codeDirty = false;
      desktop.style.display = 'none';
      propsBox.style.display = 'none';
      codePane.style.display = 'flex';
      say('Код можно править; при возврате в «Дизайн» он применится.');
    } else {
      if (codeDirty && !applyCode()) return;
      codePane.style.display = 'none';
      desktop.style.display = '';
      propsBox.style.display = '';
    }
    inCode = code;
    tabCode.classList.toggle('active', code);
    tabDesign.classList.toggle('active', !code);
  }
  tabDesign.addEventListener('click', function () { showTab(false); });
  tabCode.addEventListener('click', function () { showTab(true); });
  codeArea.addEventListener('input', function () { codeDirty = true; say('Есть неприменённые изменения.'); });
  codeArea.addEventListener('keydown', function (e) {
    if (e.key === 'Tab') {
      e.preventDefault();
      var a = codeArea.selectionStart, b = codeArea.selectionEnd;
      codeArea.value = codeArea.value.slice(0, a) + '  ' + codeArea.value.slice(b);
      codeArea.selectionStart = codeArea.selectionEnd = a + 2;
      codeDirty = true;
    }
  });
  document.getElementById('codeApply').addEventListener('click', applyCode);
  document.getElementById('codeReload').addEventListener('click', function () {
    codeArea.value = buildHtml(); codeDirty = false; say('Код обновлён из дизайна.');
  });

  function download(filename) {
    var blob = new Blob([inCode ? codeArea.value : buildHtml()], { type: 'text/html;charset=utf-8' });
    var url = URL.createObjectURL(blob);
    var a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }

  document.getElementById('downloadHtmlBtn').addEventListener('click', function () {
    download('page.html');
  });

  document.getElementById('downloadMpBtn').addEventListener('click', function () {
    download('page.mp');
  });

  document.getElementById('clearBtn').addEventListener('click', function () {
    if (confirm('Удалить все блоки с холста?')) {
      canvas.innerHTML = '';
      selected = null;
      renderProps();
    }
  });

  function esc(s) {
    if (s == null) return '';
    return String(s)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }
})();
</script>

</body>
</html>