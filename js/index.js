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

let area_ym = {};
var areas = [];
var yms = [];
csv.forEach(row => {
  let year = row[0];
  let month = row[1];
  let area = row[2];
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

  if (!area_ym[area][ym]) {
    area_ym[area][ym] = 0;
  }

  area_ym[area][ym] += accidents;
});

yms.sort();

var datasets = [];
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

var config = {
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

var ctx = document.getElementById("myChart").getContext("2d");
var myChart = new Chart(ctx, config);
