<template>
  <form class="form-signin">
    <img class="mb-4" src="../../assets/logo.png" alt="" width="250" height="250">
    <h1 class="h3 mb-3 font-weight-normal">Please sign in</h1>
    <label for="loginInputEmail" class="sr-only">Email address</label>
    <input v-model="loginInputEmail" type="email" id="loginInputEmail" class="form-control"
           placeholder="Email address" required autofocus>
    <label for="loginInputUsername" class="sr-only">Password</label>
    <input v-model="loginInputUsername" type="text" id="loginInputUsername" class="form-control"
           placeholder="Username" required>
    <button v-on:click="getUser" class="btn btn-lg btn-primary btn-block" type="button">Sign in</button>
    <p class="mt-5 mb-3 text-muted">&copy; 2017-2020</p>
  </form>
</template>

<script>
export default {
  name: "Login",
  data() {
    return {
      loginInputUsername: null,
      loginInputEmail: null
    }
  },
  methods: {
    getUser() {
      //debug
      console.log(this.loginInputUsername)
      console.log(this.loginInputEmail)

      var requestOptions = {
        method: 'GET',
        redirect: 'follow'
      };

      fetch('http://localhost:4000/api/users?email=' + this.loginInputEmail + '&username=' + this.loginInputUsername, requestOptions)
          .then(function(response) {
            if (!response.ok) {
              throw Error(response.statusText);
            }
            return response;
          })
          .then(response => response.text())
          .then(result => {
            console.log(result)
            result = JSON.parse(result);
            console.log(result)
            // result looks like this:
            //{"data": {"email": "123@man", "id": 1, "username": "test"}}
            this.updateCurrentUser(result.data);
            this.$router.push("/");
          })
          .catch(error => console.log('error', error));
    },
    updateCurrentUser: function (loggedUser) {
      this.$emit('successful-login', loggedUser);
    }
  }
}
</script>

<style scoped>
html,
body {
  height: 100%;
}

body {
  display: -ms-flexbox;
  display: flex;
  -ms-flex-align: center;
  align-items: center;
  padding-top: 40px;
  padding-bottom: 40px;
  background-color: #f5f5f5;
}

.form-signin {
  width: 100%;
  max-width: 330px;
  padding: 15px;
  margin: auto;
}

.form-signin .checkbox {
  font-weight: 400;
}

.form-signin .form-control {
  position: relative;
  box-sizing: border-box;
  height: auto;
  padding: 10px;
  font-size: 16px;
}

.form-signin .form-control:focus {
  z-index: 2;
}

.form-signin input[type="email"] {
  margin-bottom: -1px;
  border-bottom-right-radius: 0;
  border-bottom-left-radius: 0;
}

.form-signin input[type="password"] {
  margin-bottom: 10px;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}
</style>