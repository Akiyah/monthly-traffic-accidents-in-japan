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
  let age_group_ym = {};
  let age_groups = [];
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
    let age_group = row[2];
    let value = Number(row[4]);

    let ym = year + '/' + (month >= 10 ? month : ('0' + month));

    if (!age_groups.includes(age_group)) {
      age_groups.push(age_group);
    }

    if (!yms.includes(ym)) {
      yms.push(ym);
    }

    if (!age_group_ym[age_group]) {
      age_group_ym[age_group] = {};
    }
    if (!age_group_ym[age_group][ym]) {
      age_group_ym[age_group][ym] = 0;
    }
    age_group_ym[age_group][ym] += value;
  });

  yms.sort();

  let datasets0 = [];
  areas.forEach((area, i) => {
    datasets0.push(createDataset(age_groups, COLORS[i % COLORS.length], yms.map(ym => age_group_ym[age_group][ym])));
  });

  let ctx0 = document.getElementById("chart0").getContext("2d");
  let chart0 = new Chart(ctx0, createConfig(yms, datasets0, "年齢層別・状態別死者数の推移"));
}

let req = new XMLHttpRequest();
req.open("GET", 'tsv/age_group.tsv', true);
req.onload = function() {
  drawChart(req.responseText);
}
req.send(null);
