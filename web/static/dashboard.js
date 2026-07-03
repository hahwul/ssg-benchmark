const SSG_META = {
  hugo:     { color: '#FF4088', lang: 'Go',      desc: 'The world\'s fastest framework for building websites' },
  zola:     { color: '#2B7489', lang: 'Rust',    desc: 'A fast static site generator in a single binary' },
  jekyll:   { color: '#CC0000', lang: 'Ruby',    desc: 'Transform your plain text into static websites and blogs' },
  hwaro:    { color: '#E0E0E0', lang: 'Crystal', desc: 'A lightweight static site generator' },
  eleventy: { color: '#FFD700', lang: 'Node.js', desc: 'A simpler static site generator' },
  pelican:  { color: '#328484', lang: 'Python',  desc: 'A static site generator powered by Python' },
  hexo:       { color: '#0E83CD', lang: 'Node.js', desc: 'A fast, simple & powerful blog framework' },
  gatsby:     { color: '#663399', lang: 'Node.js', desc: 'A React-based open source framework for creating websites' },
  astro:      { color: '#FF5D01', lang: 'Node.js', desc: 'The web framework for content-driven websites' },
  blades:     { color: '#E44D26', lang: 'Rust',    desc: 'A blazing fast dead simple static site generator' },
  docusaurus: { color: '#2E8555', lang: 'Node.js', desc: 'Build optimized websites quickly with React' }
};

const THEME = {
  text: '#edefe6',
  muted: '#969c8f',
  dim: '#686e61',
  grid: 'rgba(255,255,255,0.05)',
  panelBg: '#12140e',
  fontUI: "'Geist', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
  fontMono: "'Geist Mono', ui-monospace, 'SF Mono', Menlo, monospace"
};

let DATA = null;
let trendChart = null;
let selectedPageCount = null;

function applyChartTheme() {
  if (!window.Chart) return;
  Chart.defaults.font.family = THEME.fontUI;
  Chart.defaults.font.size = 12;
  Chart.defaults.color = THEME.muted;
  Chart.defaults.plugins.legend.labels.usePointStyle = true;
  Chart.defaults.plugins.legend.labels.pointStyle = 'circle';
  Chart.defaults.plugins.legend.labels.boxWidth = 6;
  Chart.defaults.plugins.legend.labels.boxHeight = 6;
  Chart.defaults.plugins.legend.labels.padding = 16;
  Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(17,19,14,0.96)';
  Chart.defaults.plugins.tooltip.borderColor = 'rgba(255,255,255,0.09)';
  Chart.defaults.plugins.tooltip.borderWidth = 1;
  Chart.defaults.plugins.tooltip.cornerRadius = 10;
  Chart.defaults.plugins.tooltip.padding = 12;
  Chart.defaults.plugins.tooltip.boxPadding = 5;
  Chart.defaults.plugins.tooltip.titleColor = THEME.text;
  Chart.defaults.plugins.tooltip.titleFont = { family: THEME.fontMono, size: 11 };
  Chart.defaults.plugins.tooltip.bodyFont = { family: THEME.fontMono, size: 12 };
}

async function init() {
  try {
    const resp = await fetch('data.json');
    DATA = await resp.json();
  } catch (e) {
    return;
  }

  applyChartTheme();

  const el = document.getElementById('updated');
  if (el) el.textContent = 'Last updated ' + new Date(DATA.generated).toLocaleString();

  renderLeaderboard();
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

function displayName(ssg) {
  return ssg.charAt(0).toUpperCase() + ssg.slice(1);
}

function renderLeaderboard() {
  var container = document.getElementById('leaderboard-list');
  if (!container) return;
  var run = latestRun();

  var rows = [];
  getSSGs().forEach(function(ssg) {
    var results = run.results.filter(function(r) { return r.ssg === ssg; });
    if (!results.length) return;
    var maxPc = Math.max.apply(null, results.map(function(r) { return r.page_count; }));
    var entry = results.find(function(r) { return r.page_count === maxPc; });
    rows.push({ ssg: ssg, entry: entry });
  });
  if (!rows.length) return;

  var refPc = Math.max.apply(null, rows.map(function(r) { return r.entry.page_count; }));
  var main = rows.filter(function(r) { return r.entry.page_count === refPc; })
    .sort(function(a, b) { return a.entry.avg_time_ms - b.entry.avg_time_ms; });
  var rest = rows.filter(function(r) { return r.entry.page_count !== refPc; })
    .sort(function(a, b) { return b.entry.page_count - a.entry.page_count || a.entry.avg_time_ms - b.entry.avg_time_ms; });
  var ordered = main.concat(rest);
  var slowest = Math.max.apply(null, ordered.map(function(r) { return r.entry.avg_time_ms; }));

  var note = document.getElementById('leaderboard-note');
  if (note) note.textContent = 'avg build time @ ' + refPc.toLocaleString() + ' pages';

  container.innerHTML = ordered.map(function(row, i) {
    var meta = SSG_META[row.ssg] || { color: '#888', lang: '?', desc: '' };
    var pct = Math.max(1.5, (row.entry.avg_time_ms / slowest) * 100);
    var isFirst = i === 0 && row.entry.page_count === refPc;
    var pcNote = row.entry.page_count !== refPc
      ? '<small>@ ' + row.entry.page_count.toLocaleString() + ' pages</small>' : '';
    return '<div class="lb-row' + (isFirst ? ' first' : '') + '">' +
      '<span class="lb-rank">' + String(i + 1).padStart(2, '0') + '</span>' +
      '<span class="lb-name" title="' + meta.desc + '">' +
        '<span class="dot" style="--c:' + meta.color + '"></span>' +
        displayName(row.ssg) +
        '<span class="lb-lang">' + meta.lang + '</span>' +
        (isFirst ? '<span class="lb-badge">FASTEST</span>' : '') +
      '</span>' +
      '<span class="lb-track"><span class="lb-fill" style="--c:' + meta.color + ';width:' + pct.toFixed(1) + '%;animation-delay:' + (150 + i * 70) + 'ms"></span></span>' +
      '<span class="lb-time">' + formatMs(row.entry.avg_time_ms) + pcNote + '</span>' +
      '</div>';
  }).join('');
}

function lineDataset(ssg, data) {
  var meta = SSG_META[ssg] || { color: '#888' };
  return {
    label: displayName(ssg),
    data: data,
    borderColor: meta.color,
    backgroundColor: meta.color,
    borderWidth: 2,
    tension: 0.35,
    pointRadius: 3.5,
    pointHoverRadius: 6,
    pointBackgroundColor: THEME.panelBg,
    pointBorderColor: meta.color,
    pointBorderWidth: 1.5,
    fill: false,
    spanGaps: true
  };
}

function chartOptions() {
  return {
    responsive: true,
    maintainAspectRatio: false,
    interaction: { mode: 'index', intersect: false },
    plugins: {
      tooltip: {
        itemSort: function(a, b) { return a.parsed.y - b.parsed.y; },
        callbacks: { label: function(ctx) { return ' ' + ctx.dataset.label + ': ' + formatMs(ctx.raw); } }
      }
    },
    scales: {
      y: {
        ticks: { font: { family: THEME.fontMono, size: 11 }, callback: function(v) { return formatMs(v); } },
        grid: { color: THEME.grid },
        border: { display: false }
      },
      x: {
        ticks: { font: { family: THEME.fontMono, size: 11 } },
        grid: { display: false },
        border: { display: false }
      }
    }
  };
}

function renderScalingChart() {
  var canvas = document.getElementById('scalingChart');
  if (!canvas) return;
  var run = latestRun();
  var ssgs = getSSGs();
  var pageCounts = getPageCounts();

  var datasets = ssgs.map(function(ssg) {
    var data = pageCounts.map(function(pc) {
      var entry = run.results.find(function(r) { return r.ssg === ssg && r.page_count === pc; });
      return entry ? entry.avg_time_ms : null;
    });
    return lineDataset(ssg, data);
  });

  new Chart(canvas, {
    type: 'line',
    data: { labels: pageCounts.map(function(pc) { return pc.toLocaleString() + ' pages'; }), datasets: datasets },
    options: chartOptions()
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
    wrapper.innerHTML = '<h3>' + pc.toLocaleString() + ' Pages</h3><div class="chart-wrapper"><canvas></canvas></div>';
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
        labels: ssgs.map(displayName),
        datasets: [{
          data: data,
          backgroundColor: colors.map(function(c) { return c + 'D9'; }),
          hoverBackgroundColor: colors,
          borderWidth: 0,
          borderRadius: 6,
          maxBarThickness: 42
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: { callbacks: { label: function(ctx) { return ' ' + formatMs(ctx.raw); } } }
        },
        scales: {
          y: {
            ticks: { font: { family: THEME.fontMono, size: 11 }, callback: function(v) { return formatMs(v); } },
            grid: { color: THEME.grid },
            border: { display: false }
          },
          x: {
            ticks: { font: { family: THEME.fontMono, size: 11 } },
            grid: { display: false },
            border: { display: false }
          }
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
    var data = runs.map(function(r) {
      var entry = r.results.find(function(d) { return d.ssg === ssg && d.page_count === selectedPageCount; });
      return entry ? entry.avg_time_ms : null;
    });
    return lineDataset(ssg, data);
  });

  if (trendChart) trendChart.destroy();
  trendChart = new Chart(canvas, {
    type: 'line',
    data: { labels: labels, datasets: datasets },
    options: chartOptions()
  });
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
        '<td class="mono">' + r.run + '</td>' +
        '<td><span class="ssg-badge" style="background:' + meta.color + '"></span><span class="ssg-name">' + r.ssg + '</span></td>' +
        '<td class="num mono">' + r.page_count.toLocaleString() + '</td>' +
        '<td class="num">' + r.avg_time_ms.toLocaleString() + '</td>' +
        '<td class="num dim">' + r.min_time_ms.toLocaleString() + '</td>' +
        '<td class="num dim">' + r.max_time_ms.toLocaleString() + '</td>' +
        '</tr>';
    }).join('');

    document.querySelectorAll('#resultsTable th').forEach(function(th) {
      var existing = th.querySelector('.sort-icon');
      if (existing) existing.remove();
      if (th.dataset.col === sortCol) {
        var span = document.createElement('span');
        span.className = 'sort-icon';
        span.textContent = sortAsc ? ' ↑' : ' ↓';
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
