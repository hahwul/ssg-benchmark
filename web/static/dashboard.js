const SSG_META = {
  hugo:     { color: '#FF4088', lang: 'Go',      desc: 'The world\'s fastest framework for building websites' },
  zola:     { color: '#2B7489', lang: 'Rust',    desc: 'A fast static site generator in a single binary' },
  jekyll:   { color: '#CC0000', lang: 'Ruby',    desc: 'Transform your plain text into static websites and blogs' },
  hwaro:    { color: '#E0E0E0', lang: 'Crystal', desc: 'A lightweight static site generator' },
  eleventy: { color: '#FFD700', lang: 'Node.js', desc: 'A simpler static site generator' },
  pelican:  { color: '#328484', lang: 'Python',  desc: 'A static site generator powered by Python' },
  hexo:     { color: '#0E83CD', lang: 'Node.js', desc: 'A fast, simple & powerful blog framework' }
};

let DATA = null;
let trendChart = null;
let selectedPageCount = null;

async function init() {
  try {
    const resp = await fetch('data.json');
    DATA = await resp.json();
  } catch (e) {
    return;
  }

  const el = document.getElementById('updated');
  if (el) el.textContent = 'Last updated: ' + new Date(DATA.generated).toLocaleString();

  renderCards();
  renderScalingChart();
  renderBarCharts();
  renderTrendControls();
  renderTrendChart();
  renderTable();
}

function latestRun() {
  return DATA.runs[DATA.runs.length - 1];
}

function getSSGs() {
  const ssgs = new Set();
  DATA.runs.forEach(function(r) { r.results.forEach(function(d) { ssgs.add(d.ssg); }); });
  return Array.from(ssgs).sort();
}

function getPageCounts() {
  const pcs = new Set();
  DATA.runs.forEach(function(r) { r.results.forEach(function(d) { pcs.add(d.page_count); }); });
  return Array.from(pcs).sort(function(a, b) { return a - b; });
}

function formatMs(ms) {
  if (ms >= 1000) return (ms / 1000).toFixed(2) + 's';
  return ms + 'ms';
}

function renderCards() {
  var run = latestRun();
  var container = document.getElementById('ssg-cards');
  if (!container) return;
  var ssgs = getSSGs();

  ssgs.forEach(function(ssg) {
    var meta = SSG_META[ssg] || { color: '#888', lang: '?', desc: '' };
    var ssgResults = run.results.filter(function(r) { return r.ssg === ssg; });
    var maxPc = Math.max.apply(null, ssgResults.map(function(r) { return r.page_count; }));
    var entry = run.results.find(function(r) { return r.ssg === ssg && r.page_count === maxPc; });
    var card = document.createElement('div');
    card.className = 'card';
    card.style.borderLeftColor = meta.color;
    card.innerHTML =
      '<h3 style="color:' + meta.color + '">' + ssg.charAt(0).toUpperCase() + ssg.slice(1) + '</h3>' +
      '<div class="lang">' + meta.lang + '</div>' +
      '<div class="desc">' + meta.desc + '</div>' +
      (entry ? '<div class="stat" style="color:' + meta.color + '">' + formatMs(entry.avg_time_ms) + ' <small>@ ' + maxPc.toLocaleString() + ' pages</small></div>' : '');
    container.appendChild(card);
  });
}

function renderScalingChart() {
  var canvas = document.getElementById('scalingChart');
  if (!canvas) return;
  var run = latestRun();
  var ssgs = getSSGs();
  var pageCounts = getPageCounts();

  var datasets = ssgs.map(function(ssg) {
    var meta = SSG_META[ssg] || { color: '#888' };
    var data = pageCounts.map(function(pc) {
      var entry = run.results.find(function(r) { return r.ssg === ssg && r.page_count === pc; });
      return entry ? entry.avg_time_ms : null;
    });
    return {
      label: ssg.charAt(0).toUpperCase() + ssg.slice(1),
      data: data,
      borderColor: meta.color,
      backgroundColor: meta.color + '20',
      tension: 0.3,
      pointRadius: 5,
      pointHoverRadius: 7,
      fill: false
    };
  });

  new Chart(canvas, {
    type: 'line',
    data: { labels: pageCounts.map(function(pc) { return pc.toLocaleString() + ' pages'; }), datasets: datasets },
    options: chartOptions('Build Time (ms)')
  });
}

function renderBarCharts() {
  var container = document.getElementById('barCharts');
  if (!container) return;
  var run = latestRun();
  var ssgs = getSSGs();
  var pageCounts = getPageCounts();

  pageCounts.forEach(function(pc) {
    var wrapper = document.createElement('div');
    wrapper.innerHTML = '<h3 style="color:var(--text-muted);font-size:0.9rem;margin-bottom:8px">' + pc.toLocaleString() + ' Pages</h3><div class="chart-wrapper"><canvas></canvas></div>';
    container.appendChild(wrapper);

    var canvas = wrapper.querySelector('canvas');
    var data = ssgs.map(function(ssg) {
      var entry = run.results.find(function(r) { return r.ssg === ssg && r.page_count === pc; });
      return entry ? entry.avg_time_ms : 0;
    });
    var colors = ssgs.map(function(s) { return (SSG_META[s] || { color: '#888' }).color; });

    new Chart(canvas, {
      type: 'bar',
      data: {
        labels: ssgs.map(function(s) { return s.charAt(0).toUpperCase() + s.slice(1); }),
        datasets: [{ data: data, backgroundColor: colors.map(function(c) { return c + 'CC'; }), borderColor: colors, borderWidth: 1 }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { display: false }, tooltip: { callbacks: { label: function(ctx) { return formatMs(ctx.raw); } } } },
        scales: {
          y: { title: { display: true, text: 'ms', color: '#8b949e' }, ticks: { color: '#8b949e' }, grid: { color: '#21262d' } },
          x: { ticks: { color: '#8b949e' }, grid: { display: false } }
        }
      }
    });
  });
}

function renderTrendControls() {
  var pageCounts = getPageCounts();
  var container = document.getElementById('trendControls');
  if (!container) return;
  selectedPageCount = pageCounts[pageCounts.length - 1];

  pageCounts.forEach(function(pc) {
    var btn = document.createElement('button');
    btn.textContent = pc.toLocaleString() + ' pages';
    btn.className = pc === selectedPageCount ? 'active' : '';
    btn.addEventListener('click', function() {
      selectedPageCount = pc;
      container.querySelectorAll('button').forEach(function(b) { b.classList.remove('active'); });
      btn.classList.add('active');
      renderTrendChart();
    });
    container.appendChild(btn);
  });
}

function renderTrendChart() {
  var canvas = document.getElementById('trendChart');
  if (!canvas) return;
  var ssgs = getSSGs();
  var runs = DATA.runs;

  var labels = runs.map(function(r) { return r.date; });
  var datasets = ssgs.map(function(ssg) {
    var meta = SSG_META[ssg] || { color: '#888' };
    var data = runs.map(function(r) {
      var entry = r.results.find(function(d) { return d.ssg === ssg && d.page_count === selectedPageCount; });
      return entry ? entry.avg_time_ms : null;
    });
    return {
      label: ssg.charAt(0).toUpperCase() + ssg.slice(1),
      data: data,
      borderColor: meta.color,
      backgroundColor: meta.color + '20',
      tension: 0.3,
      pointRadius: 4,
      pointHoverRadius: 6,
      fill: false,
      spanGaps: true
    };
  });

  if (trendChart) trendChart.destroy();
  trendChart = new Chart(canvas, {
    type: 'line',
    data: { labels: labels, datasets: datasets },
    options: chartOptions('Build Time (ms)')
  });
}

function chartOptions(yTitle) {
  return {
    responsive: true,
    maintainAspectRatio: false,
    plugins: { tooltip: { callbacks: { label: function(ctx) { return ctx.dataset.label + ': ' + formatMs(ctx.raw); } } } },
    scales: {
      y: { title: { display: true, text: yTitle, color: '#8b949e' }, ticks: { color: '#8b949e' }, grid: { color: '#21262d' } },
      x: { ticks: { color: '#8b949e' }, grid: { color: '#21262d' } }
    }
  };
}

function renderTable() {
  var tbody = document.querySelector('#resultsTable tbody');
  if (!tbody) return;
  var rows = [];

  DATA.runs.forEach(function(run) {
    run.results.forEach(function(r) {
      rows.push({ run: run.date, runId: run.id, ssg: r.ssg, page_count: r.page_count, avg_time_ms: r.avg_time_ms, min_time_ms: r.min_time_ms, max_time_ms: r.max_time_ms });
    });
  });

  var sortCol = 'run';
  var sortAsc = false;

  function render() {
    rows.sort(function(a, b) {
      var va = a[sortCol], vb = b[sortCol];
      if (typeof va === 'string') return sortAsc ? va.localeCompare(vb) : vb.localeCompare(va);
      return sortAsc ? va - vb : vb - va;
    });

    tbody.innerHTML = rows.map(function(r) {
      var meta = SSG_META[r.ssg] || { color: '#888' };
      return '<tr>' +
        '<td>' + r.run + '</td>' +
        '<td><span class="ssg-badge" style="background:' + meta.color + '"></span>' + r.ssg + '</td>' +
        '<td>' + r.page_count.toLocaleString() + '</td>' +
        '<td>' + r.avg_time_ms.toLocaleString() + '</td>' +
        '<td>' + r.min_time_ms.toLocaleString() + '</td>' +
        '<td>' + r.max_time_ms.toLocaleString() + '</td>' +
        '</tr>';
    }).join('');

    document.querySelectorAll('#resultsTable th').forEach(function(th) {
      var existing = th.querySelector('.sort-icon');
      if (existing) existing.remove();
      if (th.dataset.col === sortCol) {
        var span = document.createElement('span');
        span.className = 'sort-icon';
        span.textContent = sortAsc ? ' \u25B2' : ' \u25BC';
        th.appendChild(span);
      }
    });
  }

  document.querySelectorAll('#resultsTable th').forEach(function(th) {
    th.addEventListener('click', function() {
      if (sortCol === th.dataset.col) { sortAsc = !sortAsc; }
      else { sortCol = th.dataset.col; sortAsc = true; }
      render();
    });
  });

  render();
}

init();
