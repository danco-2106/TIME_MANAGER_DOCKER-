<template>
  <div>
    <h1>My dashboard</h1>

    <div class="container">
      <div class="row">
        <div class="col-sm">

          <!--          FOR DEBUGGING-->
<!--          <p>Max date: {{ maxDate == null ? "No data" : maxDate }}</p>-->
<!--          <p>Min date: {{ minDate == null ? "No data" : minDate }}</p>-->
<!--          <button v-on:click="getWorkingtimes" type="button">TEST</button>-->
<!--          {{ this.donutData }}-->
<!--          {{ this.donutKey }}-->
<!--          <button v-on:click="forceAllRerender" type="button">Refresh all</button>-->
          <donut-chart
              id="donut"
              :key="donutKey"
              :data="donutData"
              colors='[ "#FF6384", "#36A2EB" ]'
              resize="true">
          </donut-chart>
          <h2>Working times statistics</h2>
          <table class="table ">
            <tbody>
            <tr>
              <th scope="row">Total Working time</th>
              <td>{{ totalWT == null ? "No data" : (totalWT / (1000 * 60 * 60)).toFixed(2) + " hrs" }}</td>

            </tr>
            <tr>
              <th scope="row">Total time</th>
              <td>{{ totalTime == null ? "No data" : (totalTime / (1000 * 60 * 60)).toFixed(2) + " hrs" }}</td>

            </tr>
            <tr>
              <th scope="row">Total number of workingtimes</th>
              <td>{{ totalNbOfWT == null ? "No data" : totalNbOfWT }}</td>

            </tr>
            <tr>
              <th scope="row">Worktime average duration</th>
              <td>{{ avgWT == null ? "No data" : (avgWT / (1000 * 60 * 60)).toFixed(2) + " hrs" }}</td>

            </tr>
            <tr>
              <th scope="row">Longest worktime</th>
              <td>{{ longestWT == null ? "No data" : (longestWT / (1000 * 60 * 60)).toFixed(2) + " hrs" }}</td>

            </tr>
            <tr>
              <th scope="row">Shortest worktime</th>
              <td>{{ shortestWT == null ? "No data" : (shortestWT / (1000 * 60 * 60)).toFixed(2) + " hrs" }}</td>

            </tr>
            </tbody>
          </table>
        </div>
        <div class="col-sm">
          <line-chart
              id="line"
              :data="lineData"
              :key="lineKey"
              xkey="year"
              ykeys='["value"]'
              colors='[ "#FF6384", "#36A2EB" ]'
              grid="true"
              grid-text-weigth="bold"
              resize="true">
          </line-chart>
          <br>
          <bar-chart
              id="bar"
              :data="barData"
              :key="barKey"
              xkey="year"
              ykeys='["and", "ios", "win"]'
              colors='[ "#FF6384", "#36A2EB" ]'
              grid="true"
              grid-text-weigth="bold"
              resize="true">
          </bar-chart>
        </div>
      </div>
    </div>
  </div>

</template>

<script>
// import {DonutChart, BarChart, LineChart, AreaChart} from 'vue-morris';
import {DonutChart, LineChart, BarChart} from 'vue-morris';

export default {

  name: "Dashboard",
  props: {
    user: Object
  },
  created() {
    this.getWorkingtimes();
  },
  methods: {
    //to force the re-render of the charts to show the changes in data
    forceAllRerender() {
      this.donutKey += 1;
      this.barKey += 1;
      this.lineKey += 1;
    },
    forceDonutRerender() {
      this.donutKey += 1;
    },
    forceBarRerender() {
      this.barKey += 1;
    },
    forceLineRerender() {
      this.lineKey += 1;
    },
    getWorkingtimes() {
      this.totalWT = 0;
      let requestOptions = {
        method: 'GET',
        redirect: 'follow'
      };
      fetch("http://localhost:4000/api/workingtimes/" + this.user.id + "?start=2000-01-01 01:01:01&end=9000-01-01 01:01:01", requestOptions)
          .then(function (response) {
            if (!response.ok) {
              throw Error(response.statusText);
            }
            return response;
          })
          .then(response => response.json())
          .then(result => {
            result = result.data;
            // console.log(result);
            let dates = [];
            let workingTimes = [];
            this.totalNbOfWT = result.length;
            result.forEach(element => {
              // console.log(element);
              let end = new Date(element.end);
              let start = new Date(element.start);
              let workTime = end.getTime() - start.getTime();
              dates.push(end);
              dates.push(start);
              workingTimes.push(workTime);
              this.totalWT += (workTime);
            });
            this.shortestWT = Math.min.apply(null, workingTimes);
            this.longestWT = Math.max.apply(null, workingTimes);
            this.avgWT = (this.totalWT / this.totalNbOfWT).toFixed(2);
            //calculate the total time between the min date and max date to get the total time.
            //getTime() returns the times in ms since 1970/01/01
            this.maxDate = new Date(Math.max.apply(null, dates));
            this.minDate = new Date(Math.min.apply(null, dates));
            this.totalTime = (this.maxDate.getTime() - this.minDate.getTime());

            //donutData[0] is the time worked.
            this.donutData[0].value = (this.totalWT / (1000 * 60 * 60)).toFixed(2);
            //donutData[1] is the time NOT worked.
            this.donutData[1].value = ((this.totalTime - this.totalWT) / (1000 * 60 * 60)).toFixed(2);
            this.forceDonutRerender();
          })
          .catch(error => console.log('error', error));
    }
  },
  data() {
    return {
      donutKey: 0,
      lineKey: 0,
      barKey: 0,
      donutData: [
        {label: 'Working Time', value: 0.12},
        {label: 'Rest time', value: 0}
      ],
      lineData: [
        {year: '2020', value: 1},
        {year: '2021', value: 2},
        {year: '2022', value: 5},
        {year: '2023', value: 3},
        {year: '2024', value: 4}

      ],
      barData: [
        {year: '2020', and: 10, ios: 5, win: 2},
        {year: '2021', and: 10, ios: 15, win: 3},
        {year: '2022', and: 20, ios: 25, win: 2},
        {year: '2023', and: 30, ios: 20, win: 1},
      ],
      totalWT: 0,
      totalTime: 0,
      totalNbOfWT: 0,
      avgWT: 0,
      longestWT: 0,
      shortestWT: 0,
      maxDate: null,
      minDate: null
    }
  },
  components: {
    // DonutChart, BarChart, LineChart, AreaChart
    DonutChart, LineChart, BarChart
  }
}
</script>

<style scoped>

</style>