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

function createDataset(label, backgroundColor, data) {
  return {
    label: label,
    lineTension: 0,
    backgroundColor: backgroundColor,
    borderColor: 'black',
    borderWidth: 1,
    data: data
  };
}
function createConfig(yms, datasets, title) {
  return {
    type: 'bar',
    data: {
      labels: yms,
      datasets: datasets
    },
    options: {
      title: {
        display: true,
        text: title,
      },
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
}

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
    let v0 = Number(row[4]);
    let v1 = Number(row[5]);
    let v2 = Number(row[6]);

    let ym = year + '/' + (month >= 10 ? month : ('0' + month));

    if (year < 2015) {
      return;
    }

    if (prefecture == '計' && area != '合計') {
      if (!areas.includes(area)) {
        areas.push(area);
      }

      if (!yms.includes(ym)) {
        yms.push(ym);
      }

      if (!area_ym[area]) {
        area_ym[area] = {};
      }
      area_ym[area][ym] = [v0, v1, v2];
    }
  });

  yms.sort();

  let datasets0 = [];
  let datasets1 = [];
  let datasets2 = [];
  areas.forEach((area, i) => {
    datasets0.push(createDataset(area, COLORS[i % COLORS.length], yms.map(ym => area_ym[area][ym][0])));
    datasets1.push(createDataset(area, COLORS[i % COLORS.length], yms.map(ym => area_ym[area][ym][1])));
    datasets2.push(createDataset(area, COLORS[i % COLORS.length], yms.map(ym => area_ym[area][ym][2])));
  });

  let ctx0 = document.getElementById("chart0").getContext("2d");
  let chart0 = new Chart(ctx0, createConfig(yms, datasets0, "発生件数（速報値）"));

  let ctx1 = document.getElementById("chart1").getContext("2d");
  let chart1 = new Chart(ctx1, createConfig(yms, datasets1, "死者数（確定値）"));

  let ctx2 = document.getElementById("chart2").getContext("2d");
  let chart2 = new Chart(ctx2, createConfig(yms, datasets2, "負傷者数（速報値）"));
}

let req = new XMLHttpRequest();
req.open("GET", 'tsv/monthly-traffic-accidents-in-japan.tsv', true);
req.onload = function() {
  drawChart(req.responseText);
}
req.send(null);
