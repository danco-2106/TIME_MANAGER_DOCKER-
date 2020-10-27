<template>
  <div>
    <donut-chart
        id="donut"
        :data="donutData"
        colors='[ "#FF6384", "#36A2EB", "#FFCE56" ]'
        resize="true">
    </donut-chart>
    <button v-on:click="getClockingData" type="button">TEST</button>
  </div>
</template>

<script>
import {DonutChart} from 'vue-morris'

export default {
  name: "Clocking",
  props: {
    user: Object
  },
  methods: {
    getClockingData() {

      var requestOptions = {
        method: 'GET',
        redirect: 'follow'
      };

      fetch("http://localhost:4000/api/clocks/" + this.user.id, requestOptions)
          .then(function (response) {
            if (!response.ok) {
              throw Error(response.statusText);
            }
            return response;
          })
          .then(response => response.text())
          .then(result => {
            console.log(result);
            result = JSON.parse(result);
            console.log(result);
            // result.data.forEach(it => {
            //   let date = new Date(it.time);
            //   let year = date.getFullYear();
            //   console.log(year);
            //
            // });
            // var aestTime = new Date().toLocaleString("en-US", {timeZone: "Europe/Paris"});
            // console.log('Europe time: '+ (new Date(aestTime)).toISOString())
          })
          .catch(error => console.log('error', error));
    }
  },
  data() {
    return {
      donutData: [
        {label: '2019', value: 14},
        {label: '2020', value: 34},
        {label: '2021', value: 10},
        {label: '2022', value: 100},
        {label: '2023', value: 780},
        {label: '2024', value: 960},
        {label: '2025', value: 1050},
        {label: '2026', value: 140},
        {label: '2027', value: 90},
        {label: '2028', value: 50},
        {label: '2029', value: 10}
      ]
    }
  },
  components: {
    DonutChart
  }
}
</script>

<style scoped>

</style>