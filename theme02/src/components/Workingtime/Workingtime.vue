<template>
    <div>
        <h1>Workingtime</h1>
            <div class="align-content-center">
                <h1>{{ user.email }}</h1>
                <button v-on:click="onStartInputWorkingTime" class="btn btn-lg btn-primary btn-block" type="button">Start working time</button>
                <h2 v-if="startInputWorkingTime">{{ startInputWorkingTime}}</h2>
            </div>
            <div class="align-content-center">
                <button v-on:click="onEndInputWorkingTime" class="btn btn-lg btn-primary btn-block" type="button">End working time</button>
                <h2 v-if="endInputWorkingTime">{{ endInputWorkingTime}}</h2>
            </div>
    </div>

</template>

<script>
    export default {
        name: "Workingtime",
        props: {
            user: Object
        },
        data() {
            return {
                startInputWorkingTime: null,
                endInputWorkingtime: null
            }
        },
        methods: {
            onStartInputWorkingTime() {
                {
                    var currentDateWithFormat = new Date().toJSON().slice(0,19).replace(/T/g,' ');
                   this.startInputWorkingTime = currentDateWithFormat;
                    var myHeaders = new Headers();
                    myHeaders.append("Content-Type", "application/json");

                    var rawWorkingTimes = JSON.stringify({
                        "workingtimes":
                            {
                                "end": currentDateWithFormat,
                                "start": currentDateWithFormat
                            }
                    });

                    var requestOptionsWorkingTimes = {
                        method: 'POST',
                        headers: myHeaders,
                        body: rawWorkingTimes,
                        redirect: 'follow'
                    };

                    var rawClocks = JSON.stringify({
                        "clocks":
                            {
                                "status": true,
                                "time": currentDateWithFormat
                            }
                    });

                    var requestOptionsClocks = {
                        method: 'POST',
                        headers: myHeaders,
                        body: rawClocks,
                        redirect: 'follow'
                    };

                    fetch("http://localhost:4000/api/workingtimes/" + this.user.id, requestOptionsWorkingTimes)
                        .then(response => response.text())
                        .then(result => {
                            console.log(result)
                            fetch("http://localhost:4000/api/clocks/" + this.user.id, requestOptionsClocks)
                                .then(response => response.text())
                                .then(result => console.log(result))
                                        .catch(error => console.log('error', error))
                        })
                        .catch(error => console.log('error', error));
                }
            },

        onEndInputWorkingTime() {
            {
                var currentDateWithFormat = new Date().toJSON().slice(0,19).replace(/T/g,' ');
                this.endInputWorkingTime = currentDateWithFormat;
                var myHeaders = new Headers();
                myHeaders.append("Content-Type", "application/json");

                var rawWorkingTimes = JSON.stringify({
                    "workingtimes":
                        {
                            "end": currentDateWithFormat,
                        }
                });

                var requestOptionsWorkingTimes = {
                    method: 'PUT',
                    headers: myHeaders,
                    body: rawWorkingTimes,
                    redirect: 'follow'
                };

                var rawClocks = JSON.stringify({
                    "clocks":
                        {
                            "status": false,
                            "time": currentDateWithFormat
                        }
                });

                var requestOptionsClocks = {
                    method: 'POST',
                    headers: myHeaders,
                    body: rawClocks,
                    redirect: 'follow'
                };

                fetch("http://localhost:4000/api/workingtimes/" + this.user.id, requestOptionsWorkingTimes)
                    .then(response => response.text())
                    .then(result => {
                        console.log(result)
                        fetch("http://localhost:4000/api/clocks/" + this.user.id, requestOptionsClocks)
                            .then(response => response.text())
                            .then(result => console.log(result))
                            .catch(error => console.log('error', error))
                    })
                    .catch(error => console.log('error', error));
            }
        },
    }


    }
</script>

<style scoped>

</style>