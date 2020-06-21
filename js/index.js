var COLORS = [
  '#4C00FF',
  '#004CFF',
  '#00E5FF',
  '#00FF4D',
  '#4DFF00',
  '#E6FF00',
  '#FFFF00',
  '#FFDE59',
  '#FFE0B3',
];

function drawChart(csv) {
  let area_ym = {};
  let areas = [];
  let yms = [];
  csv.split('\n').forEach((line, i) => {
    if (i == 0) {
      return;
    }
    if (line == '') {
      return;
    }
    let row = line.split("\t");
    let year = row[0];
    let month = row[1];
    let area = row[2];
    let prefecture = row[3];
    let accidents = Number(row[4]);

    let ym = year + '/' + (month >= 10 ? month : ('0' + month));

    if (!areas.includes(area)) {
      areas.push(area);
    }

    if (!yms.includes(ym)) {
      yms.push(ym);
    }

    if (!area_ym[area]) {
      area_ym[area] = {};
    }

    if (prefecture == '計' && area != '合計') {
      area_ym[area][ym] = accidents;
    }
  });

  yms.sort();

  let datasets = [];
  areas.forEach((area, i) => {
    datasets.push({
      label: area,
      lineTension: 0,
      backgroundColor: COLORS[i % COLORS.length],
      borderColor: 'black',
      borderWidth: 1,
      data: yms.map(ym => area_ym[area][ym])
    });
  });

  let config = {
    type: 'bar',
    data: {
      labels: yms,
      datasets: datasets
    },
    options: {
      scales: {
        xAxes: [{
          stacked: true,
        }],
        yAxes: [{
          stacked: true,
          ticks: {
            beginAtZero: true
          }
        }]
      }
    }
  };

  let ctx = document.getElementById("myChart").getContext("2d");
  let myChart = new Chart(ctx, config);
}

let req = new XMLHttpRequest();
req.open("GET", 'tsv/monthly-traffic-accidents-in-japan.tsv', true);
req.onload = function() {
  drawChart(req.responseText);
}
req.send(null);
