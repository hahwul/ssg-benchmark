+++
title = "Dashboard"
description = "Static Site Generator Build Performance Benchmark"
+++

<div class="page-head">
  <h1>Build Performance</h1>
  <p id="updated" class="updated"></p>
</div>

<section class="panel triptych-panel" id="triptychPanel" hidden>
  <div class="panel-head">
    <div>
      <span class="kicker">Workloads</span>
      <h2>Three scenarios, one glance</h2>
    </div>
    <span class="panel-note" id="triptychNote"></span>
  </div>
  <div class="triptych" id="scenarioTriptych"></div>
</section>

<div class="controls scenario-controls" id="scenarioControls"></div>
<p class="updated scenario-note" id="scenarioNote"></p>

<section class="panel">
  <div class="panel-head">
    <div>
      <span class="kicker">Latest run</span>
      <h2>Leaderboard</h2>
    </div>
    <span class="panel-note" id="leaderboard-note"></span>
  </div>
  <div class="leaderboard" id="leaderboard-list"></div>
</section>

<section class="panel">
  <div class="panel-head">
    <div>
      <span class="kicker">Scaling</span>
      <h2>Build Scaling Performance</h2>
    </div>
  </div>
  <div class="chart-wrapper"><canvas id="scalingChart"></canvas></div>
</section>

<section class="panel">
  <div class="panel-head">
    <div>
      <span class="kicker">Comparison</span>
      <h2>Build Time by Page Count</h2>
    </div>
  </div>
  <div class="bar-grid" id="barCharts"></div>
</section>

<section class="panel">
  <div class="panel-head">
    <div>
      <span class="kicker">History</span>
      <h2>Historical Trends</h2>
    </div>
  </div>
  <div class="controls" id="trendControls"></div>
  <div class="chart-wrapper"><canvas id="trendChart"></canvas></div>
</section>

<section class="panel">
  <div class="panel-head">
    <div>
      <span class="kicker">Raw data</span>
      <h2>All Results</h2>
    </div>
  </div>
  <div class="table-scroll">
    <table id="resultsTable">
      <thead><tr>
        <th data-col="run">Run</th>
        <th data-col="ssg">SSG</th>
        <th data-col="scenario">Scenario</th>
        <th data-col="page_count" class="num">Pages</th>
        <th data-col="avg_time_ms" class="num">Med (ms)</th>
        <th data-col="min_time_ms" class="num">Min (ms)</th>
        <th data-col="max_time_ms" class="num">Max (ms)</th>
      </tr></thead>
      <tbody></tbody>
    </table>
  </div>
</section>
