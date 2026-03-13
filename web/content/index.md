+++
title = "Dashboard"
description = "Static Site Generator Build Performance Benchmark"
+++

<p id="updated" style="color: var(--text-muted); font-size: 0.9rem; margin-bottom: 24px;"></p>

<div class="cards" id="ssg-cards"></div>

<div class="section">
  <h2>Build Scaling Performance</h2>
  <div class="chart-wrapper"><canvas id="scalingChart"></canvas></div>
</div>

<div class="section">
  <h2>Build Time by Page Count</h2>
  <div class="bar-grid" id="barCharts"></div>
</div>

<div class="section">
  <h2>Historical Trends</h2>
  <div class="controls" id="trendControls"></div>
  <div class="chart-wrapper"><canvas id="trendChart"></canvas></div>
</div>

<div class="section">
  <h2>All Results</h2>
  <div style="overflow-x:auto">
    <table id="resultsTable">
      <thead><tr>
        <th data-col="run">Run</th>
        <th data-col="ssg">SSG</th>
        <th data-col="page_count">Pages</th>
        <th data-col="avg_time_ms">Avg (ms)</th>
        <th data-col="min_time_ms">Min (ms)</th>
        <th data-col="max_time_ms">Max (ms)</th>
      </tr></thead>
      <tbody></tbody>
    </table>
  </div>
</div>
