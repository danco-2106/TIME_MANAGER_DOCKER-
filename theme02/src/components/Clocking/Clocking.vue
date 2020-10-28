<template>
  <div>
    <h1>Clockings</h1>
<!--    <button v-on:click="getClockingData" type="button">Refresh data</button>-->
    <grid
        :auto-width="autoWidth"
        :cols="cols"
        :language="language"
        :pagination="pagination"
        :rows="rows"
        :search="search"
        :sort="sort"
        :width="width"
    ></grid>
  </div>
</template>

<script>
import Grid from 'gridjs-vue'

export default {
  name: "Clocking",
  props: {
    user: Object
  },
  created() {
    this.getClockingData();
  },
  methods: {
    getClockingData() {
      //returns all the clocks for the user currently logged in
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
            result = JSON.parse(result);
            result = result.data;
            // console.log(result)
            this.rows = [];
            result.forEach(element => {
              // console.log(element);
              let status = "";
              if (element.status)
                status = "Active";
              else
                status = "Inactive";

              let row = [element.id, status, element.time.replace('T', ' ')];
              this.rows.push(row);
            })

          })
          .catch(error => console.log('error', error));
    },
  },
  data() {
    return {
      cols: ['id', 'status', 'time'],
      rows: [],
      // OPTIONAL:
      // Boolean to automatically set table width
      autoWidth: true,
      // Localization dictionary object
      language: {},
      // Boolean or pagination settings object
      pagination: true,
      // Boolean or search settings object
      search: false,
      // Boolean or sort settings object
      sort: true,
      // String with name of theme or 'none' to disable
      theme: 'none',
      // String with css width value
      width: '100%',
    }
  },
  components: {
    Grid
  }
}
</script>

<style scoped>

</style>